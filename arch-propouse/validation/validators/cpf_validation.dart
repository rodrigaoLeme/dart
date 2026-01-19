import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class CPFValidation implements FieldValidation {
  @override
  final String field;

  CPFValidation(this.field);

  @override
  ValidationError? validate(Map input) {
    final regex = RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$');
    final isValid =
        input[field]?.isNotEmpty != true || regex.hasMatch(input[field]);

    return isValid ? null : ValidationError.invalidField;
  }
}
