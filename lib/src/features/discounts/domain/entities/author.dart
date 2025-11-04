import 'package:freezed_annotation/freezed_annotation.dart';
import 'department.dart';

part 'author.freezed.dart';

@freezed
abstract class Author with _$Author {
  const factory Author({
    List<String>? workplaces,
    String? email,
    String? phoneMain,
    String? phoneAdd,
    String? phoneMob,
    String? phonePers,
    String? sip,
    required String firstName,
    required String lastName,
    String? patronymic,
    String? position,
    Department? department,
    String? organisation,
    bool? archive,
    int? vacationDaysLeft,
    bool? isVaccinated,
    String? status,
    required String photo,
    required int id,
    required String title,
  }) = _Author;
}
