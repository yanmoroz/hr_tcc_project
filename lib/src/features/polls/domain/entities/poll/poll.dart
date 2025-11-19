import 'package:freezed_annotation/freezed_annotation.dart';

import '../../value_objects/period_type.dart';
import 'employee.dart';

part 'poll.freezed.dart';

@freezed
abstract class Poll with _$Poll {
  const factory Poll({
    required int id,
    required String title,
    required String shortDescription,
    String? description,
    String? cover,
    required int countAnswers,
    PeriodType? periodType,
    required bool isHide,
    required bool isShowResults,
    DateTime? lastAnswerCreatedAt,
    Employee? lastAnswerEmployee,
    DateTime? lastAnswerCurrentUserCreatedAt,
    required int periodCount,
    required bool canAnswer,
    required bool isNew,
    required DateTime createdAt,
  }) = _Poll;
}
