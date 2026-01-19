import '../../presentation/protocols/validation.dart';
import '../protocols/field_validation.dart';

class LinkedInValidation implements FieldValidation {
  @override
  final String field;

  LinkedInValidation(this.field);

  @override
  ValidationError? validate(Map input) {
    final regex = RegExp(r'^(https?:\/\/)?(www\.)?linkedin\.com\/.*$');
    final isValid =
        input[field]?.isNotEmpty != true || regex.hasMatch(input[field]);
    return isValid ? null : ValidationError.invalidField;
  }
}
