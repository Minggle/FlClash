import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/port_routing.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String _portRoutingError(AppLocalizations l, Object error) {
  if (error is! PortRoutingException) return l.portRoutingUpdateFailed;
  return switch (error.issue) {
    PortRoutingIssue.invalidPort => l.portRoutingInvalidPort,
    PortRoutingIssue.duplicatePort ||
    PortRoutingIssue.portOccupied => l.portConflictTip,
    PortRoutingIssue.invalidBinding => l.portRoutingInvalidBinding,
    PortRoutingIssue.invalidFilter => l.portRoutingRegionHint,
    PortRoutingIssue.unsupportedSubscription => l.portRoutingUnsupported,
    PortRoutingIssue.emptySubscription => l.portRoutingEmptySource,
    PortRoutingIssue.duplicateNode => l.portRoutingDuplicateNode,
    PortRoutingIssue.missingSubscription => l.portRoutingMissingSource,
    PortRoutingIssue.coreUnavailable => l.portRoutingCoreUnavailable,
    PortRoutingIssue.staleUpdate => l.portRoutingStaleUpdate,
    PortRoutingIssue.sourceInUse => l.portRoutingSourceInUse,
    PortRoutingIssue.updateFailed => l.portRoutingUpdateFailed,
  };
}

class PortRoutingView extends ConsumerStatefulWidget {
  const PortRoutingView({super.key});

  @override
  ConsumerState<PortRoutingView> createState() => _PortRoutingViewState();
}

class _PortRoutingViewState extends ConsumerState<PortRoutingView> {
  bool _busy = false;
  String? _error;

  Future<void> _run(Future<void> Function() task) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await task();
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = _portRoutingError(context.appLocalizations, error),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _edit([PortBinding? binding]) async {
    final profiles = ref
        .read(profilesProvider)
        .where((profile) => profile.type != ProfileType.custom)
        .toList();
    if (profiles.isEmpty) {
      setState(
        () => _error = context.appLocalizations.portRoutingMissingSource,
      );
      return;
    }
    final result = await showFormSheet<PortBinding>(
      context: context,
      builder: (_) => _BindingForm(binding: binding, profiles: profiles),
    );
    if (result == null || !mounted) return;
    await _run(
      () => ref.read(portRoutingActionProvider.notifier).saveBinding(result),
    );
  }

  Future<void> _refreshOptions(int profileId) async {
    final setting = ref.read(portRoutingSettingProvider).refreshFor(profileId);
    final result = await showFormSheet<PortSubscriptionRefresh>(
      context: context,
      builder: (_) => _RefreshForm(setting: setting),
    );
    if (result != null && mounted) {
      ref.read(portRoutingActionProvider.notifier).setRefresh(result);
    }
  }

  Widget _binding(PortBinding binding, bool active) {
    return Consumer(
      builder: (context, ref, _) {
        final l = context.appLocalizations;
        final check = ref.watch(
          portRoutingActivityProvider.select(
            (state) => state.ports[binding.id],
          ),
        );
        final profile = ref.watch(
          profilesProvider.select(
            (profiles) => profiles.getProfile(binding.profileId),
          ),
        );
        final phase = !active || !binding.enabled
            ? PortBindingPhase.stopped
            : check?.phase;
        final status = switch (phase) {
          PortBindingPhase.stopped => l.portRoutingStopped,
          PortBindingPhase.checking => l.portRoutingChecking,
          PortBindingPhase.listening => l.portRoutingListening,
          PortBindingPhase.blocked => l.portRoutingBlocked,
          PortBindingPhase.failed => _portRoutingError(
            l,
            PortRoutingException(
              check?.issue ?? PortRoutingIssue.coreUnavailable,
            ),
          ),
          null => l.portRoutingUnchecked,
        };
        return ContextMenuRegion(
          menuItems: [
            PopupMenuItem(
              label: 'HTTP',
              onPressed: () =>
                  Clipboard.setData(ClipboardData(text: binding.httpAddress)),
            ),
            PopupMenuItem(
              label: 'SOCKS5',
              onPressed: () =>
                  Clipboard.setData(ClipboardData(text: binding.socksAddress)),
            ),
            PopupMenuItem(label: l.edit, onPressed: () => _edit(binding)),
            PopupMenuItem(
              label: l.portRoutingRefreshSettings,
              onPressed: () => _refreshOptions(binding.profileId),
            ),
            if (profile?.type == ProfileType.url)
              PopupMenuItem(
                label: l.update,
                onPressed: () => _run(
                  () => ref
                      .read(portRoutingActionProvider.notifier)
                      .refresh(binding.profileId),
                ),
              ),
            PopupMenuItem(
              label: l.delete,
              onPressed: () => _run(
                () => ref
                    .read(portRoutingActionProvider.notifier)
                    .removeBinding(binding.id),
              ),
            ),
          ],
          child: ListItem(
            title: Text('${binding.name} · 127.0.0.1:${binding.port}'),
            subtitle: Text(
              [
                profile?.realLabel ?? l.portRoutingMissingSource,
                binding.selection == PortSelection.fixed
                    ? binding.node
                    : binding.filter,
                status,
                if (check?.node != null && active) check!.node!,
                if (profile?.lastUpdateDate != null)
                  '${l.update}: ${profile!.lastUpdateDate!.toLocal()}',
              ].join('\n'),
            ),
            onTap: () => _edit(binding),
            trailing: Switch(
              value: binding.enabled,
              onChanged: _busy
                  ? null
                  : (value) => _run(
                      () => ref
                          .read(portRoutingActionProvider.notifier)
                          .saveBinding(binding.copyWith(enabled: value)),
                    ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.appLocalizations;
    final config = ref.watch(portRoutingSettingProvider);
    final active = ref.watch(portRoutingActiveProvider);
    final runtime = ref.watch(portRoutingActivityProvider);
    final safe = ref.watch(safeModeProvider);
    return Scaffold(
      title: l.portRoutingTitle,
      iconActions: [
        IconButtonData(
          glyph: AppGlyphs.add,
          tooltip: l.add,
          onPressed: _busy ? null : _edit,
        ),
        IconButtonData(
          glyph: AppGlyphs.refresh,
          tooltip: l.portRoutingCheck,
          onPressed: _busy
              ? null
              : () => _run(
                  () => ref.read(portRoutingActionProvider.notifier).checkAll(),
                ),
        ),
      ],
      body: Builder(
        builder: (context) => PrismListView(
          padding: EdgeInsets.fromLTRB(
            16,
            context.sectionsTopPadding,
            16,
            20 + context.bottomInset,
          ),
          itemCount: config.bindings.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return generateSection(
                items: [
                  ListItem(
                    title: Text(l.portRoutingMode),
                    subtitle: Text(
                      safe ? l.portRoutingSafeMode : l.portRoutingDescription,
                    ),
                    trailing: Switch(
                      value: active,
                      onChanged: _busy
                          ? null
                          : (value) => _run(
                              () => value
                                  ? ref
                                        .read(
                                          portRoutingActionProvider.notifier,
                                        )
                                        .activate()
                                  : ref
                                        .read(
                                          portRoutingActionProvider.notifier,
                                        )
                                        .deactivate(),
                            ),
                    ),
                  ),
                  if (_busy) const LinearProgressIndicator(),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(_error!),
                    ),
                  for (final entry in runtime.errors.entries)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _portRoutingError(l, PortRoutingException(entry.value)),
                      ),
                    ),
                ],
              );
            }
            if (index == config.bindings.length + 1) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  config.bindings.isEmpty
                      ? l.portRoutingEmpty
                      : l.portRoutingCopyHint,
                ),
              );
            }
            return generateSection(
              items: [_binding(config.bindings[index - 1], active)],
            );
          },
        ),
      ),
    );
  }
}

class _BindingForm extends ConsumerStatefulWidget {
  final PortBinding? binding;
  final List<Profile> profiles;
  const _BindingForm({required this.binding, required this.profiles});

  @override
  ConsumerState<_BindingForm> createState() => _BindingFormState();
}

class _BindingFormState extends ConsumerState<_BindingForm> {
  late final int _id;
  late final TextEditingController _name;
  late final TextEditingController _port;
  late final TextEditingController _filter;
  late int _profileId;
  late PortSelection _selection;
  String _node = '';
  List<String>? _nodes;
  String? _error;
  int _load = 0;
  Timer? _previewTimer;
  int _previewRevision = 0;
  ({int count, List<String> sample}) _preview = (count: 0, sample: []);

  @override
  void initState() {
    super.initState();
    final binding = widget.binding;
    _id = binding?.id ?? snowflake.id;
    _name = TextEditingController(text: binding?.name);
    _port = TextEditingController(
      text: (binding?.port ?? _nextPort()).toString(),
    );
    _filter = TextEditingController(text: binding?.filter ?? 'HK|Hong Kong');
    _profileId = binding?.profileId ?? widget.profiles.first.id;
    _selection = binding?.selection ?? PortSelection.fixed;
    _node = binding?.node ?? '';
    unawaited(_loadNodes());
  }

  int _nextPort() {
    final ports = ref
        .read(portRoutingSettingProvider)
        .bindings
        .map((item) => item.port)
        .toSet();
    var port = 18081;
    while (ports.contains(port)) {
      port++;
    }
    return port;
  }

  Future<void> _loadNodes() async {
    final load = ++_load;
    setState(() {
      _nodes = null;
      _error = null;
    });
    try {
      final nodes = await ref
          .read(portRoutingActionProvider.notifier)
          .nodeNames(_profileId);
      if (!mounted || load != _load) return;
      setState(() {
        _nodes = nodes;
      });
      _schedulePreview();
    } catch (error) {
      if (mounted && load == _load) {
        setState(
          () => _error = _portRoutingError(context.appLocalizations, error),
        );
      }
    }
  }

  PortBinding _value() => PortBinding(
    id: _id,
    name: _name.text.trim(),
    profileId: _profileId,
    port: int.tryParse(_port.text) ?? 0,
    enabled: widget.binding?.enabled ?? true,
    selection: _selection,
    node: _node,
    filter: _filter.text.trim(),
  );

  void _save() {
    try {
      final value = _value();
      validatePortBindings([
        ...ref
            .read(portRoutingSettingProvider)
            .bindings
            .where((item) => item.id != value.id),
        value,
      ]);
      if (_nodes == null) return;
      Navigator.of(context).pop(value);
    } catch (error) {
      setState(
        () => _error = _portRoutingError(context.appLocalizations, error),
      );
    }
  }

  Future<void> _chooseNode() async {
    final result = await showFormSheet<String>(
      context: context,
      builder: (sheetContext) => SelectionSheet<String>(
        title: context.appLocalizations.portRoutingFixed,
        sections: [SelectionSection(items: _nodes ?? [])],
        labelBuilder: (node) => node,
        selectedOf: (_) => _node,
        onSelected: (node) => Navigator.of(sheetContext).pop(node),
      ),
    );
    if (result != null && mounted) {
      setState(() => _node = result);
      _schedulePreview();
    }
  }

  void _schedulePreview() {
    _previewTimer?.cancel();
    final revision = ++_previewRevision;
    _previewTimer = Timer(const Duration(milliseconds: 200), () async {
      final preview = await compute(_matchingPreview, (_value(), _nodes ?? []));
      if (mounted && revision == _previewRevision) {
        setState(() => _preview = preview);
      }
    });
  }

  @override
  void dispose() {
    _previewTimer?.cancel();
    _name.dispose();
    _port.dispose();
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.appLocalizations;
    return FormPage(
      title: widget.binding == null ? l.add : l.edit,
      onSave: _save,
      error: _error,
      children: [
        generateSection(
          items: [
            FormRow(
              title: l.label,
              trailing: FormRowTextField(
                controller: _name,
                hintText: l.required,
              ),
            ),
            ListItem<int>.options(
              title: Text(l.profiles),
              value: _profileId,
              options: widget.profiles.map((profile) => profile.id).toList(),
              textBuilder: (id) => widget.profiles
                  .firstWhere((profile) => profile.id == id)
                  .realLabel,
              onChanged: (id) {
                setState(() {
                  _profileId = id;
                  _node = '';
                });
                unawaited(_loadNodes());
              },
            ),
            FormRow(
              title: l.port,
              trailing: FormRowTextField(
                controller: _port,
                keyboardType: TextInputType.number,
                inputFormatters: TextInputLimits.digitsOnly(
                  TextInputLimits.port,
                ),
              ),
            ),
            ListItem<PortSelection>.options(
              title: Text(l.portRoutingStrategy),
              value: _selection,
              options: PortSelection.values,
              textBuilder: (value) => value == PortSelection.fixed
                  ? l.portRoutingFixed
                  : l.portRoutingRegion,
              onChanged: (value) {
                setState(() => _selection = value);
                _schedulePreview();
              },
            ),
            if (_selection == PortSelection.fixed)
              FormRow(
                title: l.portRoutingFixed,
                trailing: Text(_node.isEmpty ? l.required : _node),
                onPressed: _nodes == null ? null : _chooseNode,
              )
            else
              FormRow(
                title: l.portRoutingRegion,
                trailing: FormRowTextField(
                  controller: _filter,
                  autocorrect: false,
                  onChanged: (_) => _schedulePreview(),
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(l.portRoutingRegionHint),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _nodes == null
                ? l.portRoutingChecking
                : '${l.portRoutingMatches}: ${_preview.count}\n${_preview.sample.join('\n')}',
          ),
        ),
      ],
    );
  }
}

class _RefreshForm extends StatefulWidget {
  final PortSubscriptionRefresh setting;
  const _RefreshForm({required this.setting});
  @override
  State<_RefreshForm> createState() => _RefreshFormState();
}

class _RefreshFormState extends State<_RefreshForm> {
  late bool _enabled;
  late final TextEditingController _minutes;
  String? _error;
  @override
  void initState() {
    super.initState();
    _enabled = widget.setting.enabled;
    _minutes = TextEditingController(
      text: widget.setting.intervalMinutes.toString(),
    );
  }

  @override
  void dispose() {
    _minutes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.appLocalizations;
    return FormPage(
      title: l.portRoutingRefreshSettings,
      error: _error,
      onSave: () {
        final minutes = int.tryParse(_minutes.text);
        if (minutes == null || minutes < 1 || minutes > 1440) {
          setState(() => _error = l.portRoutingRefreshRange);
          return;
        }
        Navigator.of(context).pop(
          widget.setting.copyWith(enabled: _enabled, intervalMinutes: minutes),
        );
      },
      children: [
        generateSection(
          items: [
            FormRow(
              title: l.autoUpdate,
              trailing: Switch(
                value: _enabled,
                onChanged: (value) => setState(() => _enabled = value),
              ),
            ),
            FormRow(
              title: l.portRoutingMinutes,
              trailing: FormRowTextField(
                controller: _minutes,
                keyboardType: TextInputType.number,
                inputFormatters: TextInputLimits.digitsOnly(
                  TextInputLimits.port,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

({int count, List<String> sample}) _matchingPreview(
  (PortBinding, List<String>) input,
) {
  final matches = matchingPortNodes(input.$1, input.$2);
  return (count: matches.length, sample: matches.take(12).toList());
}
