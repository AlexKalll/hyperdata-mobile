import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

class FakeApiTransport implements HttpClientAdapter {
  final Object? Function(RequestOptions) respond;
  final int statusCode;

  FakeApiTransport(this.respond, {this.statusCode = 200});

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    final body = respond(options);
    return ResponseBody.fromString(statusCode == 204 ? '' : jsonEncode(body), statusCode,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType]
        });
  }

  @override
  void close({bool force = false}) {}
}
