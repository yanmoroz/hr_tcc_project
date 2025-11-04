import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/domain.dart';

part 'news_stats_model.freezed.dart';
part 'news_stats_model.g.dart';

@freezed
abstract class NewsStatsModel with _$NewsStatsModel {
  const factory NewsStatsModel({
    required int likeCount,
    required bool like,
    required int commentCount,
  }) = _NewsStatsModel;

  factory NewsStatsModel.fromJson(Map<String, dynamic> json) => _$NewsStatsModelFromJson(json);
}

extension NewsStatsModelX on NewsStatsModel {
  NewsStats toDomain() => NewsStats(
        likeCount: likeCount,
        like: like,
        commentCount: commentCount,
      );
}