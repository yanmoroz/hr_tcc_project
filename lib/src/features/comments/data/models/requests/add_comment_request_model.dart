import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_comment_request_model.freezed.dart';
part 'add_comment_request_model.g.dart';

@freezed
abstract class AddCommentRequestModel with _$AddCommentRequestModel {
  const factory AddCommentRequestModel({
    int? parent,
    required String content,
    List<int>? attachments,
  }) = _AddCommentRequestModel;

  factory AddCommentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddCommentRequestModelFromJson(json);
}
