import 'package:freezed_annotation/freezed_annotation.dart';

import 'department.dart';

part 'author.freezed.dart';

@freezed
abstract class Author with _$Author {
  const factory Author({
    required String firstName,
    required String lastName,
    required String middleName,
    Department? department,
    required String organisation,
    required bool isArchive,
    required int vacationDaysLeft,
    required bool isVaccinated,
    String? photo,
    required int id,
    required String title,
    String? position,
    String? status,
  }) = _Author;
}
