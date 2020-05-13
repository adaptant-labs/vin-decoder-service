## 0.1.0

- Add prometheus '/metrics' endpoint.
- Check Consul Agent connectivity in services health check, if used.
- Update to v0.1.1 of `vin-decoder-dart`, bump up other dependencies.

## 0.0.4

- Update to v0.1.0 of `vin-decoder-dart`, include make/model/type information.

## 0.0.3

- Addition of `/health` endpoint for microservice health checking
- Default to first available non-loopback IPv4 address for Consul service registration
- Support argument pass-through to Docker image

## 0.0.2+1

- Minor fix for Dart SDK `HttpRequest` and `HttpClientResponse` breakage

## 0.0.2

- Consul service registration and de-registration
- Signal handling (SIGINT on Windows, SIGINT + SIGTERM on Linux) for Ctrl-C cleanup

## 0.0.1

- Initial version
