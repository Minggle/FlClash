import 'package:fl_clash/common/port_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/port_routing.g.dart';

enum PortBindingPhase { stopped, checking, listening, blocked, failed }

class PortBindingCheck {
  final PortBindingPhase phase;
  final String? node;
  final PortRoutingIssue? issue;

  const PortBindingCheck(this.phase, {this.node, this.issue});
}

class PortRoutingRuntime {
  final Map<int, PortBindingCheck> ports;
  final Set<int> refreshing;
  final Map<int, PortRoutingIssue> errors;

  const PortRoutingRuntime({
    this.ports = const {},
    this.refreshing = const {},
    this.errors = const {},
  });
}

@Riverpod(keepAlive: true)
class PortRoutingActivity extends _$PortRoutingActivity {
  @override
  PortRoutingRuntime build() => const PortRoutingRuntime();

  void clearChecks() => state = PortRoutingRuntime(
    refreshing: state.refreshing,
    errors: state.errors,
  );

  void check(int id, PortBindingCheck value) => state = PortRoutingRuntime(
    ports: {...state.ports, id: value},
    refreshing: state.refreshing,
    errors: state.errors,
  );

  void updating(int id, bool updating, [PortRoutingIssue? issue]) {
    final pending = {...state.refreshing};
    updating ? pending.add(id) : pending.remove(id);
    final errors = {...state.errors}..remove(id);
    if (issue != null) errors[id] = issue;
    state = PortRoutingRuntime(
      ports: state.ports,
      refreshing: pending,
      errors: errors,
    );
  }
}
