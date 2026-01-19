import 'dart:convert';
import 'dart:developer' as developer;

import 'package:localstorage/localstorage.dart';

import '../../data/cache/cache.dart';

class LocalStorageAdapter implements CacheStorage {
  final LocalStorage localStorage;

  LocalStorageAdapter({required this.localStorage});

  @override
  Future<void> save({required String key, required dynamic value}) async {
    developer.log(
        '=======================================================================',
        name: 'START');
    developer.log(key, name: 'KEY');

    developer.log('save', name: 'METHOD');
    developer.log(value.toString(), name: 'DATA');

    localStorage.removeItem(key);
    final json = jsonEncode(value);
    localStorage.setItem(key, json);
    developer.log(
        '=========================================================================',
        name: 'END');
  }

  @override
  Future<void> delete(String key) async {
    developer.log(
        '=======================================================================',
        name: 'START');
    developer.log(key, name: 'KEY');

    developer.log('delete', name: 'METHOD');
    localStorage.removeItem(key);
    developer.log(
        '=========================================================================',
        name: 'END');
  }

  @override
  Future<dynamic> fetch(String key) async {
    developer.log(
        '=======================================================================',
        name: 'START');
    developer.log(key, name: 'KEY');

    developer.log('fetch', name: 'METHOD');
    final data = localStorage.getItem(key);
    developer.log(data.toString(), name: 'DATA');
    developer.log(
        '=========================================================================',
        name: 'END');
    return jsonDecode(data ?? '');
  }

  @override
  Future<void> clear() async {
    localStorage.clear();
  }
}
