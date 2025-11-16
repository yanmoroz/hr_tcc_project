import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/domain.dart';
import 'attachment_model.dart';
import 'author_model.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
abstract class CommentModel with _$CommentModel {
  const factory CommentModel({
    int? parent,
    required int id,
    required String content,
    required DateTime createdData,
    required AuthorModel author,
    List<AttachmentModel>? attachments,
    required bool editable,
    int? likeCount,
    bool? like,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}

extension CommentModelX on CommentModel {
  Comment toDomain() => Comment(
    parent: parent,
    id: id,
    content: content,
    createdData: createdData,
    author: author.toDomain(),
    attachments: attachments?.map((a) => a.toDomain()).toList(),
    editable: editable,
    likeCount: likeCount,
    like: like,
  );
}
