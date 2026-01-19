import '../../../domain/entities/terms/terms_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/terms/load_terms.dart';
import '../../cache/cache.dart';
import '../../models/terms/terms_model.dart';

class LocalLoadTerms implements LoadTerms {
  final CacheStorage cacheStorage;

  LocalLoadTerms({required this.cacheStorage});

  @override
  Future<TermsEntity> load() async {
    try {
      final data = await cacheStorage.fetch(SecureStorageKey.terms);
      if (data?.isEmpty != false) {
        throw DomainError.unexpected;
      }
      return TermsModel.fromJson(data).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    try {
      final data = await cacheStorage.fetch(SecureStorageKey.terms);
      TermsModel.fromJson(data).toEntity();
    } catch (error) {
      await cacheStorage.delete(SecureStorageKey.resources);
    }
  }

  Future<void> save(TermsEntity data) async {
    try {
      final json = TermsModel.fromEntity(data).toJson();
      await cacheStorage.save(
        key: SecureStorageKey.terms,
        value: json,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
