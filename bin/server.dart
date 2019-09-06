import 'dart:async';
import 'dart:io';
import 'package:vin_decoder_service/handlers.dart';
import 'package:vin_decoder_service/consul.dart';
import 'package:vin_decoder_service/iputils.dart';
import 'package:args/args.dart';
import 'package:async/async.dart';

Future main(List<String> args) async {
  exitCode = 0;

  final ArgParser parser = ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8080', help: 'Port to bind to')
    ..addOption('consul-agent', abbr: 'c',
        defaultsTo: 'localhost:8500',
        help: 'Consul Agent to register service with')
    ..addFlag('use-consul', abbr: 'u',
        defaultsTo: true,
        negatable: true,
        help: 'Use Consul for service registration')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage info');
  final ArgResults results = parser.parse(args);
  final bool useConsul = results['use-consul'] as bool;
  final bool showHelp = results['help'] as bool;
  final consulAgent = results['consul-agent'];
  final port = int.parse(results['port'].toString());

  if (showHelp) {
    print('usage: vindecoder-service [-pcu]\n');
    print(parser.usage);
    exit(1);
  }

  final HttpServer server = await HttpServer.bind(
    InternetAddress.anyIPv4, port,
  );

  if (useConsul == true) {
    String host = server.address.address;

    // While we bind to any address, require a valid IP for service registration
    if (host == '0.0.0.0') {
      // In this case we look up the first non-loopback IPv4 address.
      host = await getLocalIP(InternetAddressType.IPv4);
    }

    print("Registering VIN Decoder Service with Consul Agent @ " + consulAgent);
    await registerConsulService("vin-decoder", host, server.port, consulAgent);
  }

  print('VIN Decoder Service Registered on ' +
        '${server.address.address}:${server.port}/vin');

  // Handle Ctrl-C termination on both Windows (SIGINT only) and Linux hosts
  final _signals = Platform.isWindows
      ? ProcessSignal.sigint.watch()
      : StreamGroup.merge(
      [ProcessSignal.sigterm.watch(), ProcessSignal.sigint.watch()]);

  // De-register the service from the Consul server on cleanup
  Future<void> shutdown() async {
    if (useConsul == true) {
      print("De-registering VIN Decoder Service from Consul Agent");
      await deregisterConsulService("vin-decoder", consulAgent);
    }
    exit(-1);
  }

  // Signal handler
  _signals.first.then((s) {
    print("Caught ${s}, cleaning up...");
    shutdown();
  });

  try {
    await for (HttpRequest req in server) {
      handleRequest(req);
    }
  } catch(_) {
    print("Terminating...");
    await shutdown();
    exitCode = 2;
  }
}