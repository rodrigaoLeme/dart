import 'package:flutter_desafio_via_cep/cache/cep_cache.dart';
import 'package:flutter_desafio_via_cep/exceptions/resource_not_found_exception.dart';
import 'package:flutter_desafio_via_cep/models/cep_model.dart';
import 'package:flutter_desafio_via_cep/models/services/cep_service.dart';
import 'package:flutter_desafio_via_cep/utils/constants/methods.dart';

class CepRepository {
  final CepCache cache;
  final CepService service;

  const CepRepository({required this.cache, required this.service});

  Future<CepModel> searchCep(String cep) async {
    try {
      final cepFromCache = await cache.get(cep);

      if (!cepExists(cepFromCache)) {
        final cepFromApi = await service.get(cep);
        await cache.save(cepFromApi);
        return CepModel.fromJson(cepFromApi);
      }

      return CepModel.fromJson(cepFromCache);
    } on ResourceNotFoundException {
      rethrow;
    }
  }

  Future<List<CepModel>> getAll() async {
    final ceps = await cache.getAll();
    return ceps.map((cep) => CepModel.fromJson(cep)).toList();
  }

  Future<void> update(CepModel cep) async {
    await cache.update(cep.objectId!, cep.toJson());
  }

  Future<void> remove(String cepId) async {
    await cache.remove(cepId);
  }
}
