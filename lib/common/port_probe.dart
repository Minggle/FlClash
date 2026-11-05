import 'dart:async';
import 'dart:io';

import 'port_routing.dart';

Future<Map<int, int>> windowsPortOwners() async {
  if (!Platform.isWindows) return const {};
  final result = await Process.run('netstat.exe', [
    '-ano',
    '-p',
    'tcp',
  ]).timeout(const Duration(seconds: 5));
  if (result.exitCode != 0) {
    throw const PortRoutingException(PortRoutingIssue.coreUnavailable);
  }
  return parseWindowsPortOwners(result.stdout.toString());
}

Map<int, int> parseWindowsPortOwners(String output) {
  final owners = <int, int>{};
  for (final line in output.split('\n')) {
    final fields = line.trim().split(RegExp(r'\s+'));
    if (fields.length != 5 ||
        fields.first != 'TCP' ||
        fields[2] != '0.0.0.0:0') {
      continue;
    }
    final local = fields[1];
    if (!local.startsWith('127.0.0.1:') && !local.startsWith('0.0.0.0:')) {
      continue;
    }
    final port = int.tryParse(local.substring(local.lastIndexOf(':') + 1));
    final owner = int.tryParse(fields.last);
    if (port != null && owner != null) owners[port] = owner;
  }
  return owners;
}

Future<void> checkPortAvailable(int port, {int? existingOwner}) async {
  if (existingOwner != null && Platform.isWindows) {
    if ((await windowsPortOwners())[port] == existingOwner) return;
  }
  try {
    final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, port);
    await socket.close();
  } on SocketException {
    throw const PortRoutingException(PortRoutingIssue.portOccupied);
  }
}

Future<void> checkSocksHandshake(int port) async {
  final socket = await Socket.connect(
    InternetAddress.loopbackIPv4,
    port,
    timeout: const Duration(seconds: 2),
  );
  final iterator = StreamIterator(socket);
  try {
    socket.add([5, 1, 0]);
    await socket.flush();
    final response = <int>[];
    final deadline = DateTime.now().add(const Duration(seconds: 2));
    while (response.length < 2) {
      final remaining = deadline.difference(DateTime.now());
      if (remaining.isNegative ||
          !await iterator.moveNext().timeout(remaining)) {
        throw const PortRoutingException(PortRoutingIssue.coreUnavailable);
      }
      response.addAll(iterator.current);
    }
    if (response[0] != 5 || response[1] != 0) {
      throw const PortRoutingException(PortRoutingIssue.coreUnavailable);
    }
  } finally {
    socket.destroy();
    await iterator.cancel();
  }
}
