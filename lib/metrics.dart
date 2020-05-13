import 'package:prometheus_client/prometheus_client.dart';
import 'package:prometheus_client/runtime_metrics.dart' as runtime_metrics;

final totalRequestsCounter = Counter(
    'vin_decoder_requests_total', 'The total number of VIN decode requests');

void initMetrics() {
  runtime_metrics.register();
  totalRequestsCounter.register();
}