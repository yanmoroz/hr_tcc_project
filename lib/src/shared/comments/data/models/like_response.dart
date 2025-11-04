import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_response.freezed.dart';
part 'like_response.g.dart';

@freezed
abstract class LikeResponse with _$LikeResponse {
  const factory LikeResponse({required bool like}) = _LikeResponse;

  factory LikeResponse.fromJson(Map<String, dynamic> json) => _$LikeResponseFromJson(json);
}