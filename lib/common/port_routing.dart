import 'package:fl_clash/models/port_routing.dart';
import 'package:fl_clash/models/clash_config.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:yaml/yaml.dart';

enum PortRoutingIssue {
  invalidPort,
  duplicatePort,
  invalidBinding,
  invalidFilter,
  unsupportedSubscription,
  emptySubscription,
  duplicateNode,
  missingSubscription,
  portOccupied,
  coreUnavailable,
  staleUpdate,
  sourceInUse,
  updateFailed,
}

class PortRoutingException implements Exception {
  final PortRoutingIssue issue;

  const PortRoutingException(this.issue);

  @override
  String toString() => 'PortRoutingException(${issue.name})';
}

String portProviderName(int profileId) => 'flclash_ports_source_$profileId';

String portNodePrefix(int profileId) => '[ports:$profileId] ';

PatchClashConfig portRoutingPatch(PatchClashConfig saved) => saved.copyWith(
  mixedPort: 0,
  port: 0,
  socksPort: 0,
  redirPort: 0,
  tproxyPort: 0,
  allowLan: false,
  tun: saved.tun.copyWith(enable: false),
  externalController: ExternalControllerStatus.close,
  mode: Mode.rule,
);

List<Map<String, dynamic>> portSubscriptionNodes(String source) {
  final Object? document;
  try {
    document = loadYaml(source);
  } on YamlException {
    throw const PortRoutingException(PortRoutingIssue.unsupportedSubscription);
  }
  if (document is! Map ||
      document['proxy-providers'] is Map &&
          (document['proxy-providers'] as Map).isNotEmpty) {
    throw const PortRoutingException(PortRoutingIssue.unsupportedSubscription);
  }
  final nodes = document['proxies'];
  if (nodes is! List || nodes.isEmpty) {
    throw const PortRoutingException(PortRoutingIssue.emptySubscription);
  }
  final names = <String>{};
  return [for (final node in nodes) _portNode(node, names)];
}

Map<String, dynamic> _portNode(Object? value, Set<String> names) {
  if (value is! Map ||
      value['name'] is! String ||
      (value['name'] as String).isEmpty ||
      value['type'] is! String ||
      {
        'direct',
        'reject',
        'pass',
        'compatible',
        'dns',
        'rematch',
      }.contains((value['type'] as String).toLowerCase()) ||
      value['dialer-proxy'] != null && value['dialer-proxy'] != '') {
    throw const PortRoutingException(PortRoutingIssue.unsupportedSubscription);
  }
  if (!names.add(value['name'] as String)) {
    throw const PortRoutingException(PortRoutingIssue.duplicateNode);
  }
  return Map<String, dynamic>.from(value);
}

void validatePortBindings(List<PortBinding> bindings) {
  final ports = <int>{};
  final ids = <int>{};
  for (final binding in bindings) {
    if (binding.port < 1024 || binding.port > 65535) {
      throw const PortRoutingException(PortRoutingIssue.invalidPort);
    }
    if (!ports.add(binding.port)) {
      throw const PortRoutingException(PortRoutingIssue.duplicatePort);
    }
    if (!ids.add(binding.id) ||
        binding.name.trim().isEmpty ||
        binding.id <= 0 ||
        binding.profileId <= 0 ||
        binding.selection == PortSelection.fixed && binding.node.isEmpty) {
      throw const PortRoutingException(PortRoutingIssue.invalidBinding);
    }
    if (binding.selection == PortSelection.region) {
      if (_regionWords(binding.filter).isEmpty) {
        throw const PortRoutingException(PortRoutingIssue.invalidFilter);
      }
    }
  }
}

List<String> matchingPortNodes(PortBinding binding, Iterable<String> names) {
  if (binding.selection == PortSelection.fixed) {
    return names.where((name) => name == binding.node).toList();
  }
  final words = _regionWords(binding.filter);
  return names.where((name) => words.any(name.toLowerCase().contains)).toList();
}

List<String> _regionWords(String filter) => filter
    .split('|')
    .map((word) => word.trim().toLowerCase())
    .where((word) => word.isNotEmpty)
    .toList();

String _portPattern(String value) =>
    RegExp.escape(value).replaceAll('`', r'\x60');

typedef PortRoutingFragment = ({
  Map<String, dynamic> config,
  Map<String, dynamic> providers,
});

PortRoutingFragment compilePortRouting({
  required List<PortBinding> bindings,
  required Map<int, String> sourcePaths,
  required String testUrl,
}) {
  validatePortBindings(bindings);
  final active = bindings.where((binding) => binding.enabled).toList();
  for (final binding in active) {
    if (!sourcePaths.containsKey(binding.profileId)) {
      throw const PortRoutingException(PortRoutingIssue.missingSubscription);
    }
  }
  return (
    providers: {
      for (final id in active.map((binding) => binding.profileId).toSet())
        portProviderName(id): {
          'type': 'file',
          'path': sourcePaths[id],
          'override': {'additional-prefix': portNodePrefix(id)},
          'health-check': {
            'enable': true,
            'url': testUrl,
            'interval': 300,
            'lazy': true,
          },
        },
    },
    config: {
      'rules': ['MATCH,REJECT'],
      'proxy-groups': [
        for (final binding in active)
          {
            'name': binding.groupName,
            'type': binding.selection == PortSelection.fixed
                ? 'select'
                : 'url-test',
            'use': [portProviderName(binding.profileId)],
            'filter': binding.selection == PortSelection.fixed
                ? '^${_portPattern('${portNodePrefix(binding.profileId)}${binding.node}')}\$'
                : '(?i)^${_portPattern(portNodePrefix(binding.profileId))}.*(?:${_regionWords(binding.filter).map(_portPattern).join('|')}).*\$',
            'empty-fallback': 'REJECT',
            'hidden': true,
            if (binding.selection == PortSelection.region) ...{
              'url': testUrl,
              'interval': 300,
              'tolerance': 50,
              'lazy': true,
            },
          },
      ],
      'listeners': [
        for (final binding in active)
          {
            'name': binding.listenerName,
            'type': 'mixed',
            'listen': '127.0.0.1',
            'port': binding.port,
            'udp': false,
            'users': <Map<String, String>>[],
            'proxy': binding.groupName,
          },
      ],
    },
  );
}
