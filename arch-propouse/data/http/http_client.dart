import 'dart:io';

abstract class AdraHttpClient {
  Future<dynamic> request({
    required String url,
    required HttpMethod method,
    Map? body,
    Map? headers,
    Map<String, dynamic>? queryParameters,
    File? file,
  });
}

enum HttpMethod {
  post,
  get,
  patch,
  put,
  delete,
  multipart,
}
