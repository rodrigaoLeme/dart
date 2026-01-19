import '../helpers.dart';

enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
  emailInUse,
  offLineMode,
  invalidEmail,
  invalidPassword,
  codeInvalid,
  notFound,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return R.string.msgRequiredField;
      case UIError.invalidField:
        return R.string.incorrectPassword;
      case UIError.invalidCredentials:
        return R.string.msgInvalidCredentials;
      case UIError.emailInUse:
        return R.string.msgEmailInUse;
      case UIError.offLineMode:
        return R.string.noConnectionsAvailable;
      case UIError.invalidEmail:
        return R.string.msgInvalidField;
      case UIError.invalidPassword:
        return R.string.passwordNotMatch;
      case UIError.codeInvalid:
        return R.string.codeBaseInvalid;
      default:
        return R.string.msgUnexpectedError;
    }
  }
}
