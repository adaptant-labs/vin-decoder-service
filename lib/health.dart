import 'dart:io';

class HealthCheckAddress {
  String host;
  int port;

  HealthCheckAddress(this.host, this.port);

  Future<bool> isReachable() async {
    Socket sock;
    try {
      sock = await Socket.connect(
        host,
        port,
        timeout: Duration(seconds: 10),
      );
      sock?.destroy();
      return true;
    } catch (e) {
      sock?.destroy();
      return false;
    }
  }

  @override
  String toString() {
    return 'HealthCheckAddress[host=$host, port=$port]';
  }
}

final healthCheckAddresses = List<HealthCheckAddress>();

Future<void> addHealthCheckService(String address, int port) async {
  healthCheckAddresses.add(HealthCheckAddress(address, port));
}

// Iterate over the registered services and ensure that they are all connectable
Future<bool> healthCheckServicesReachable() async {
  for (var service in healthCheckAddresses) {
    var status = await service.isReachable();
    if (status != true) {
      return false;
    }
  }

  return true;
}