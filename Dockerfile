FROM google/dart AS dart-runtime

WORKDIR /app

ADD pubspec.* /app/
RUN pub get
ADD bin /app/bin/
ADD lib /app/lib/
RUN pub get --offline
RUN dart2aot /app/bin/server.dart  /app/server.aot

FROM bitnami/minideb

COPY --from=dart-runtime /app/server.aot /server.aot
COPY --from=dart-runtime /usr/lib/dart/bin/dartaotruntime /dartaotruntime

CMD []
ENTRYPOINT ["/dartaotruntime", "/server.aot"]

EXPOSE 8080
