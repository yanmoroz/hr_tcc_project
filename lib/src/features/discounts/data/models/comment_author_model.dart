import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/domain.dart';

part 'comment_author_model.freezed.dart';
part 'comment_author_model.g.dart';

@freezed
abstract class CommentAuthorModel with _$CommentAuthorModel {
  const factory CommentAuthorModel({
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
  }) = _CommentAuthorModel;

  factory CommentAuthorModel.fromJson(Map<String, dynamic> json) => _$CommentAuthorModelFromJson(json);
}

extension CommentAuthorModelX on CommentAuthorModel {
  CommentAuthor toDomain() => CommentAuthor(
    firstName: firstName,
    lastName: lastName,
    middleName: middleName,
    position: position,
    organisation: organisation,
    isArchive: isArchive,
    vacationDaysLeft: vacationDaysLeft,
    status: status,
    photo: photo,
    id: id,
    title: title,
  );
}
