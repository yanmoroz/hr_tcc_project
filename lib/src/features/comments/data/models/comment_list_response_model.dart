import 'package:freezed_annotation/freezed_annotation.dart';

import 'comment_model.dart';

part 'comment_list_response_model.freezed.dart';
part 'comment_list_response_model.g.dart';

@freezed
abstract class CommentListResponseModel with _$CommentListResponseModel {
  const factory CommentListResponseModel({required List<CommentModel> comments}) =
      _CommentListResponseModel;

  factory CommentListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CommentListResponseModelFromJson(json);
}
