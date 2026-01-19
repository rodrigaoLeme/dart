import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class PasswordValidation implements FieldValidation {
  @override
  final String field;
  final int minSize;

  PasswordValidation({
    required this.field,
    this.minSize = 6,
  });

  @override
  ValidationError? validate(Map input) {
    final password = input[field];

    if (password == null || password.length < minSize) {
      return ValidationError.invalidField;
    }

    final regex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+$');
    final isValid = regex.hasMatch(password);

    return isValid ? null : ValidationError.invalidField;
  }
}
