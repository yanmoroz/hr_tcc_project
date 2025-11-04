import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats_response.freezed.dart';
part 'stats_response.g.dart';

@freezed
abstract class StatsResponse with _$StatsResponse {
  const factory StatsResponse({required int likeCount, required bool like, required int commentCount}) = _StatsResponse;

  factory StatsResponse.fromJson(Map<String, dynamic> json) => _$StatsResponseFromJson(json);
}
