import 'dart:async';
import 'dart:io';
import 'package:vin_decoder_service/handlers.dart';
import 'package:args/args.dart';

Future main(List<String> args) async {
  exitCode = 0;

  final ArgParser parser = ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '4040', help: 'Port to bind to')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage info');
  final ArgResults results = parser.parse(args);

  final bool showHelp = results['help'] as bool;
  final port = int.parse(results['port'].toString());

  if (showHelp) {
    print('usage: vindecoder-service [-p]\n');
    print(parser.usage);
    exit(1);
  }

  final HttpServer server = await HttpServer.bind(
    InternetAddress.anyIPv4, port,
  );

  print('VIN Decoder Service Registered on ${server.address.address}:${server.port}/vin');

  try {
    await for (HttpRequest req in server) {
      handleRequest(req);
    }
  } catch(_) {
    print("Terminating...");
    exitCode = 2;
  }
}