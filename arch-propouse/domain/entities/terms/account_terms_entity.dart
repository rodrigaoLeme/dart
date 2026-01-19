class AccountTermsEntity {
  final bool success;
  final String key;
  final String message;
  final TermsDataEntity data;
  final int statusCode;

  AccountTermsEntity({
    required this.success,
    required this.key,
    required this.message,
    required this.data,
    required this.statusCode,
  });
}

class TermsDataEntity {
  int id;
  String htmlContent;
  int version;

  TermsDataEntity({
    required this.id,
    required this.htmlContent,
    required this.version,
  });
}
