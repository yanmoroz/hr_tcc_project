import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_list_event.freezed.dart';

@freezed
class NewsListEvent with _$NewsListEvent {
  const factory NewsListEvent.loadNews({int? category, String? search}) = LoadNews;

  const factory NewsListEvent.refreshNews({int? category, String? search}) = RefreshNews;

  const factory NewsListEvent.loadMoreNews() = LoadMoreNews;
}
