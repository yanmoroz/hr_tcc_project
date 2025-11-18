import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_remove_response_model.freezed.dart';
part 'comment_remove_response_model.g.dart';

@freezed
abstract class CommentRemoveResponseModel with _$CommentRemoveResponseModel {
  const factory CommentRemoveResponseModel({required List<int> removedIds}) =
      _CommentRemoveResponseModel;

  factory CommentRemoveResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CommentRemoveResponseModelFromJson(json);
}
