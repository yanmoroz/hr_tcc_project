import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_author.freezed.dart';

@freezed
abstract class CommentAuthor with _$CommentAuthor {
  const factory CommentAuthor({
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
  }) = _CommentAuthor;
}
