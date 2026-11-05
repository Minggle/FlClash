# 多订阅独立端口

Windows：打开 **工具 → 多订阅端口**。先在原有配置页面导入订阅，再添加端口绑定：选择订阅、端口以及固定节点或区域关键词，最后开启专用多端口模式。区域关键词以 `|` 分隔，忽略大小写，按节点名称匹配；自动选择衡量延迟，不是带宽或出口国家认证。

每个端口同时支持 HTTP、HTTPS CONNECT 和 SOCKS5 TCP，只监听 `127.0.0.1`。例如两个应用分别设置 `http://127.0.0.1:18081` 和 `socks5h://127.0.0.1:18082`。右键绑定可复制地址、更新订阅和设置更新间隔。一个订阅可建立多条绑定。此版本不支持 UDP、局域网共享或按进程接管。

开启时切入受管理的自定义配置，关闭时恢复此前配置。选择其他普通配置也会停用端口。此模式在运行时关闭系统代理、TUN 和默认混合端口，不改写这些功能原有的保存值。应用自身下载在此模式直接连接，避免使用已经关闭的默认端口。

## 节点与更新

- 使用已有订阅的顶层代理节点；嵌套 `proxy-providers`、直接连接节点、重复节点名和带 `dialer-proxy` 的代理链会被拒绝。现有导入支持的分享链接与加密订阅仍由原校验流程转换。
- 固定节点按完整名称匹配；消失后拒绝新连接。自动组只选择本订阅中匹配关键词的节点，候选为空时同样拒绝。不会自动转成直连或另一个订阅。
- 每个订阅默认每 5 分钟拉取，调度器每 30 秒检查到期任务。更新设置对同一订阅的所有端口生效，可暂停或改为 1～1440 分钟。程序退出期间不更新。
- 更新使用临时文件校验及 provider 局部加载；失败保留最后成功的磁盘缓存与节点。自动组的选择缓存通过现有 Core 选组接口复位。普通更新不关闭其他订阅的已有连接；修改端口或选择策略会重新应用配置，可能短暂重连。
- “已监听”表示端口归当前 Core 所有且 SOCKS 握手成功，不表示节点的互联网出口已验证。

## 维护与验证

主功能分支：`feature/multi-subscription-ports`。新增代码集中在 `lib/common/port_*`、`lib/models/port_routing.dart`、`lib/providers/*port_routing*` 和 `lib/views/port_routing.dart`。配置持久化使用 `Config.portRouting`，没有新增数据库 schema 版本；旧设置默认关闭。恢复备份时检查订阅引用并丢弃可重建缓存。

没有修改 mihomo、Rust、Helper 或原生生命周期。`CoreService.processId` 只读暴露已持有的进程 ID，用于监听归属检查。

```powershell
flutter pub get
dart run build_runner build
dart run intl_utils:generate
flutter analyze --no-fatal-infos
flutter test test/common/port_routing_test.dart test/providers/port_routing_action_test.dart test/views/port_routing_test.dart
$env:CGO_ENABLED = '0'
go test -C core . -run '^TestPortRoutingWire$' -count=1 -v
flutter build windows --release
```

Go 测试在独立子进程与临时目录运行，只使用回环端口和本地模拟出口，覆盖 HTTP/SOCKS5 分离、区域选择、局部更新保留另一个订阅的持续连接，以及空源/节点消失的拒绝行为。不会启动 GUI、TUN 或修改系统代理。外部真实订阅与公网出口仍需实际环境验收。

本机 GUI 调试必须使用 `flutter run --dart-define=SAFE_MODE=true`。安全模式不会开放这些端口，真实流量测试应使用上述隔离测试或单独的 Windows 测试环境。

## Fork 发布

应用更新来源为 `Minggle/FlClash`。独立的 `Subscription ports - Windows` workflow 可以手动构建 ZIP；推送 `v*` 标签时发布并生成 `SHA256SUMS`，带 `-` 的标签（例如 `v0.9.4-ports.1`）发布为预发行版，纯数字标签（例如 `v0.9.4`）发布为正式版。原有上游 workflow 保留，未接入上游的 Telegram、Homebrew 或 F-Droid 发布凭据。GitHub 的 `releases/latest` 不包含预发行版本，因此预发行测试包手动安装；发布稳定版本时使用新的纯数字版本标签，构建会把标签中的数字版本写入应用。ZIP 便携版通过发布页手动更新；尚未提供安装器的自动替换流程。

合并上游稳定版本后重新生成代码，并优先运行多端口功能测试、配置/备份/HTTP 回归和桌面 Core 测试。不要在正式构建中关闭 `pubspec.yaml` 的原生 `build_assets` hooks。

## CI Runner 切换

`build` workflow 的 Dart、Plugins、Go core、Android unit tests、Rust 和 Desktop linux 共用仓库变量 `LINUX_CI_RUNNER`。未设置时使用 GitHub 的 `ubuntu-latest`，合并到其他仓库不会自动启用 Instabox。测试步骤、工具链版本和检查范围保持一致。

在 Instabox 的目标工作区连接 GitHub 的 `Minggle` 账号，并授权 `Minggle/FlClash` 后启用：

```powershell
gh variable set LINUX_CI_RUNNER --repo Minggle/FlClash --body instabox-medium
```

`instabox-medium` 是 Ubuntu 24.04、4 vCPU / 8 GiB 的临时机器，支持免费计划；每个 job 结束后自动删除。Windows、macOS 原生构建仍使用 GitHub 对应平台的 runner；Instabox 无法解决 macOS 构建机容量不足。实际耗时取决于排队、缓存和工作区额度，应比较完整 CI 耗时后再判断是否加速。

首次启用后同时查看 `gh run view <run-id> --repo Minggle/FlClash` 和 `instabox ci`。若 GitHub 排队而 Instabox 没有对应 job，检查 App 对此仓库的访问授权；若 Instabox 显示拒绝或等待，按其中的原因处理。回退命令只影响之后调度的任务：

```powershell
gh variable delete LINUX_CI_RUNNER --repo Minggle/FlClash
```

已排队的任务需要取消后重新运行才会使用回退后的 runner。原有上游发布 job 和独立的 Windows 发布 workflow 不受这个变量控制。

参考：[Instabox CI 官方文档](https://instabox.sh/docs/ci.md)。

## 本次验证记录

基线 `be847366`（v0.9.3），Windows x64，Flutter 3.47.6 / Dart 3.13.5 / Go 1.27.3。

- `flutter pub get`、代码生成、国际化生成、`flutter analyze --no-fatal-infos` 完成。
- 多端口、配置、备份、HTTP、桌面 Core/协议及国际化集成测试通过（205 项）；其后补跑订阅导入/更新回归（16 项）与页面编辑/导航/布局测试（5 项）通过。计数为各次运行，不应相加为唯一测试数。
- `TestPortRoutingWire` 在 Windows 独立子进程中通过：HTTP/SOCKS5 端口出口隔离、自动组更新、固定节点/区域消失拒绝连接、空订阅不替换、订阅 B 持续连接不受 A 更新影响。
- 发布更新/下载相关测试通过（23 项），`go vet . ./cmd/...` 和独立 workflow 的 `actionlint` 通过。
- Windows Release 编译成功，包含 GUI、Go Core、Helper、Rust DLL 和 SQLite DLL。未使用真实订阅验证公网出口，也没有在主机上启动普通代理模式。
- 原有 `test/lint/` 在 Windows 下有 9 项路径相关误报，因检查用 `/` 匹配豁免路径而 Windows 返回 `\`。与新功能相关的布局检查、国际化键集合检查已通过。
- 全部 Go wrapper 测试在 Windows 下仍有两项既有兼容问题：`TestApplyConfigTellsARejectedProfileFromAFailedCall` 的 cache.db 句柄阻止临时目录清理；`TestHandleValidateProxiesLeavesARunningProxysResolverInPlace` 的路径错误文本断言不同。独立 Windows workflow 运行新增流量测试和 `go vet`，原有 Linux workflow 继续跑 Go 全套。
