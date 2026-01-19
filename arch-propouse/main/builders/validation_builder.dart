import '../../validation/protocols/protocols.dart';
import '../../validation/validators/numeric_validation.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  static ValidationBuilder? _instance;
  String fieldName;
  List<FieldValidation> validations = [];

  ValidationBuilder._(this.fieldName);

  List<FieldValidation> build() => validations;

  ValidationBuilder email() {
    validations.add(EmailValidation(fieldName));
    return this;
  }

  ValidationBuilder linkedin() {
    validations.add(LinkedInValidation(fieldName));
    return this;
  }

  ValidationBuilder max(int size) {
    validations.add(MaxLengthValidation(field: fieldName, size: size));
    return this;
  }

  ValidationBuilder min(int size) {
    validations.add(MinLengthValidation(field: fieldName, size: size));
    return this;
  }

  ValidationBuilder password() {
    validations.add(PasswordValidation(field: fieldName));
    return this;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(fieldName));
    return this;
  }

  ValidationBuilder sameAs(String fieldToCompare) {
    validations.add(
      CompareFieldsValidation(
        field: fieldName,
        fieldToCompare: fieldToCompare,
      ),
    );
    return this;
  }

  ValidationBuilder numeric() {
    validations.add(NumericValidation(fieldName));
    return this;
  }

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder._(fieldName);
    return _instance!;
  }
}
