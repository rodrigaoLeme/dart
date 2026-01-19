import 'package:dio/dio.dart';

import '../../../data/http/http.dart';
import '../../../infra/http/http.dart';

AdraHttpClient makeDioAdapter() => DioAdapter(Dio());
