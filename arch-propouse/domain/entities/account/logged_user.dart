// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoggedUser {
  final String name;
  final String id;
  final String email;
  final String googleIdentityId;
  final String urlPhoto;
  final String peopleId;
  final String localPathPhoto;
  final String? token;
  final bool emailVerified;
  final List<ProviderLogin?> providers;
  final String naturalPersonId;
  final String firebaseUid;
  final String msAccessToken;
  final String document;
  final String birthday;

  const LoggedUser({
    this.name = '',
    this.id = '',
    this.email = '',
    this.googleIdentityId = '',
    this.urlPhoto = '',
    this.peopleId = '',
    this.localPathPhoto = '',
    this.token,
    this.emailVerified = false,
    this.providers = const [],
    this.naturalPersonId = '',
    this.firebaseUid = '',
    this.msAccessToken = '',
    this.document = '',
    this.birthday = '',
  });

  bool get hasPeopleValid => googleIdentityId.isNotEmpty && peopleId.isNotEmpty;
  bool get hasUserValid => googleIdentityId.isNotEmpty && peopleId.isEmpty;

  LoggedUser copyWith({
    String? name,
    String? id,
    String? email,
    String? googleIdentityId,
    String? urlPhoto,
    String? peopleId,
    String? localPathPhoto,
    String? token,
    bool? emailVerified,
    List<ProviderLogin>? providers,
    String? naturalPersonId,
    String? firebaseUid,
    String? msAccessToken,
    String? document,
    String? birthday,
  }) {
    return LoggedUser(
      name: name ?? this.name,
      id: id ?? this.id,
      email: email ?? this.email,
      googleIdentityId: googleIdentityId ?? this.googleIdentityId,
      urlPhoto: urlPhoto ?? this.urlPhoto,
      peopleId: peopleId ?? this.peopleId,
      localPathPhoto: localPathPhoto ?? this.localPathPhoto,
      token: token ?? this.token,
      emailVerified: emailVerified ?? this.emailVerified,
      providers: providers ?? this.providers,
      naturalPersonId: naturalPersonId ?? this.naturalPersonId,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      msAccessToken: msAccessToken ?? this.msAccessToken,
      document: document ?? this.document,
      birthday: birthday ?? this.birthday,
    );
  }
}

enum ProviderLogin { google, microsoft, apple }

Map<ProviderLogin, String> _nameProviderLogin = {};
Map<ProviderLogin, String> _emailProviderLogin = {};

extension ProviderLoginExtension on ProviderLogin {
  String get name => _nameProviderLogin[this] as String;
  set name(String value) => _nameProviderLogin[this] = value;

  String get email => _emailProviderLogin[this] as String;
  set email(String value) => _emailProviderLogin[this] = value;
}
