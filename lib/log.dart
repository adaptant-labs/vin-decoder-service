import 'dart:io';
import 'package:intl/intl.dart';

// Convert current time zone to format used in the Apache Combined Log Format
String timeZoneString(Duration timeZoneOffset) {
  String hours = timeZoneOffset.inHours.toString().padLeft(2, '0');
  String mins = (timeZoneOffset.inMinutes % 60).toString().padLeft(2, '0');
  String timeZone = "${hours}${mins}";

  return timeZoneOffset.isNegative ? "-${timeZone}" : "+${timeZone}";
}

// Log the request in the Apache Combined Log Format
void logRequest(HttpRequest request, int statusCode) {
  DateTime now = DateTime.now();
  String date = DateFormat("dd/MMM/y:H:m:s").format(now);

  // 127.0.0.1 - - [25/Jun/2019:16:51:31 +0200] "POST /" 200 0
  print("${request.connectionInfo.remoteAddress.address} - - [${date} " +
      timeZoneString(now.timeZoneOffset) +
      "] \"${request.method} ${request.uri}\" ${statusCode} 0");
}