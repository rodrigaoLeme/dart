class AccountTokenEntity {
  final String accessToken;
  final String refreshToken;
  final String? photoUrl;

  AccountTokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.photoUrl,
  });

  AccountTokenEntity copyWith({
    String? accessToken,
    String? refreshToken,
    String? photoUrl,
  }) {
    return AccountTokenEntity(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
