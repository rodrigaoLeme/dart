import '../../presentation/protocols/validation.dart';
import '../../validation/protocols/protocols.dart';

class NumericValidation implements FieldValidation {
  @override
  final String field;

  NumericValidation(this.field);

  @override
  ValidationError? validate(Map input) {
    final value = input[field];

    if (value == null || value.toString().isEmpty) {
      return null;
    }

    if (!_isValidDouble(value.toString())) {
      return ValidationError.invalidField;
    }

    return null; // Campo válido.
  }

  bool _isValidDouble(String input) {
    return double.tryParse(input) != null;
  }
}
