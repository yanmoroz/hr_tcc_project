import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';
import 'employee_model.dart';

part 'poll_model.freezed.dart';
part 'poll_model.g.dart';

@freezed
abstract class PollModel with _$PollModel {
  const factory PollModel({
    required int id,
    required String title,
    required String shortDescription,
    String? description,
    String? cover,
    required int countAnswers,
    @JsonKey(fromJson: periodTypeFromJson) PeriodType? periodType,
    required bool isHide,
    required bool isShowResults,
    @JsonKey(name: 'lastAnswerCreatedAt') DateTime? lastAnswerCreatedAt,
    @JsonKey(name: 'lastAnswerEmployee') EmployeeModel? lastAnswerEmployee,
    @JsonKey(name: 'lastAnswerCurrentUserCreatedAt') DateTime? lastAnswerCurrentUserCreatedAt,
    required int periodCount,
    required bool canAnswer,
    required bool isNew,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
  }) = _PollModel;

  factory PollModel.fromJson(Map<String, dynamic> json) => _$PollModelFromJson(json);
}

extension PollModelX on PollModel {
  Poll toDomain() => Poll(
    id: id,
    title: title,
    shortDescription: shortDescription,
    description: description,
    cover: cover,
    countAnswers: countAnswers,
    periodType: periodType,
    isHide: isHide,
    isShowResults: isShowResults,
    lastAnswerCreatedAt: lastAnswerCreatedAt,
    lastAnswerEmployee: lastAnswerEmployee?.toDomain(),
    lastAnswerCurrentUserCreatedAt: lastAnswerCurrentUserCreatedAt,
    periodCount: periodCount,
    canAnswer: canAnswer,
    isNew: isNew,
    createdAt: createdAt,
  );
}
