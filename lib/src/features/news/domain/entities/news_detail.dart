import 'package:freezed_annotation/freezed_annotation.dart';
import 'author.dart';

part 'news_detail.freezed.dart';

/// News detail entity with full content
@freezed
abstract class NewsDetail with _$NewsDetail {
  const factory NewsDetail({
    required int id,
    required String title,
    required String content,
    required DateTime createdData,
    required Author author,
    String? image,
  }) = _NewsDetail;
}