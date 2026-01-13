import '../utils/constants/api.dart';
import '../utils/constants/methods.dart';
import '../utils/network/custom_dio/cep_cache_custom_dio.dart';
import 'exceptions/cache_exception.dart';

class CepCache {
  final custom = CepCacheCustomDio();

  Future<void> save(Map<String, dynamic> data) async {
    try {
      await custom.dio.post(url, data: data);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    try {
      final result = await custom.dio.get(url);
      final list = result.data['results'] as List;
      return list.map((e) => convertToMap(e)).toList();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> get(String cep) async {
    try {
      final formattedCep = formatCep(cep);
      final filter = '$url?where={"cep":"$formattedCep"}';
      final result = await custom.dio.get(filter);

      final data = result.data['results'] as List;

      if (data.isEmpty) return hasErrorAsMap();

      return convertToMap(data[0]);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  Future<void> remove(String id) async {
    try {
      await custom.dio.delete('$url/$id');
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> json) async {
    try {
      await custom.dio.put('$url/$id', data: json);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
