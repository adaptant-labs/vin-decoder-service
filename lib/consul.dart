import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> registerConsulService(String serviceId, String host,
    int port, String consulAgent) async {
  var url = 'http://' + consulAgent + '/v1/agent/service/register';
  var data = {
    'Name': serviceId,
    'Address': host,
    'Port': port,
  };
  var response = await http.put(url, body: json.encode(data));

  if (response.statusCode != HttpStatus.ok) {
    print("Failed to register with Consul agent: " + response.body);
  }
}

Future<void> deregisterConsulService(String serviceId, String consulAgent) async {
  var url = 'http://' + consulAgent +
      '/v1/agent/service/deregister/' + serviceId;
  var response = await http.put(url);

  if (response.statusCode != HttpStatus.ok) {
    print("Failed to deregister service from Consul agent: " + response.body);
  }
}
