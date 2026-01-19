import '../../../data/usecases/terms/local_load_terms.dart';
import '../../../data/usecases/terms/remote_load_terms.dart';
import '../../../domain/entities/terms/terms_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/terms/load_terms.dart';

class RemoteLoadTermsWithLocalFallback implements LoadTerms {
  final RemoteLoadTerms remote;
  final LocalLoadTerms local;

  RemoteLoadTermsWithLocalFallback({
    required this.remote,
    required this.local,
  });

  @override
  Future<TermsEntity> load() async {
    try {
      final result = await remote.load();
      await local.save(result);

      return result;
    } catch (error) {
      if (error == DomainError.accessDenied ||
          error == DomainError.expiredSession) {
        rethrow;
      }
      await local.validate();
      return await local.load();
    }
  }
}
