import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class CompareFieldsValidation implements FieldValidation {
  @override
  final String field;
  final String fieldToCompare;

  CompareFieldsValidation({ required this.field, required this.fieldToCompare});

  @override
  ValidationError? validate(Map input) =>
    input[field] != null
    && input[fieldToCompare] != null
    && input[field] != input[fieldToCompare]
      ? ValidationError.invalidField
      : null;
}