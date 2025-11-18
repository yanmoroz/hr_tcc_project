import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats_response_model.freezed.dart';
part 'stats_response_model.g.dart';

@freezed
abstract class StatsResponseModel with _$StatsResponseModel {
  const factory StatsResponseModel({required int likeCount, required bool like, required int commentCount}) = _StatsResponseModel;

  factory StatsResponseModel.fromJson(Map<String, dynamic> json) => _$StatsResponseModelFromJson(json);
}
