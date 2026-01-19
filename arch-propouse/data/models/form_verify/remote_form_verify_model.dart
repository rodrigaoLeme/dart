import 'dart:convert';

import '../../../domain/entities/form_verify/form_verify_entity.dart';
import '../../http/http.dart';

class RemoteFormVerifyModel {
  final List<QuestionsModel>? data;
  final List<String>? errors;
  final bool? success;

  RemoteFormVerifyModel({
    required this.data,
    required this.errors,
    required this.success,
  });

  factory RemoteFormVerifyModel.fromJson(Map json) {
    if (!json.containsKey('data')) {
      throw HttpError.invalidData;
    }
    return RemoteFormVerifyModel(
      data: json['data']
          .map<QuestionsModel>((dataJson) => QuestionsModel.fromJson(dataJson))
          .toList(),
      errors: (json['errors'] as List?)?.map((e) => e.toString()).toList(),
      success: json['success'],
    );
  }

  factory RemoteFormVerifyModel.fromEntity(FormVerifyEntity entity) {
    return RemoteFormVerifyModel(
      data: entity.data?.map((e) => QuestionsModel.fromEntity(e)).toList(),
      errors: entity.errors,
      success: entity.success,
    );
  }

  factory RemoteFormVerifyModel.fromStringfy(String string) {
    return RemoteFormVerifyModel.fromJson(jsonDecode(string));
  }

  FormVerifyEntity toEntity() => FormVerifyEntity(
        data: data?.map<QuestionsEntity>((data) => data.toEntity()).toList(),
        errors: errors,
        success: success,
      );

  Map toJson() => {
        'data': data?.map((e) => e.toJson()).toList(),
        'errors': errors,
        'success': success,
      };
}

class QuestionsModel {
  final String? questionId;
  final String? questionText;
  final String? answer;
  final String? response;

  QuestionsModel({
    required this.questionId,
    required this.questionText,
    required this.answer,
    required this.response,
  });

  factory QuestionsModel.fromJson(Map json) => QuestionsModel(
        questionId: json['questionId'],
        questionText: json['questionText'],
        answer: json['answer'],
        response: json['response'],
      );

  factory QuestionsModel.fromEntity(QuestionsEntity entity) => QuestionsModel(
        questionId: entity.questionId,
        questionText: entity.questionText,
        answer: entity.answer,
        response: entity.response,
      );

  QuestionsEntity toEntity() => QuestionsEntity(
        questionId: questionId,
        questionText: questionText,
        answer: answer,
        response: response,
      );

  Map toJson() => {
        'questionId': questionId,
        'questionText': questionText,
        'answer': answer,
        'response': response
      };
}
