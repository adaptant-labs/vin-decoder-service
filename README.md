# vin-decoder-service

[![Build Status](https://travis-ci.com/adaptant-labs/vin-decoder-service.svg?branch=master)](https://travis-ci.com/adaptant-labs/vin-decoder-service#)

A simple VIN decoding microservice wrapped around the [vin_decoder] package written in Dart.

[vin_decoder]: https://github.com/adaptant-labs/vin-decoder-dart

## Installation

The application can be activated from pub directly:

```
$ pub global activate --source path <path to repository>
Package vin_decoder_service is currently active at path "...".
Installed executable vindecoder-service.
Activated vin_decoder_service 0.0.2 at path "...".
```

## Usage

The `vindecoder-service` can run standalone, or can register itself with a Consul Agent to ease with service discovery. 
By default, an attempt to register with Consul will be made.

To run standalone on the server side and inhibit Consul registration, the `--no-use-consul` flag may be specified:

```
$ vindecoder-service --no-use-consul
VIN Decoder Service Registered on 0.0.0.0:8080/vin
...
```

otherwise, the default behaviour applies, and service registration will be attempted with the defined (or default)
agent:

```
$ vindecoder-service
Registering VIN Decoder Service with Consul Agent @ localhost:8500
VIN Decoder Service Registered on 0.0.0.0:8080/vin
...
```

An overview of supported commands and flags is provided below:

```
$ vindecoder-service --help
usage: vindecoder-service [-pcu]

-p, --port               Port to bind to
                         (defaults to "8080")

-c, --consul-agent       Consul Agent to register service with
                         (defaults to "localhost:8500")

-u, --[no-]use-consul    Use Consul for service registration
                         (defaults to on)

-h, --help               Show usage info
```

From the client side, decoding may be tested by sending a JSON-encoded VIN string:

```
$ curl -X POST -H "Content-Type: application/json" -d '{ "vin": "WP0ZZZ99ZTS392124" }' http://localhost:8080/vin
```

with the decoded VIN returned in the POST response body:

```
{"wmi":"WP0","vds":"ZZZ99Z","vis":"TS392124","year":"1996","region":"EU","manufacturer":"Porsche","assembly_plant":"S","serial_number":"92124"}
```

## Deployment

Docker images are provided under [adaptant/vin-decoder-service][docker] and can be run without any special
configuration:

```
$ docker run -d -p 8080:8080 adaptant/vin-decoder-service
```

[docker]: https://hub.docker.com/r/adaptant/vin-decoder-service

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/adaptant-labs/vin-decoder-service/issues

## License

Licensed under the terms of the Apache 2.0 license, the full version of which can be found in the
[LICENSE](https://raw.githubusercontent.com/adaptant-labs/vin-decoder-service/master/LICENSE)
file included in the distribution.
