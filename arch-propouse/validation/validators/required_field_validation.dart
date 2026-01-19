import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class RequiredFieldValidation implements FieldValidation {
  @override
  final String field;

  RequiredFieldValidation(this.field);

  @override
  ValidationError? validate(Map input) =>
    input[field]?.isNotEmpty == true ? null : ValidationError.requiredField;
}