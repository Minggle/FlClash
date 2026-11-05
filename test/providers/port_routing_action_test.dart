import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/port_routing.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../helpers/app_paths.dart';
import '../helpers/test_profiles.dart';

class _Core extends Mock implements CoreHandlerInterface {}

class _Setup extends SetupAction {
  int applies = 0;
  bool? running;
  @override
  void build() {}
  @override
  Future<bool> applyProfile({
    bool silence = false,
    bool force = false,
    Future<void> Function()? preloadInvoke,
  }) async {
    applies++;
    return true;
  }

  @override
  Future<bool> setRunning(bool value, {bool initialize = false}) async {
    running = value;
    return true;
  }
}

const _old =
    'proxies: [{name: "US One", type: socks5, server: 127.0.0.1, port: 10001}]';
const _new =
    'proxies: [{name: "US Two", type: socks5, server: 127.0.0.1, port: 10002}]';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory home;
  late HttpServer server;
  late _Core core;
  late ProviderContainer container;
  late PortRoutingAction action;
  late File original;
  late Profile source;
  late _Setup setup;
  var content = _new;
  var requests = 0;
  Completer<void>? responseGate;
  HttpOverrides? originalOverrides;

  setUpAll(() async {
    originalOverrides = HttpOverrides.current;
    HttpOverrides.global = null;
    await AppLocalizations.load(const Locale('en'));
    globalState.packageInfo = PackageInfo(
      appName: 'FlClash',
      packageName: 'test',
      version: '0.9.3',
      buildNumber: '1',
    );
    registerFallbackValue(
      const SetupParams(
        selectedMap: {},
        options: CoreOptions(testUrl: 'https://example.test'),
      ),
    );
    registerFallbackValue(
      const ChangeProxyParams(groupName: '', proxyName: ''),
    );
  });

  tearDownAll(() {
    HttpOverrides.global = originalOverrides;
  });

  setUp(() async {
    requests = 0;
    responseGate = null;
    content = _new;
    home = await Directory.systemTemp.createTemp('flclash-port-update-');
    await useAppPaths(home);
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      requests++;
      if (responseGate != null) await responseGate!.future;
      request.response.headers.contentType = ContentType.text;
      request.response.add(utf8.encode(content));
      await request.response.close();
    });
    core = _Core();
    setup = _Setup();
    when(() => core.validateConfig(any())).thenAnswer((_) async => null);
    when(() => core.validateProxies(any())).thenAnswer((_) async => {});
    when(
      () => core.sideLoadExternalProvider(
        providerName: any(named: 'providerName'),
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async {});
    when(() => core.getExternalProviders()).thenAnswer((_) async => []);
    when(
      () => core.changeProxy(any()),
    ).thenAnswer((_) async => const ChangeProxyResult());
    when(() => core.getProxies()).thenAnswer(
      (_) async => const ProxiesData(
        all: ['one'],
        proxies: {
          'one': {
            'name': 'one',
            'type': 'Selector',
            'all': ['REJECT'],
            'now': 'REJECT',
          },
          'REJECT': {'name': 'REJECT', 'type': 'Reject'},
        },
      ),
    );
    source = Profile.normal(
      url: 'http://127.0.0.1:${server.port}/subscription',
    ).copyWith(id: 11);
    final workspace = Profile.custom(label: 'Ports').copyWith(id: 9);
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles([source, workspace])),
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
        setupActionProvider.overrideWith(() => setup),
        ...buildConfigOverrides(
          const Config(
            themeProps: defaultThemeProps,
            currentProfileId: 9,
            portRouting: PortRoutingConfig(
              workspaceProfileId: 9,
              previousProfileId: 11,
              bindings: [
                PortBinding(
                  id: 1,
                  name: 'One',
                  profileId: 11,
                  port: 18081,
                  node: 'US One',
                ),
              ],
            ),
          ),
        ),
      ],
    );
    globalState.container = container;
    action = container.read(portRoutingActionProvider.notifier);
    original = File(await appPath.getProfilePath('11'));
    await original.parent.create(recursive: true);
    await original.writeAsString(_old);
    await action.prepare(container.read(portRoutingSettingProvider));
  });

  tearDown(() async {
    if (responseGate != null && !responseGate!.isCompleted) {
      responseGate!.complete();
    }
    container.dispose();
    await server.close(force: true);
    await home.delete(recursive: true);
  });

  Future<File> goodCache() async => File(
    '${(await action.prepare(container.read(portRoutingSettingProvider))).providers[portProviderName(11)]['path']}.good',
  );

  test(
    'refresh updates only the source provider and deduplicates requests',
    () async {
      responseGate = Completer();
      final first = action.refresh(11);
      final second = container
          .read(profilesActionProvider.notifier)
          .updateProfile(source);
      responseGate!.complete();
      await Future.wait([first, second]);
      expect(requests, 1);
      expect(await original.readAsString(), _new);
      expect(
        container.read(profilesProvider).getProfile(11)!.lastUpdateDate,
        isNotNull,
      );
      verify(
        () => core.sideLoadExternalProvider(
          providerName: portProviderName(11),
          data: any(named: 'data'),
        ),
      ).called(1);
      verifyNever(() => core.setupConfig(any()));
      verifyNever(() => core.closeConnections());
      expect(container.read(portRoutingActivityProvider).refreshing, isEmpty);
    },
  );

  test(
    'invalid subscription keeps disk and running provider unchanged',
    () async {
      content = 'proxies: []';
      await expectLater(
        action.refresh(11),
        throwsA(isA<PortRoutingException>()),
      );
      expect(await original.readAsString(), _old);
      verifyNever(
        () => core.sideLoadExternalProvider(
          providerName: any(named: 'providerName'),
          data: any(named: 'data'),
        ),
      );
      expect(
        container.read(portRoutingActivityProvider).errors[11],
        PortRoutingIssue.emptySubscription,
      );
    },
  );

  test('failed provider update restores the last working cache', () async {
    var attempts = 0;
    when(
      () => core.sideLoadExternalProvider(
        providerName: any(named: 'providerName'),
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async {
      if (++attempts == 1) {
        throw const PortRoutingException(PortRoutingIssue.updateFailed);
      }
    });
    final cache = await goodCache();
    final previous = await cache.readAsString();
    await expectLater(action.refresh(11), throwsA(isA<PortRoutingException>()));
    expect(await original.readAsString(), _old);
    expect(await cache.readAsString(), previous);
    expect(attempts, 2);
  });

  test('switching profile during download discards the late result', () async {
    responseGate = Completer();
    final update = action.refresh(11);
    container.read(currentProfileIdProvider.notifier).value = 11;
    responseGate!.complete();
    await expectLater(update, throwsA(isA<PortRoutingException>()));
    expect(await original.readAsString(), _old);
    verifyNever(
      () => core.sideLoadExternalProvider(
        providerName: any(named: 'providerName'),
        data: any(named: 'data'),
      ),
    );
    expect(container.read(currentProfileIdProvider), 11);
  });

  test('editing source URL during download discards the late result', () async {
    responseGate = Completer();
    final update = action.refresh(11);
    container
        .read(profilesProvider.notifier)
        .put(source.copyWith(url: '${source.url}?changed=1'));
    responseGate!.complete();
    await expectLater(update, throwsA(isA<PortRoutingException>()));
    expect(await original.readAsString(), _old);
  });

  test(
    'managed source deletion is blocked while bindings refer to it',
    () async {
      await expectLater(
        container.read(profilesActionProvider.notifier).deleteProfile(11),
        throwsA(isA<MessageException>()),
      );
      expect(container.read(profilesProvider).getProfile(11), isNotNull);
    },
  );

  test('system settings remain saved while effective system proxy is off', () {
    container
        .read(networkSettingProvider.notifier)
        .update((value) => value.copyWith(systemProxy: true));
    container.read(runTimeProvider.notifier).value =
        DateTime.now().millisecondsSinceEpoch;
    expect(container.read(proxyStateProvider).systemProxy, isFalse);
    expect(container.read(networkSettingProvider).systemProxy, isTrue);
    expect(
      FlClashHttpOverrides.findProxyFor(
        container,
        Uri.parse('https://example.test'),
      ),
      'DIRECT',
    );
    container.read(currentProfileIdProvider.notifier).value = 11;
    expect(container.read(proxyStateProvider).systemProxy, isTrue);
  });

  test('activation and deactivation preserve the previous profile', () async {
    container.read(currentProfileIdProvider.notifier).value = 11;
    container.read(coreStatusProvider.notifier).value = CoreStatus.connected;
    await action.activate();
    expect(container.read(currentProfileIdProvider), 9);
    expect(container.read(portRoutingSettingProvider).previousProfileId, 11);
    expect(setup.running, isTrue);
    await action.deactivate();
    expect(container.read(currentProfileIdProvider), 11);
    expect(setup.applies, 2);
  });

  test(
    'automatic group cache resets without closing other connections',
    () async {
      final config = container.read(portRoutingSettingProvider);
      container.read(portRoutingSettingProvider.notifier).value = config
          .copyWith(
            bindings: [
              config.bindings.single.copyWith(
                selection: PortSelection.region,
                filter: 'US',
              ),
            ],
          );
      await action.refresh(11);
      verify(
        () => core.changeProxy(
          const ChangeProxyParams(
            groupName: 'flclash_ports_group_1',
            proxyName: '',
          ),
        ),
      ).called(1);
      verifyNever(() => core.closeConnections());
    },
  );

  test('scheduler obeys per-source pause and update interval', () async {
    container.read(coreStatusProvider.notifier).value = CoreStatus.connected;
    action.setRefresh(
      const PortSubscriptionRefresh(profileId: 11, enabled: false),
    );
    await action.tick();
    expect(requests, 0);
    action.setRefresh(const PortSubscriptionRefresh(profileId: 11));
    await action.tick();
    expect(requests, 1);
    await action.tick();
    expect(requests, 1);
  });
}
