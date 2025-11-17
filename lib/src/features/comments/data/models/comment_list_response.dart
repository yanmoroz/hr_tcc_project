import 'package:freezed_annotation/freezed_annotation.dart';

import 'comment_model.dart';

part 'comment_list_response.freezed.dart';
part 'comment_list_response.g.dart';

@freezed
abstract class CommentListResponse with _$CommentListResponse {
  const factory CommentListResponse({required List<CommentModel> comments}) =
      _CommentListResponse;

  factory CommentListResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentListResponseFromJson(json);
}
