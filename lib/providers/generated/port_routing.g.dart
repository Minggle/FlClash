// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../port_routing.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PortRoutingActivity)
final portRoutingActivityProvider = PortRoutingActivityProvider._();

final class PortRoutingActivityProvider
    extends $NotifierProvider<PortRoutingActivity, PortRoutingRuntime> {
  PortRoutingActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'portRoutingActivityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$portRoutingActivityHash();

  @$internal
  @override
  PortRoutingActivity create() => PortRoutingActivity();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PortRoutingRuntime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PortRoutingRuntime>(value),
    );
  }
}

String _$portRoutingActivityHash() =>
    r'e72e5e6c247f7e9b0a780a146a051b4ca0d6144b';

abstract class _$PortRoutingActivity extends $Notifier<PortRoutingRuntime> {
  PortRoutingRuntime build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PortRoutingRuntime, PortRoutingRuntime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PortRoutingRuntime, PortRoutingRuntime>,
              PortRoutingRuntime,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
