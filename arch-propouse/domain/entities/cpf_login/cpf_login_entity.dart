class CpfLoginEntity {
  final String email;
  final String document;
  final String birthday;

  CpfLoginEntity({
    required this.email,
    required this.document,
    required this.birthday,
  });

  CpfLoginEntity copyWith({
    String? email,
    String? document,
    String? birthday,
  }) {
    return CpfLoginEntity(
      email: email ?? this.email,
      document: document ?? this.document,
      birthday: birthday ?? this.birthday,
    );
  }
}
