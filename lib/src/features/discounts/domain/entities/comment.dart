import 'package:freezed_annotation/freezed_annotation.dart';
import 'attachment.dart';
import 'comment_author.dart';

part 'comment.freezed.dart';

@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    int? parent,
    required int id,
    required String content,
    required DateTime createdData,
    required CommentAuthor author,
    List<Attachment>? attachments,
    required bool editable,
    int? likeCount,
    bool? like,
  }) = _Comment;
}
