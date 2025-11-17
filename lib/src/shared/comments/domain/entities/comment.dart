import 'package:freezed_annotation/freezed_annotation.dart';

import 'attachment.dart';
import 'author.dart';

part 'comment.freezed.dart';

@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    int? parent,
    required int id,
    required String content,
    required DateTime createdData,
    required Author author,
    List<Attachment>? attachments,
    required bool editable,
    int? likeCount,
    bool? like,
  }) = _Comment;
}
