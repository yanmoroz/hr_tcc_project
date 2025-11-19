import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/domain.dart';
import '../poll/department_model.dart';
import '../poll/employee_model.dart';
import 'page_model.dart';

part 'poll_detail_model.freezed.dart';
part 'poll_detail_model.g.dart';

@freezed
abstract class PollDetailModel with _$PollDetailModel {
  const factory PollDetailModel({
    required int id,
    required String title,
    String? shortDescription,
    String? description,
    String? emailContent,
    required String cover,
    @JsonKey(fromJson: periodTypeFromJson) PeriodType? periodType,
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
    required List<PageModel> pages,
    List<EmployeeModel>? dublicateResultEmployees,
    List<EmployeeModel>? allowedEmployees,
    List<EmployeeModel>? deniedEmployees,
    List<DepartmentModel>? allowedDepartments,
    List<DepartmentModel>? deniedDepartments,
    List<String>? allowedOrganisations,
    List<String>? deniedOrganisations,
  }) = _PollDetailModel;

  factory PollDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PollDetailModelFromJson(json);
}

extension PollDetailModelX on PollDetailModel {
  PollDetail toDomain() => PollDetail(
    id: id,
    title: title,
    shortDescription: shortDescription,
    description: description,
    emailContent: emailContent,
    cover: cover,
    periodType: periodType,
    periodCount: periodCount,
    pollType: pollType,
    priority: priority,
    isHide: isHide,
    isShowResults: isShowResults,
    isRandomQuestionPosition: isRandomQuestionPosition,
    isRandomAnswerPosition: isRandomAnswerPosition,
    isRandomSeparatorPosition: isRandomSeparatorPosition,
    isAllPageDescription: isAllPageDescription,
    isAllowUserResults: isAllowUserResults,
    isEmailNotify: isEmailNotify,
    isPageChecking: isPageChecking,
    isCategoryPoll: isCategoryPoll,
    isTest: this.isTest,
    testPassMark: testPassMark,
    resultText: resultText,
    resultNegativeText: resultNegativeText,
    pages: pages.map((page) => page.toDomain()).toList(),
    dublicateResultEmployees: dublicateResultEmployees
        ?.map((employee) => employee.toDomain())
        .toList(),
    allowedEmployees: allowedEmployees
        ?.map((employee) => employee.toDomain())
        .toList(),
    deniedEmployees: deniedEmployees
        ?.map((employee) => employee.toDomain())
        .toList(),
    allowedDepartments: allowedDepartments
        ?.map((department) => department.toDomain())
        .toList(),
    deniedDepartments: deniedDepartments
        ?.map((department) => department.toDomain())
        .toList(),
    allowedOrganisations: allowedOrganisations,
    deniedOrganisations: deniedOrganisations,
  );
}
