import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../data/http/http.dart';
import '../../main/factories/usecases/refresh_token/add_refresh_token_factory.dart';

class DioAdapter implements AdraHttpClient {
  final Dio client;
  DioAdapter(
    this.client,
  );

  String _truncate(String? input, {int max = 2000}) {
    if (input == null) return '';
    if (input.length <= max) return input;
    return input.substring(0, max);
  }

  Map<String, dynamic> _sanitizeHeaders(Map? headers) {
    if (headers == null) return {};
    final out = <String, dynamic>{};
    headers.forEach((key, value) {
      final k = key.toString().toLowerCase();
      final isSensitive = k.contains('authorization') ||
          k == 'cookie' ||
          k == 'set-cookie' ||
          k.contains('api-key');
      if (isSensitive) {
        out[key.toString()] = '***';
      } else {
        out[key.toString()] =
            value is String ? _truncate(value, max: 256) : value.toString();
      }
    });
    return out;
  }

  Map<String, String> _dioHeadersToMap(Headers? headers) {
    if (headers == null) return {};
    final map = <String, String>{};
    headers.map.forEach((key, values) {
      map[key] = values.join('; ');
    });
    return map;
  }

  String _stringifyBody(dynamic data) {
    try {
      if (data == null) return '';
      if (data is String) return data;
      if (data is FormData) {
        final fields = {for (final e in data.fields) e.key: e.value};
        return jsonEncode(
            {'formDataFields': fields, 'files': data.files.length});
      }
      if (data is Map || data is List) return jsonEncode(data);
      return data.toString();
    } catch (_) {
      return '<<unstringifiable body>>';
    }
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
    client.interceptors.add(TokenInterceptor(client));
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll(method == HttpMethod.multipart
          ? {'content-type': 'multipart/form-data'}
          : {'content-type': 'application/json', 'accept': 'application/json'});
    final jsonBody = body != null ? jsonEncode(body) : null;
    developer.log(
        '=======================================================================',
        name: 'START');
    developer.log('HTTPLOG', name: 'DioAdapter');
    developer.log(url, name: 'URL');
    developer.log(jsonBody ?? '', name: 'BODY');
    developer.log(headers.toString(), name: 'HEADERS');
    developer.log(queryParameters.toString(), name: 'QUERYPARAMETERS');

    final option = Options(
        headers: defaultHeaders,
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 24));
    try {
      Uri uri = Uri.parse(url);
      final finalUri = uri.replace(queryParameters: queryParameters).toString();

      if (method == HttpMethod.post) {
        final futureResponse =
            await client.post(finalUri, options: option, data: body);
        return _handleResponse(futureResponse);
      } else if (method == HttpMethod.patch) {
        final futureResponse =
            await client.patch(finalUri, options: option, data: body);
        return _handleResponse(futureResponse);
      } else if (method == HttpMethod.get) {
        final futureResponse = await client.get(finalUri, options: option);
        return _handleResponse(futureResponse);
      } else if (method == HttpMethod.put) {
        final futureResponse =
            await client.put(finalUri, options: option, data: body);
        return _handleResponse(futureResponse);
      } else if (method == HttpMethod.delete) {
        final futureResponse = await client.delete(finalUri, options: option);
        return _handleResponse(futureResponse);
      }
    } catch (error, stack) {
      developer.log(error.toString(), name: 'ERROR');
      try {
        await FirebaseCrashlytics.instance.setCustomKey('flow', 'dio_request');
        await FirebaseCrashlytics.instance.setCustomKey('endpoint', url);
        await FirebaseCrashlytics.instance.setCustomKey('method', method.name);
        await FirebaseCrashlytics.instance
            .setCustomKey('has_body', body != null);
        await FirebaseCrashlytics.instance.setCustomKey(
            'has_query', queryParameters != null && queryParameters.isNotEmpty);
        // Request context
        await FirebaseCrashlytics.instance.setCustomKey(
            'request_headers', jsonEncode(_sanitizeHeaders(defaultHeaders)));
        await FirebaseCrashlytics.instance.setCustomKey(
            'request_body_trunc', _truncate(_stringifyBody(body)));
        if (error is DioException) {
          await FirebaseCrashlytics.instance
              .setCustomKey('dio_type', error.type.toString());
          await FirebaseCrashlytics.instance
              .setCustomKey('status_code', error.response?.statusCode ?? -1);
          await FirebaseCrashlytics.instance
              .setCustomKey('path', error.requestOptions.path);
          // Response context (if available)
          final respHeaders = _dioHeadersToMap(error.response?.headers);
          await FirebaseCrashlytics.instance.setCustomKey(
              'response_headers', jsonEncode(_sanitizeHeaders(respHeaders)));
          await FirebaseCrashlytics.instance.setCustomKey('response_body_trunc',
              _truncate(_stringifyBody(error.response?.data)));
        }
        FirebaseCrashlytics.instance.recordError(
          error,
          stack,
          fatal: false,
          reason: 'DioAdapter.request error',
        );
      } catch (_) {
        throw HttpError.serverError;
      }
      throw HttpError.serverError;
    }
  }

  dynamic _handleResponse(Response? response) {
    developer.log(response!.data.toString(), name: 'RESPONSE');
    developer.log(response.statusCode.toString(), name: 'STATUSCODE');
    developer.log(
        '=========================================================================',
        name: 'END');

    switch (response.statusCode) {
      case 200:
        return response.data.isEmpty ? null : response.data;
      case 204:
        return null;
      case 400:
        final json = response.data;
        if (json.containsKey('errors')) {
          return response.data.isEmpty ? null : json;
        }
        throw HttpError.badRequest;
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbidden;
      case 404:
        final json = response.data;
        if (json.containsKey('errors')) {
          return response.data.isEmpty ? null : json;
        }
        throw HttpError.notFound;
      default:
        try {
          FirebaseCrashlytics.instance
              .setCustomKey('flow', 'dio_response_unhandled');
          FirebaseCrashlytics.instance
              .setCustomKey('status_code', response.statusCode ?? -1);
          FirebaseCrashlytics.instance
              .setCustomKey('has_data', response.data != null);
          // Attach request/response context
          final reqHeaders = _sanitizeHeaders(response.requestOptions.headers);
          final reqBody =
              _truncate(_stringifyBody(response.requestOptions.data));
          final resHeaders =
              _sanitizeHeaders(_dioHeadersToMap(response.headers));
          final resBody = _truncate(_stringifyBody(response.data));
          FirebaseCrashlytics.instance
              .setCustomKey('request_headers', jsonEncode(reqHeaders));
          FirebaseCrashlytics.instance
              .setCustomKey('request_body_trunc', reqBody);
          FirebaseCrashlytics.instance
              .setCustomKey('response_headers', jsonEncode(resHeaders));
          FirebaseCrashlytics.instance
              .setCustomKey('response_body_trunc', resBody);
          FirebaseCrashlytics.instance.recordError(
            'Unhandled HTTP status code',
            StackTrace.current,
            fatal: false,
            reason: 'DioAdapter._handleResponse default',
          );
        } catch (_) {
          throw HttpError.serverError;
        }
        throw HttpError.serverError;
    }
  }
}

class TokenInterceptor extends Interceptor {
  final Dio _dio;
  TokenInterceptor(this._dio);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    handler.next(options);
  }

  @override
  // ignore: deprecated_member_use
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      RequestOptions requestOptions = err.requestOptions;

      try {
        final refreshToken = makeRemoteAddRefreshToken();
        final newToken = await refreshToken.refresh();
        final opts = Options(
          method: requestOptions.method,
          headers: {
            ...requestOptions.headers,
            'Authorization': 'Bearer ${newToken.accessToken}',
          },
        );

        final response = await _dio.request(
          requestOptions.path,
          options: opts,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
        );

        handler.resolve(response);
      } catch (e, stack) {
        try {
          await FirebaseCrashlytics.instance
              .setCustomKey('flow', 'token_interceptor_refresh');
          await FirebaseCrashlytics.instance
              .setCustomKey('original_path', requestOptions.path);
          FirebaseCrashlytics.instance.recordError(
            e,
            stack,
            fatal: false,
            reason: 'Failed to refresh token and retry request',
          );
        } catch (_) {}
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}
