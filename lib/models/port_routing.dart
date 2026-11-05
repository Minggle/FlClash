import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/port_routing.freezed.dart';
part 'generated/port_routing.g.dart';

enum PortSelection { fixed, region }

@freezed
abstract class PortBinding with _$PortBinding {
  const PortBinding._();

  const factory PortBinding({
    required int id,
    required String name,
    required int profileId,
    required int port,
    @Default(true) bool enabled,
    @Default(PortSelection.fixed) PortSelection selection,
    @Default('') String node,
    @Default('') String filter,
  }) = _PortBinding;

  factory PortBinding.fromJson(Map<String, dynamic> json) =>
      _$PortBindingFromJson(json);

  String get groupName => 'flclash_ports_group_$id';
  String get listenerName => 'flclash_ports_in_$id';
  String get httpAddress => 'http://127.0.0.1:$port';
  String get socksAddress => 'socks5h://127.0.0.1:$port';
}

@freezed
abstract class PortSubscriptionRefresh with _$PortSubscriptionRefresh {
  const factory PortSubscriptionRefresh({
    required int profileId,
    @Default(true) bool enabled,
    @Default(5) int intervalMinutes,
  }) = _PortSubscriptionRefresh;

  factory PortSubscriptionRefresh.fromJson(Map<String, dynamic> json) =>
      _$PortSubscriptionRefreshFromJson(json);
}

@freezed
abstract class PortRoutingConfig with _$PortRoutingConfig {
  const PortRoutingConfig._();

  const factory PortRoutingConfig({
    int? workspaceProfileId,
    int? previousProfileId,
    @Default([]) List<PortBinding> bindings,
    @Default([]) List<PortSubscriptionRefresh> subscriptions,
  }) = _PortRoutingConfig;

  factory PortRoutingConfig.fromJson(Map<String, dynamic> json) =>
      _$PortRoutingConfigFromJson(json);

  bool isActive(int? profileId) =>
      workspaceProfileId != null && workspaceProfileId == profileId;

  Set<int> get sourceIds => {
    for (final binding in bindings)
      if (binding.enabled) binding.profileId,
  };

  PortSubscriptionRefresh refreshFor(int profileId) =>
      subscriptions.where((item) => item.profileId == profileId).firstOrNull ??
      PortSubscriptionRefresh(profileId: profileId);

  PortRoutingConfig remapProfiles(Map<int, int> ids) => copyWith(
    workspaceProfileId: ids[workspaceProfileId],
    previousProfileId: ids[previousProfileId],
    bindings: [
      for (final binding in bindings)
        if (ids[binding.profileId] case final id?)
          binding.copyWith(profileId: id),
    ],
    subscriptions: [
      for (final subscription in subscriptions)
        if (ids[subscription.profileId] case final id?)
          subscription.copyWith(profileId: id),
    ],
  );
}
