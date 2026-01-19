import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class MaxLengthValidation implements FieldValidation {
  @override
  final String field;
  final int size;

  MaxLengthValidation({
    required this.field,
    required this.size,
  });

  @override
  ValidationError? validate(Map input) =>
      input[field] != null && input[field].length <= size
          ? null
          : ValidationError.invalidField;
}
