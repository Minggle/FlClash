// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../port_routing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PortBinding _$PortBindingFromJson(Map<String, dynamic> json) => _PortBinding(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  profileId: (json['profileId'] as num).toInt(),
  port: (json['port'] as num).toInt(),
  enabled: json['enabled'] as bool? ?? true,
  selection:
      $enumDecodeNullable(_$PortSelectionEnumMap, json['selection']) ??
      PortSelection.fixed,
  node: json['node'] as String? ?? '',
  filter: json['filter'] as String? ?? '',
);

Map<String, dynamic> _$PortBindingToJson(_PortBinding instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profileId': instance.profileId,
      'port': instance.port,
      'enabled': instance.enabled,
      'selection': _$PortSelectionEnumMap[instance.selection]!,
      'node': instance.node,
      'filter': instance.filter,
    };

const _$PortSelectionEnumMap = {
  PortSelection.fixed: 'fixed',
  PortSelection.region: 'region',
};

_PortSubscriptionRefresh _$PortSubscriptionRefreshFromJson(
  Map<String, dynamic> json,
) => _PortSubscriptionRefresh(
  profileId: (json['profileId'] as num).toInt(),
  enabled: json['enabled'] as bool? ?? true,
  intervalMinutes: (json['intervalMinutes'] as num?)?.toInt() ?? 5,
);

Map<String, dynamic> _$PortSubscriptionRefreshToJson(
  _PortSubscriptionRefresh instance,
) => <String, dynamic>{
  'profileId': instance.profileId,
  'enabled': instance.enabled,
  'intervalMinutes': instance.intervalMinutes,
};

_PortRoutingConfig _$PortRoutingConfigFromJson(Map<String, dynamic> json) =>
    _PortRoutingConfig(
      workspaceProfileId: (json['workspaceProfileId'] as num?)?.toInt(),
      previousProfileId: (json['previousProfileId'] as num?)?.toInt(),
      bindings:
          (json['bindings'] as List<dynamic>?)
              ?.map((e) => PortBinding.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subscriptions:
          (json['subscriptions'] as List<dynamic>?)
              ?.map(
                (e) =>
                    PortSubscriptionRefresh.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PortRoutingConfigToJson(_PortRoutingConfig instance) =>
    <String, dynamic>{
      'workspaceProfileId': instance.workspaceProfileId,
      'previousProfileId': instance.previousProfileId,
      'bindings': instance.bindings,
      'subscriptions': instance.subscriptions,
    };
