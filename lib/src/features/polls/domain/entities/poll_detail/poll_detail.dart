import 'package:freezed_annotation/freezed_annotation.dart';

import '../poll/department.dart';
import '../poll/employee.dart';
import 'page.dart';

part 'poll_detail.freezed.dart';

@freezed
abstract class PollDetail with _$PollDetail {
  const factory PollDetail({
    required int id,
    required String title,
    String? shortDescription,
    String? description,
    String? emailContent,
    required String cover,
    int? periodType,
    required int periodCount,
    required int pollType,
    int? priority,
    required bool isHide,
    required bool isShowResults,
    required bool isRandomQuestionPosition,
    required bool isRandomAnswerPosition,
    required bool isRandomSeparatorPosition,
    required bool isAllPageDescription,
    required bool isAllowUserResults,
    required bool isEmailNotify,
    required bool isPageChecking,
    bool? isCategoryPoll,
    bool? isTest,
    int? testPassMark,
    String? resultText,
    String? resultNegativeText,
    required List<Page> pages,
    List<Employee>? dublicateResultEmployees,
    List<Employee>? allowedEmployees,
    List<Employee>? deniedEmployees,
    List<Department>? allowedDepartments,
    List<Department>? deniedDepartments,
    List<String>? allowedOrganisations,
    List<String>? deniedOrganisations,
  }) = _PollDetail;
}
