import 'answer_form_view_model.dart';

abstract class AnswerFormState {
  const AnswerFormState();
}

class AnswerFormLoading extends AnswerFormState {
  const AnswerFormLoading();
}

class AnswerFormData extends AnswerFormState {
  final AnswerFormViewModel viewModel;
  const AnswerFormData({required this.viewModel});
}

class AnswerFormError extends AnswerFormState {
  final Object error;
  const AnswerFormError(this.error);
}
