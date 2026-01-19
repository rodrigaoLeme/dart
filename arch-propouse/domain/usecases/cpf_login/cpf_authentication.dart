abstract class CpfAuthentication {
  Future<void> auth(CpfAuthenticationParams params);
}

class CpfAuthenticationParams {
  final String document;
  final String birthday;
  final String email;

  CpfAuthenticationParams({
    required this.document,
    required this.birthday,
    required this.email,
  });

  Map toJson() => {
        'document': document,
        'birthday': birthday,
        'email': email,
      };
}
