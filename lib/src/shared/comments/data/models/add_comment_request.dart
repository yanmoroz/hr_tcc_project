import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_comment_request.freezed.dart';
part 'add_comment_request.g.dart';

@freezed
abstract class AddCommentRequest with _$AddCommentRequest {
  const factory AddCommentRequest({
    int? parent,
    required String content,
    List<int>? attachments,
  }) = _AddCommentRequest;

  factory AddCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$AddCommentRequestFromJson(json);

  Map<String, dynamic> toJson() => {
    if (parent != null) 'parent': parent,
    'content': content,
    if (attachments != null) 'attachments': attachments,
  };
}
