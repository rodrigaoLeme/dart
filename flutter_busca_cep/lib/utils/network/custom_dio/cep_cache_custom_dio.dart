import 'package:dio/dio.dart';
import 'package:flutter_desafio_via_cep/utils/network/interceptors/cep_cache_dio_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CepCacheCustomDio {
  final _dio = Dio();

  Dio get dio => _dio;

  CepCacheCustomDio() {
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.baseUrl = dotenv.get('CACHEBASEURL');
    _dio.interceptors.add(CepCacheDioInterceptor());
  }
}
