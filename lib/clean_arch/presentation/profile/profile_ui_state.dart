import '../../domain/entities/auth/auth.dart';

enum ProfileUIStatus {
  initial,
  loading,
  loaded,
  linking,
  deleting,
  error,
}

class ProfileUIState {
  final ProfileUIStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final String? linkinProvider;

  const ProfileUIState({
    required this.status,
    this.user,
    this.errorMessage,
    this.linkinProvider,
  });

  const ProfileUIState.initial()
      : status = ProfileUIStatus.initial,
        user = null,
        errorMessage = null,
        linkinProvider = null;

  const ProfileUIState.loading({UserEntity? userL})
      : status = ProfileUIStatus.loading,
        user = userL,
        errorMessage = null,
        linkinProvider = null;

  const ProfileUIState.loaded(this.user)
      : status = ProfileUIStatus.loaded,
        errorMessage = null,
        linkinProvider = null;

  const ProfileUIState.linking(this.linkinProvider, this.user)
      : status = ProfileUIStatus.linking,
        errorMessage = null;

  const ProfileUIState.deleting(this.user)
      : status = ProfileUIStatus.deleting,
        errorMessage = null,
        linkinProvider = null;

  const ProfileUIState.error(this.errorMessage, {this.user})
      : status = ProfileUIStatus.error,
        linkinProvider = null;

  bool get isLoading => status == ProfileUIStatus.loading;
  bool get isLoaded => status == ProfileUIStatus.loaded;
  bool get isLinking => status == ProfileUIStatus.linking;
  bool get isDeleting => status == ProfileUIStatus.deleting;
  bool get hasError => status == ProfileUIStatus.error;

  bool get isAnonymous => user?.isAnonymous ?? false;
  bool get isAuthenticated => user != null && !isAnonymous;

  bool isProviderLinking(String provider) {
    return isLinking && linkinProvider == provider;
  }

  ProfileUIState copyWith({
    ProfileUIStatus? status,
    UserEntity? user,
    String? errorMessage,
    String? linkinProvider,
  }) {
    return ProfileUIState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      linkinProvider: linkinProvider ?? this.linkinProvider,
    );
  }
}
