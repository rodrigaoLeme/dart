import 'package:dio/dio.dart';
import 'package:flutter_desafio_via_cep/exceptions/resource_not_found_exception.dart';
import 'package:flutter_desafio_via_cep/utils/constants/methods.dart';

class CepService {
  final dio = Dio();

  Future<Map<String, dynamic>> get(String cep) async {
    final result = await dio.get('https://viacep.com.br/ws/$cep/json/');

    if (result.data['erro'] == true) throw const ResourceNotFoundException();

    return convertToMap2(result.data);
  }
}
