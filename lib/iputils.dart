import 'dart:io';

// Fetch a list of all non-loopback IP addresses
Future<List<String>> getLocalIPs(
    [InternetAddressType type = InternetAddressType.any]) async {
  List<String> addresses = List();

  for (var interface in await NetworkInterface.list()) {
    for (var addr in interface.addresses) {
      if (addr.isLoopback == false &&
          (addr.type == type || type == InternetAddressType.any)) {
        addresses.add(addr.address);
      }
    }
  }

  return addresses;
}

// Fetch the first private (non-loopback) IP address
Future<String> getLocalIP(
    [InternetAddressType type = InternetAddressType.any]) async {
  List<String> addresses = await getLocalIPs(type);
  return addresses.first;
}
