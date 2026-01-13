import 'package:flutter/material.dart';
import 'package:flutter_desafio_via_cep/cache/cep_cache.dart';
import 'package:flutter_desafio_via_cep/cache/exceptions/cache_exception.dart';
import 'package:flutter_desafio_via_cep/exceptions/resource_not_found_exception.dart';
import 'package:flutter_desafio_via_cep/models/cep_model.dart';
import 'package:flutter_desafio_via_cep/models/repositories/cep_repository.dart';
import 'package:flutter_desafio_via_cep/models/services/cep_service.dart';

class CepController extends ChangeNotifier {
  bool loading = false;
  bool error = false;
  String? errorMessage;
  List<CepModel> ceps = [];
  CepModel cepModel = CepModel.empty();

  CepRepository repository =
      CepRepository(cache: CepCache(), service: CepService());

  Future<void> searchCep(String cep) async {
    if (error) {
      error = false;
      errorMessage = null;
      notifyListeners();
    }
    try {
      loading = true;
      cepModel = await repository.searchCep(cep);
      loading = false;
    } on ResourceNotFoundException catch (e) {
      loading = false;
      error = true;
      errorMessage = e.message;
    } on CacheException catch (e) {
      loading = false;
      error = true;
      errorMessage = e.message;
    } on FormatException catch (e) {
      loading = false;
      error = true;
      errorMessage = e.message.toString().substring(16);
    }

    notifyListeners();
  }

  void clearErrorFields() {
    error = false;
    errorMessage = null;
    notifyListeners();
  }

  Future<void> getAll() async {
    try {
      loading = true;
      ceps = await repository.getAll();
      loading = false;
    } on CacheException catch (e) {
      error = true;
      errorMessage = e.message;
    }

    notifyListeners();
  }

  Future<void> update(CepModel cep) async {
    loading = true;

    try {
      await repository.update(cep);
    } on CacheException catch (e) {
      error = true;
      errorMessage = e.message;
    }

    loading = false;
    error = false;
    errorMessage = null;
    notifyListeners();
  }

  Future<void> remove(CepModel cep) async {
    loading = true;

    try {
      await repository.remove(cep.objectId!);
    } on CacheException catch (e) {
      error = true;
      errorMessage = e.message;
    }

    loading = false;
    error = false;
    errorMessage = null;
    notifyListeners();
  }
}
