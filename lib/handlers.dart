import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:vin_decoder/vin_decoder.dart';
import 'package:vin_decoder_service/log.dart';

Future<void> handleVinDecode(HttpRequest req) async {
  Map <String, String> vinData = Map<String, String>();
  HttpResponse resp = req.response;
  String content = await utf8.decoder.bind(req).join();
  var data = jsonDecode(content) as Map;
  var vin = VIN(number: data['vin']);

  if (!vin.valid(data['vin'])) {
    resp
      ..statusCode = HttpStatus.unprocessableEntity
      ..write('Invalid VIN ${vin.number} supplied');

    logRequest(req, resp.statusCode);

    await resp.close();
  }

  vinData['wmi'] = vin.wmi;
  vinData['vds'] = vin.vds;
  vinData['vis'] = vin.vis;

  vinData['year'] = vin.getYear().toString();
  vinData['region'] = vin.getRegion();
  vinData['manufacturer'] = vin.getManufacturer();
  vinData['assembly_plant'] = vin.assemblyPlant();
  vinData['serial_number'] = vin.serialNumber();

  resp
    ..statusCode = HttpStatus.ok
    ..write(jsonEncode(vinData));

  logRequest(req, resp.statusCode);

  await resp.close();
}

void handleRequest(HttpRequest req) {
  ContentType contentType = req.headers.contentType;
  HttpResponse resp = req.response;

  // Only handle JSON-encoded POST requests
  if (req.method == 'POST' && contentType?.mimeType == 'application/json' &&
      req.uri.path == '/vin') {
    handleVinDecode(req);
    return;
  }

  // Explicitly return 404 for invalid endpoint requests
  if (req.uri.path != '/vin') {
    resp
      ..statusCode = HttpStatus.notFound
      ..write('Invalid endpoint: ${req.uri.path}');

    logRequest(req, resp.statusCode);
    resp.close();

    return;
  }

  resp
    ..statusCode = HttpStatus.methodNotAllowed
    ..write('Unsupported request: ${req.method}.');

  logRequest(req, resp.statusCode);

  resp.close();
}
