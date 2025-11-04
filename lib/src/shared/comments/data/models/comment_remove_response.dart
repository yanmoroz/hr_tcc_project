import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_remove_response.freezed.dart';
part 'comment_remove_response.g.dart';

@freezed
abstract class CommentRemoveResponse with _$CommentRemoveResponse {
  const factory CommentRemoveResponse({required List<int> removedIds}) = _CommentRemoveResponse;

  factory CommentRemoveResponse.fromJson(Map<String, dynamic> json) => _$CommentRemoveResponseFromJson(json);
}