import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../../data/http/http.dart';

class HttpAdapter implements AdraHttpClient {
  final Client client;

  HttpAdapter(this.client);

  String _truncate(String value, {int max = 2000}) {
    final s = value;
    return s.length > max ? s.substring(0, max) : s;
  }

  Map<String, String> _sanitizeHeaders(Map<String, String> headers) {
    final blocked = {'authorization', 'cookie', 'set-cookie'};
    final out = <String, String>{};
    headers.forEach((k, v) {
      if (!blocked.contains(k.toLowerCase())) {
        out[k] = v;
      }
    });
    return out;
  }

  @override
  Future<dynamic> request({
    required String url,
    required HttpMethod method,
    Map? body,
    Map? headers,
    Map<String, dynamic>? queryParameters,
    File? file,
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll(method == HttpMethod.multipart
          ? {
              'Content-Type': 'multipart/form-data',
              'accept': 'application/json'
            }
          : {'Content-Type': 'application/json', 'accept': 'application/json'});
    final jsonBody = body != null ? jsonEncode(body) : null;
    developer.log(
        '=======================================================================',
        name: 'START');
    developer.log('HTTPLOG', name: 'HttpAdapter');
    developer.log(url, name: 'URL');
    developer.log(method.name, name: 'METHOD');
    developer.log(jsonBody ?? '', name: 'BODY');
    developer.log(headers.toString(), name: 'HEADERS');
    developer.log(queryParameters.toString(), name: 'QUERYPARAMETERS');

    try {
      Uri uri = Uri.parse(url);
      final finalUri = uri.replace(queryParameters: queryParameters);
      switch (method) {
        case HttpMethod.post:
          final response = await client.post(finalUri,
              headers: defaultHeaders, body: jsonBody);
          return _handleResponse(response);
        case HttpMethod.get:
          final response = await client.get(finalUri, headers: defaultHeaders);
          return _handleResponse(response);
        case HttpMethod.patch:
          final response = await client.patch(finalUri,
              headers: defaultHeaders, body: jsonBody);
          return _handleResponse(response);
        case HttpMethod.put:
          final response = await client.put(finalUri,
              headers: defaultHeaders, body: jsonBody);
          return _handleResponse(response);
        case HttpMethod.delete:
          final response = await client.put(finalUri, headers: defaultHeaders);
          return _handleResponse(response);
        case HttpMethod.multipart:
          final request = http.MultipartRequest('PUT', uri);
          String fileName = file!.path.split('/').last;
          String extension = fileName.split('.').last;
          request.headers['authorization'] = headers?['authorization'];

          request.files.add(
            await http.MultipartFile.fromPath(
              'file',
              file.path,
              contentType: MediaType('image', extension),
            ),
          );

          final response = await request.send();
          if (response.statusCode == 200) {
            return true;
          } else {
            _handleResponse(
                Response(response.reasonPhrase ?? '', response.statusCode));
          }
      }
    } catch (error, stack) {
      developer.log(error.toString(), name: 'ERROR');
      try {
        await FirebaseCrashlytics.instance.setCustomKey('flow', 'http_request');
        await FirebaseCrashlytics.instance.setCustomKey('endpoint', url);
        await FirebaseCrashlytics.instance.setCustomKey('method', method.name);
        await FirebaseCrashlytics.instance
            .setCustomKey('has_body', body != null);
        await FirebaseCrashlytics.instance.setCustomKey(
            'has_query', queryParameters != null && queryParameters.isNotEmpty);
        await FirebaseCrashlytics.instance.setCustomKey(
            'request_headers',
            _sanitizeHeaders((headers?.cast<String, String>() ?? {}))
                .toString());
        await FirebaseCrashlytics.instance.setCustomKey(
            'request_body_trunc', _truncate(jsonBody?.toString() ?? ''));
        FirebaseCrashlytics.instance.recordError(
          error,
          stack,
          fatal: false,
          reason: 'HttpAdapter.request error',
        );
      } catch (_) {
        throw HttpError.serverError;
      }
      if (error is HttpError) rethrow;
      throw HttpError.serverError;
    }
  }

  dynamic _handleResponse(Response response) {
    developer.log(response.body.toString(), name: 'RESPONSE');
    developer.log(response.statusCode.toString(), name: 'STATUSCODE');
    developer.log(
        '=========================================================================',
        name: 'END');

    switch (response.statusCode) {
      case 200:
        return response.body.isEmpty ? null : jsonDecode(response.body);
      case 204:
        return null;
      case 400:
        final json = jsonDecode(response.body);
        if (json.containsKey('errors')) {
          return response.body.isEmpty ? null : json;
        }
        throw HttpError.badRequest;
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbidden;
      case 404:
        final json = jsonDecode(response.body);
        if (json.containsKey('errors')) {
          return response.body.isEmpty ? null : json;
        }
        throw HttpError.notFound;
      default:
        try {
          FirebaseCrashlytics.instance
              .setCustomKey('flow', 'http_response_unhandled');
          FirebaseCrashlytics.instance
              .setCustomKey('status_code', response.statusCode);
          FirebaseCrashlytics.instance
              .setCustomKey('has_body', response.body.isNotEmpty);
          FirebaseCrashlytics.instance.setCustomKey(
              'response_headers',
              _sanitizeHeaders(response.headers.map((k, v) => MapEntry(k, v)))
                  .toString());
          FirebaseCrashlytics.instance
              .setCustomKey('response_body_trunc', _truncate(response.body));
          FirebaseCrashlytics.instance.recordError(
            'Unhandled HTTP status code',
            StackTrace.current,
            fatal: false,
            reason: 'HttpAdapter._handleResponse default',
          );
        } catch (_) {
          throw HttpError.serverError;
        }
        throw HttpError.serverError;
    }
  }
}
