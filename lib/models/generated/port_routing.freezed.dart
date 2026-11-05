// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../port_routing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PortBinding {

 int get id; String get name; int get profileId; int get port; bool get enabled; PortSelection get selection; String get node; String get filter;
/// Create a copy of PortBinding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortBindingCopyWith<PortBinding> get copyWith => _$PortBindingCopyWithImpl<PortBinding>(this as PortBinding, _$identity);

  /// Serializes this PortBinding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PortBinding;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortBinding&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.profileId, _this.profileId) || other.profileId == _this.profileId)&&(identical(other.port, _this.port) || other.port == _this.port)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.selection, _this.selection) || other.selection == _this.selection)&&(identical(other.node, _this.node) || other.node == _this.node)&&(identical(other.filter, _this.filter) || other.filter == _this.filter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PortBinding;
  return Object.hash(runtimeType,_this.id,_this.name,_this.profileId,_this.port,_this.enabled,_this.selection,_this.node,_this.filter);
}

@override
String toString() {
  final _this = this as PortBinding;
  return 'PortBinding(id: ${_this.id}, name: ${_this.name}, profileId: ${_this.profileId}, port: ${_this.port}, enabled: ${_this.enabled}, selection: ${_this.selection}, node: ${_this.node}, filter: ${_this.filter})';
}


}

/// @nodoc
abstract mixin class $PortBindingCopyWith<$Res>  {
  factory $PortBindingCopyWith(PortBinding value, $Res Function(PortBinding) _then) = _$PortBindingCopyWithImpl;
@useResult
$Res call({
 int id, String name, int profileId, int port, bool enabled, PortSelection selection, String node, String filter
});




}
/// @nodoc
class _$PortBindingCopyWithImpl<$Res>
    implements $PortBindingCopyWith<$Res> {
  _$PortBindingCopyWithImpl(this._self, this._then);

  final PortBinding _self;
  final $Res Function(PortBinding) _then;

/// Create a copy of PortBinding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? profileId = null,Object? port = null,Object? enabled = null,Object? selection = null,Object? node = null,Object? filter = null,}) {
  return _then(PortBinding(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as int,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,selection: null == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as PortSelection,node: null == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as String,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PortBinding].
extension PortBindingPatterns on PortBinding {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortBinding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortBinding() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortBinding value)  $default,){
final _that = this;
switch (_that) {
case _PortBinding():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortBinding value)?  $default,){
final _that = this;
switch (_that) {
case _PortBinding() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  int profileId,  int port,  bool enabled,  PortSelection selection,  String node,  String filter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortBinding() when $default != null:
return $default(_that.id,_that.name,_that.profileId,_that.port,_that.enabled,_that.selection,_that.node,_that.filter);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  int profileId,  int port,  bool enabled,  PortSelection selection,  String node,  String filter)  $default,) {final _that = this;
switch (_that) {
case _PortBinding():
return $default(_that.id,_that.name,_that.profileId,_that.port,_that.enabled,_that.selection,_that.node,_that.filter);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  int profileId,  int port,  bool enabled,  PortSelection selection,  String node,  String filter)?  $default,) {final _that = this;
switch (_that) {
case _PortBinding() when $default != null:
return $default(_that.id,_that.name,_that.profileId,_that.port,_that.enabled,_that.selection,_that.node,_that.filter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PortBinding extends PortBinding {
  const _PortBinding({required this.id, required this.name, required this.profileId, required this.port, this.enabled = true, this.selection = PortSelection.fixed, this.node = '', this.filter = ''}): super._();
  factory _PortBinding.fromJson(Map<String, dynamic> json) => _$PortBindingFromJson(json);

@override final  int id;
@override final  String name;
@override final  int profileId;
@override final  int port;
@override@JsonKey() final  bool enabled;
@override@JsonKey() final  PortSelection selection;
@override@JsonKey() final  String node;
@override@JsonKey() final  String filter;

/// Create a copy of PortBinding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortBindingCopyWith<_PortBinding> get copyWith => __$PortBindingCopyWithImpl<_PortBinding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PortBindingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortBinding&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.port, port) || other.port == port)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.selection, selection) || other.selection == selection)&&(identical(other.node, node) || other.node == node)&&(identical(other.filter, filter) || other.filter == filter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,profileId,port,enabled,selection,node,filter);
}

@override
String toString() {
    return 'PortBinding(id: $id, name: $name, profileId: $profileId, port: $port, enabled: $enabled, selection: $selection, node: $node, filter: $filter)';
}


}

/// @nodoc
abstract mixin class _$PortBindingCopyWith<$Res> implements $PortBindingCopyWith<$Res> {
  factory _$PortBindingCopyWith(_PortBinding value, $Res Function(_PortBinding) _then) = __$PortBindingCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, int profileId, int port, bool enabled, PortSelection selection, String node, String filter
});




}
/// @nodoc
class __$PortBindingCopyWithImpl<$Res>
    implements _$PortBindingCopyWith<$Res> {
  __$PortBindingCopyWithImpl(this._self, this._then);

  final _PortBinding _self;
  final $Res Function(_PortBinding) _then;

/// Create a copy of PortBinding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? profileId = null,Object? port = null,Object? enabled = null,Object? selection = null,Object? node = null,Object? filter = null,}) {
  return _then(_PortBinding(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as int,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,selection: null == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as PortSelection,node: null == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as String,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PortSubscriptionRefresh {

 int get profileId; bool get enabled; int get intervalMinutes;
/// Create a copy of PortSubscriptionRefresh
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortSubscriptionRefreshCopyWith<PortSubscriptionRefresh> get copyWith => _$PortSubscriptionRefreshCopyWithImpl<PortSubscriptionRefresh>(this as PortSubscriptionRefresh, _$identity);

  /// Serializes this PortSubscriptionRefresh to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PortSubscriptionRefresh;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortSubscriptionRefresh&&(identical(other.profileId, _this.profileId) || other.profileId == _this.profileId)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.intervalMinutes, _this.intervalMinutes) || other.intervalMinutes == _this.intervalMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PortSubscriptionRefresh;
  return Object.hash(runtimeType,_this.profileId,_this.enabled,_this.intervalMinutes);
}

@override
String toString() {
  final _this = this as PortSubscriptionRefresh;
  return 'PortSubscriptionRefresh(profileId: ${_this.profileId}, enabled: ${_this.enabled}, intervalMinutes: ${_this.intervalMinutes})';
}


}

/// @nodoc
abstract mixin class $PortSubscriptionRefreshCopyWith<$Res>  {
  factory $PortSubscriptionRefreshCopyWith(PortSubscriptionRefresh value, $Res Function(PortSubscriptionRefresh) _then) = _$PortSubscriptionRefreshCopyWithImpl;
@useResult
$Res call({
 int profileId, bool enabled, int intervalMinutes
});




}
/// @nodoc
class _$PortSubscriptionRefreshCopyWithImpl<$Res>
    implements $PortSubscriptionRefreshCopyWith<$Res> {
  _$PortSubscriptionRefreshCopyWithImpl(this._self, this._then);

  final PortSubscriptionRefresh _self;
  final $Res Function(PortSubscriptionRefresh) _then;

/// Create a copy of PortSubscriptionRefresh
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profileId = null,Object? enabled = null,Object? intervalMinutes = null,}) {
  return _then(PortSubscriptionRefresh(
profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as int,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,intervalMinutes: null == intervalMinutes ? _self.intervalMinutes : intervalMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PortSubscriptionRefresh].
extension PortSubscriptionRefreshPatterns on PortSubscriptionRefresh {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortSubscriptionRefresh value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortSubscriptionRefresh() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortSubscriptionRefresh value)  $default,){
final _that = this;
switch (_that) {
case _PortSubscriptionRefresh():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortSubscriptionRefresh value)?  $default,){
final _that = this;
switch (_that) {
case _PortSubscriptionRefresh() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int profileId,  bool enabled,  int intervalMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortSubscriptionRefresh() when $default != null:
return $default(_that.profileId,_that.enabled,_that.intervalMinutes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int profileId,  bool enabled,  int intervalMinutes)  $default,) {final _that = this;
switch (_that) {
case _PortSubscriptionRefresh():
return $default(_that.profileId,_that.enabled,_that.intervalMinutes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int profileId,  bool enabled,  int intervalMinutes)?  $default,) {final _that = this;
switch (_that) {
case _PortSubscriptionRefresh() when $default != null:
return $default(_that.profileId,_that.enabled,_that.intervalMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PortSubscriptionRefresh implements PortSubscriptionRefresh {
  const _PortSubscriptionRefresh({required this.profileId, this.enabled = true, this.intervalMinutes = 5});
  factory _PortSubscriptionRefresh.fromJson(Map<String, dynamic> json) => _$PortSubscriptionRefreshFromJson(json);

@override final  int profileId;
@override@JsonKey() final  bool enabled;
@override@JsonKey() final  int intervalMinutes;

/// Create a copy of PortSubscriptionRefresh
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortSubscriptionRefreshCopyWith<_PortSubscriptionRefresh> get copyWith => __$PortSubscriptionRefreshCopyWithImpl<_PortSubscriptionRefresh>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PortSubscriptionRefreshToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortSubscriptionRefresh&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.intervalMinutes, intervalMinutes) || other.intervalMinutes == intervalMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,profileId,enabled,intervalMinutes);
}

@override
String toString() {
    return 'PortSubscriptionRefresh(profileId: $profileId, enabled: $enabled, intervalMinutes: $intervalMinutes)';
}


}

/// @nodoc
abstract mixin class _$PortSubscriptionRefreshCopyWith<$Res> implements $PortSubscriptionRefreshCopyWith<$Res> {
  factory _$PortSubscriptionRefreshCopyWith(_PortSubscriptionRefresh value, $Res Function(_PortSubscriptionRefresh) _then) = __$PortSubscriptionRefreshCopyWithImpl;
@override @useResult
$Res call({
 int profileId, bool enabled, int intervalMinutes
});




}
/// @nodoc
class __$PortSubscriptionRefreshCopyWithImpl<$Res>
    implements _$PortSubscriptionRefreshCopyWith<$Res> {
  __$PortSubscriptionRefreshCopyWithImpl(this._self, this._then);

  final _PortSubscriptionRefresh _self;
  final $Res Function(_PortSubscriptionRefresh) _then;

/// Create a copy of PortSubscriptionRefresh
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profileId = null,Object? enabled = null,Object? intervalMinutes = null,}) {
  return _then(_PortSubscriptionRefresh(
profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as int,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,intervalMinutes: null == intervalMinutes ? _self.intervalMinutes : intervalMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PortRoutingConfig {

 int? get workspaceProfileId; int? get previousProfileId; List<PortBinding> get bindings; List<PortSubscriptionRefresh> get subscriptions;
/// Create a copy of PortRoutingConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortRoutingConfigCopyWith<PortRoutingConfig> get copyWith => _$PortRoutingConfigCopyWithImpl<PortRoutingConfig>(this as PortRoutingConfig, _$identity);

  /// Serializes this PortRoutingConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PortRoutingConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortRoutingConfig&&(identical(other.workspaceProfileId, _this.workspaceProfileId) || other.workspaceProfileId == _this.workspaceProfileId)&&(identical(other.previousProfileId, _this.previousProfileId) || other.previousProfileId == _this.previousProfileId)&&const DeepCollectionEquality().equals(other.bindings, _this.bindings)&&const DeepCollectionEquality().equals(other.subscriptions, _this.subscriptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PortRoutingConfig;
  return Object.hash(runtimeType,_this.workspaceProfileId,_this.previousProfileId,const DeepCollectionEquality().hash(_this.bindings),const DeepCollectionEquality().hash(_this.subscriptions));
}

@override
String toString() {
  final _this = this as PortRoutingConfig;
  return 'PortRoutingConfig(workspaceProfileId: ${_this.workspaceProfileId}, previousProfileId: ${_this.previousProfileId}, bindings: ${_this.bindings}, subscriptions: ${_this.subscriptions})';
}


}

/// @nodoc
abstract mixin class $PortRoutingConfigCopyWith<$Res>  {
  factory $PortRoutingConfigCopyWith(PortRoutingConfig value, $Res Function(PortRoutingConfig) _then) = _$PortRoutingConfigCopyWithImpl;
@useResult
$Res call({
 int? workspaceProfileId, int? previousProfileId, List<PortBinding> bindings, List<PortSubscriptionRefresh> subscriptions
});




}
/// @nodoc
class _$PortRoutingConfigCopyWithImpl<$Res>
    implements $PortRoutingConfigCopyWith<$Res> {
  _$PortRoutingConfigCopyWithImpl(this._self, this._then);

  final PortRoutingConfig _self;
  final $Res Function(PortRoutingConfig) _then;

/// Create a copy of PortRoutingConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workspaceProfileId = freezed,Object? previousProfileId = freezed,Object? bindings = null,Object? subscriptions = null,}) {
  return _then(PortRoutingConfig(
workspaceProfileId: freezed == workspaceProfileId ? _self.workspaceProfileId : workspaceProfileId // ignore: cast_nullable_to_non_nullable
as int?,previousProfileId: freezed == previousProfileId ? _self.previousProfileId : previousProfileId // ignore: cast_nullable_to_non_nullable
as int?,bindings: null == bindings ? _self.bindings : bindings // ignore: cast_nullable_to_non_nullable
as List<PortBinding>,subscriptions: null == subscriptions ? _self.subscriptions : subscriptions // ignore: cast_nullable_to_non_nullable
as List<PortSubscriptionRefresh>,
  ));
}

}


/// Adds pattern-matching-related methods to [PortRoutingConfig].
extension PortRoutingConfigPatterns on PortRoutingConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortRoutingConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortRoutingConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortRoutingConfig value)  $default,){
final _that = this;
switch (_that) {
case _PortRoutingConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortRoutingConfig value)?  $default,){
final _that = this;
switch (_that) {
case _PortRoutingConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? workspaceProfileId,  int? previousProfileId,  List<PortBinding> bindings,  List<PortSubscriptionRefresh> subscriptions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortRoutingConfig() when $default != null:
return $default(_that.workspaceProfileId,_that.previousProfileId,_that.bindings,_that.subscriptions);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? workspaceProfileId,  int? previousProfileId,  List<PortBinding> bindings,  List<PortSubscriptionRefresh> subscriptions)  $default,) {final _that = this;
switch (_that) {
case _PortRoutingConfig():
return $default(_that.workspaceProfileId,_that.previousProfileId,_that.bindings,_that.subscriptions);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? workspaceProfileId,  int? previousProfileId,  List<PortBinding> bindings,  List<PortSubscriptionRefresh> subscriptions)?  $default,) {final _that = this;
switch (_that) {
case _PortRoutingConfig() when $default != null:
return $default(_that.workspaceProfileId,_that.previousProfileId,_that.bindings,_that.subscriptions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PortRoutingConfig extends PortRoutingConfig {
  const _PortRoutingConfig({this.workspaceProfileId, this.previousProfileId,  List<PortBinding> bindings = const [],  List<PortSubscriptionRefresh> subscriptions = const []}): _bindings = bindings,_subscriptions = subscriptions,super._();
  factory _PortRoutingConfig.fromJson(Map<String, dynamic> json) => _$PortRoutingConfigFromJson(json);

@override final  int? workspaceProfileId;
@override final  int? previousProfileId;
 final  List<PortBinding> _bindings;
@override@JsonKey() List<PortBinding> get bindings {
  if (_bindings is EqualUnmodifiableListView) return _bindings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bindings);
}

 final  List<PortSubscriptionRefresh> _subscriptions;
@override@JsonKey() List<PortSubscriptionRefresh> get subscriptions {
  if (_subscriptions is EqualUnmodifiableListView) return _subscriptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subscriptions);
}


/// Create a copy of PortRoutingConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortRoutingConfigCopyWith<_PortRoutingConfig> get copyWith => __$PortRoutingConfigCopyWithImpl<_PortRoutingConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PortRoutingConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortRoutingConfig&&(identical(other.workspaceProfileId, workspaceProfileId) || other.workspaceProfileId == workspaceProfileId)&&(identical(other.previousProfileId, previousProfileId) || other.previousProfileId == previousProfileId)&&const DeepCollectionEquality().equals(other.bindings, _bindings)&&const DeepCollectionEquality().equals(other.subscriptions, _subscriptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workspaceProfileId,previousProfileId,const DeepCollectionEquality().hash(_bindings),const DeepCollectionEquality().hash(_subscriptions));
}

@override
String toString() {
    return 'PortRoutingConfig(workspaceProfileId: $workspaceProfileId, previousProfileId: $previousProfileId, bindings: $bindings, subscriptions: $subscriptions)';
}


}

/// @nodoc
abstract mixin class _$PortRoutingConfigCopyWith<$Res> implements $PortRoutingConfigCopyWith<$Res> {
  factory _$PortRoutingConfigCopyWith(_PortRoutingConfig value, $Res Function(_PortRoutingConfig) _then) = __$PortRoutingConfigCopyWithImpl;
@override @useResult
$Res call({
 int? workspaceProfileId, int? previousProfileId, List<PortBinding> bindings, List<PortSubscriptionRefresh> subscriptions
});




}
/// @nodoc
class __$PortRoutingConfigCopyWithImpl<$Res>
    implements _$PortRoutingConfigCopyWith<$Res> {
  __$PortRoutingConfigCopyWithImpl(this._self, this._then);

  final _PortRoutingConfig _self;
  final $Res Function(_PortRoutingConfig) _then;

/// Create a copy of PortRoutingConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workspaceProfileId = freezed,Object? previousProfileId = freezed,Object? bindings = null,Object? subscriptions = null,}) {
  return _then(_PortRoutingConfig(
workspaceProfileId: freezed == workspaceProfileId ? _self.workspaceProfileId : workspaceProfileId // ignore: cast_nullable_to_non_nullable
as int?,previousProfileId: freezed == previousProfileId ? _self.previousProfileId : previousProfileId // ignore: cast_nullable_to_non_nullable
as int?,bindings: null == bindings ? _self._bindings : bindings // ignore: cast_nullable_to_non_nullable
as List<PortBinding>,subscriptions: null == subscriptions ? _self._subscriptions : subscriptions // ignore: cast_nullable_to_non_nullable
as List<PortSubscriptionRefresh>,
  ));
}


}

// dart format on
