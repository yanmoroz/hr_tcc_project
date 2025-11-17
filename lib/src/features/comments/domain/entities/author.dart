import 'package:freezed_annotation/freezed_annotation.dart';

part 'author.freezed.dart';

@freezed
abstract class Author with _$Author {
  const factory Author({
    required String firstName,
    String? lastName,
    String? middleName,
    String? position,
    String? organisation,
    required bool isArchive,
    required int vacationDaysLeft,
    String? status,
    required String photo,
    required int id,
    required String title,
  }) = _Author;
}
