import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'news_list_state.freezed.dart';

@freezed
class NewsListState with _$NewsListState {
  const factory NewsListState.initial() = NewsListInitial;
  const factory NewsListState.loading() = NewsListLoading;
  const factory NewsListState.loaded({
    required List<NewsItem> newsItems,
    required int currentPage,
    required bool hasMorePages,
    required bool isLoadingMore,
    @Default({}) Map<int, Uint8List> coverImages,
    int? category,
    String? search,
  }) = NewsListLoaded;
  const factory NewsListState.error(String message) = NewsListError;
}
