import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

part 'news_list_state.freezed.dart';

@freezed
sealed class NewsListState with _$NewsListState {
  const factory NewsListState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<NewsItem> newsItems,
    @Default(0) int currentPage,
    @Default(true) bool hasMorePages,
    @Default(false) bool isLoadingMore,
    @Default({}) Map<int, Uint8List> coverImages,
    int? category,
    String? search,
    String? errorMessage,
  }) = _NewsListState;
}
