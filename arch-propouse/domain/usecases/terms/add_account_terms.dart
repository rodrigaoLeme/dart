abstract class AddAccountTerms {
  Future<void> add(AddAccountTermsParams params);
}

class AddAccountTermsParams {
  final int version;

  AddAccountTermsParams({required this.version});
}
