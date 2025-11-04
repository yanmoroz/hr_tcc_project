import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_stats.freezed.dart';

/// News statistics entity (like and comment counts)
@freezed
abstract class NewsStats with _$NewsStats {
  const factory NewsStats({
    required int likeCount,
    required bool like,
    required int commentCount,
  }) = _NewsStats;
}
