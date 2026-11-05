import 'dart:convert';
import 'dart:io';

import 'package:fl_clash/common/port_probe.dart';
import 'package:fl_clash/common/port_routing.dart';
import 'package:fl_clash/common/task.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

const fixed = PortBinding(
  id: 1,
  name: 'Browser',
  profileId: 11,
  port: 18081,
  node: 'US [01]',
);
const regional = PortBinding(
  id: 2,
  name: 'Editor',
  profileId: 22,
  port: 18082,
  selection: PortSelection.region,
  filter: 'JP|日本',
);

void main() {
  test('dedicated runtime settings leave the saved host settings intact', () {
    const saved = PatchClashConfig(
      mixedPort: 7897,
      port: 8080,
      socksPort: 1080,
      allowLan: true,
      mode: Mode.global,
      tun: Tun(enable: true),
      externalController: ExternalControllerStatus.open,
    );
    final effective = portRoutingPatch(saved);
    expect(effective.mixedPort, 0);
    expect(effective.port, 0);
    expect(effective.socksPort, 0);
    expect(effective.tun.enable, isFalse);
    expect(effective.externalController, ExternalControllerStatus.close);
    expect(effective.mode, Mode.rule);
    expect(saved.tun.enable, isTrue);
    expect(saved.mixedPort, 7897);
  });
  test('ports isolate sources, nodes and routing, with explicit rejection', () {
    final result = compilePortRouting(
      bindings: [
        fixed,
        regional,
        regional.copyWith(id: 3, port: 18083, profileId: 11),
      ],
      sourcePaths: {11: '/source/11.yaml', 22: '/source/22.yaml'},
      testUrl: 'https://example.test',
    );
    final groups = result.config['proxy-groups'] as List;
    final listeners = result.config['listeners'] as List;
    expect(result.providers.length, 2);
    expect(groups[0]['use'], [portProviderName(11)]);
    expect(groups[1]['use'], [portProviderName(22)]);
    expect(groups[2]['use'], [portProviderName(11)]);
    expect(groups.map((g) => g['empty-fallback']), everyElement('REJECT'));
    final exact = RegExp(groups[0]['filter'] as String);
    expect(exact.hasMatch('${portNodePrefix(11)}US [01]'), isTrue);
    expect(exact.hasMatch('${portNodePrefix(11)}US 01'), isFalse);
    expect(exact.hasMatch('${portNodePrefix(22)}US [01]'), isFalse);
    expect(listeners.map((l) => l['listen']), everyElement('127.0.0.1'));
    expect(listeners.map((l) => l['udp']), everyElement(false));
    expect(listeners[1]['proxy'], regional.groupName);
    expect(listeners[0]['users'], isEmpty);
    expect(result.config['rules'], ['MATCH,REJECT']);
  });

  test('fixed names escape provider separator and regex metacharacters', () {
    final result = compilePortRouting(
      bindings: [fixed.copyWith(node: 'a`b.*')],
      sourcePaths: {11: '/11'},
      testUrl: 'https://example.test',
    );
    final filter =
        (result.config['proxy-groups'] as List).single['filter'] as String;
    expect(filter, isNot(contains('`')));
    expect(RegExp(filter).hasMatch('${portNodePrefix(11)}a`b.*'), isTrue);
    expect(RegExp(filter).hasMatch('${portNodePrefix(11)}a`bXX'), isFalse);
  });

  test('region preview uses literal words rather than arbitrary regex', () {
    expect(
      matchingPortNodes(regional, ['US', 'jp fast', '日本 A', 'Hong Kong']),
      ['jp fast', '日本 A'],
    );
    expect(
      matchingPortNodes(regional.copyWith(filter: '[JP]'), ['JP', '[JP]']),
      ['[JP]'],
    );
    expect(matchingPortNodes(fixed, ['US [01]', 'US 01']), ['US [01]']);
  });

  test('invalid or colliding ports fail without changing their numbers', () {
    for (final port in [0, 80, 65536]) {
      expect(
        () => validatePortBindings([fixed.copyWith(port: port)]),
        throwsA(isA<PortRoutingException>()),
      );
    }
    expect(
      () => validatePortBindings([fixed, regional.copyWith(port: 18081)]),
      throwsA(isA<PortRoutingException>()),
    );
    expect(
      () => validatePortBindings([regional.copyWith(filter: ' | ')]),
      throwsA(isA<PortRoutingException>()),
    );
    expect(
      () => compilePortRouting(bindings: [fixed], sourcePaths: {}, testUrl: ''),
      throwsA(isA<PortRoutingException>()),
    );
  });

  test('source extraction rejects unsupported, empty and ambiguous content', () {
    for (final source in [
      'proxies: []',
      'not: a-subscription',
      '<html>login</html>',
      'proxies: [{name: A, type: direct}]',
      'proxies: [{name: A, type: ss, dialer-proxy: Group}]',
      'proxies: [{name: A, type: ss}, {name: A, type: ss}]',
      'proxies: [{name: A, type: ss}]\nproxy-providers: {nested: {type: http}}',
    ]) {
      expect(
        () => portSubscriptionNodes(source),
        throwsA(isA<PortRoutingException>()),
        reason: source,
      );
    }
    final nodes = portSubscriptionNodes(
      'proxies: [{name: A, type: ss, server: example.test}]\nrules: [MATCH,DIRECT]',
    );
    expect(nodes.single['name'], 'A');
  });

  test('old settings default off and bindings round-trip and remap', () {
    expect(Config.realFromJson({}).portRouting, const PortRoutingConfig());
    const config = PortRoutingConfig(
      workspaceProfileId: 9,
      previousProfileId: 11,
      bindings: [fixed, regional],
      subscriptions: [
        PortSubscriptionRefresh(
          profileId: 22,
          enabled: false,
          intervalMinutes: 17,
        ),
      ],
    );
    expect(PortRoutingConfig.fromJson(jsonDecode(jsonEncode(config))), config);
    final remapped = config.remapProfiles({9: 90, 11: 110, 22: 220});
    expect(remapped.workspaceProfileId, 90);
    expect(remapped.previousProfileId, 110);
    expect(remapped.bindings.map((b) => b.profileId), [110, 220]);
    expect(remapped.refreshFor(220).enabled, isFalse);
    expect(remapped.refreshFor(110).intervalMinutes, 5);
    expect(config.remapProfiles({11: 110}).workspaceProfileId, isNull);
  });

  test(
    'safe mode clears generated listeners after provider injection',
    () async {
      final fragment = compilePortRouting(
        bindings: [fixed],
        sourcePaths: {11: '/source.yaml'},
        testUrl: 'https://example.test',
      );
      final result = await makeRealProfileTask(
        MakeRealProfileState(
          profilesPath: '/profiles',
          profileId: 9,
          rawConfig: fragment.config,
          realPatchConfig: const PatchClashConfig(mixedPort: 0),
          appendSystemDns: false,
          proxyGroups: [],
          rules: [],
          addedRules: [],
          defaultUA: 'test',
          safeMode: true,
          injectedProxyProviders: fragment.providers,
        ),
      );
      final yaml = loadYaml(result.yaml) as Map;
      expect(yaml['listeners'], isEmpty);
      expect(yaml['mixed-port'], 0);
      expect(
        yaml['proxy-providers'][portProviderName(11)]['path'],
        '/source.yaml',
      );
    },
  );

  test('Windows listener ownership ignores established sockets', () {
    final owners = parseWindowsPortOwners('''
 TCP    127.0.0.1:18081  0.0.0.0:0  LISTENING  1234
 TCP    0.0.0.0:18082  0.0.0.0:0  LISTENING  5678
 TCP    127.0.0.1:18081  127.0.0.1:43000  ESTABLISHED  9999
''');
    expect(owners, {18081: 1234, 18082: 5678});
  });

  test('occupied ports are rejected and SOCKS response may be split', () async {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(server.close);
    await expectLater(
      checkPortAvailable(server.port),
      throwsA(isA<PortRoutingException>()),
    );
    final listener = server.listen((socket) {
      socket.listen((_) async {
        socket.add([5]);
        await socket.flush();
        socket.add([0]);
        await socket.flush();
        socket.destroy();
      });
    });
    addTearDown(listener.cancel);
    await checkSocksHandshake(server.port);
  });
}
