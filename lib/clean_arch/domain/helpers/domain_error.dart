enum DomainError {
  unexpected,
  invalidCredentials,
  emailInUse,
  accountDisabled,
  userNotFound,
  unauthorized,
  accessDenied,
  expiredSession,
  cancelledByUser,
  networkError,
  timeout,
  accountNotLinked,
  accountRequiresRecentLogin,
  providerNotAvailable,
  invalidData,
  syncConflict,
  quotaExceeded,
}

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.unexpected:
        return 'Algo deu errado. Tente novamente.';
      case DomainError.invalidCredentials:
        return 'Credenciais inválidas.';
      case DomainError.emailInUse:
        return 'Este email já está em uso.';
      case DomainError.accountDisabled:
        return 'Conta desabilitada. Entre em contato com o suporte.';
      case DomainError.userNotFound:
        return 'Usuário não encontrado.';
      case DomainError.unauthorized:
        return 'Você precisa estar autenticado.';
      case DomainError.accessDenied:
        return 'Acesso negado.';
      case DomainError.expiredSession:
        return 'Sessão expirada. Faça login novamente.';
      case DomainError.cancelledByUser:
        return 'Operação cancelada.';
      case DomainError.networkError:
        return 'Erro de conexão. Verifique sua internet.';
      case DomainError.timeout:
        return 'Tempo limite excedido. Tente novamente.';
      case DomainError.accountNotLinked:
        return 'Conta não vinculada. Faça login primeiro.';
      case DomainError.accountRequiresRecentLogin:
        return 'Por sergurança, faça login novamente antes de excluir sua conta';
      case DomainError.providerNotAvailable:
        return 'Provedor de login não disponível.';
      case DomainError.invalidData:
        return 'Dados inválidos.';
      case DomainError.syncConflict:
        return 'Conflito ao sincronizar. Tente novamente.';
      case DomainError.quotaExceeded:
        return 'Limite de armazenamento excedido.';
    }
  }
}
