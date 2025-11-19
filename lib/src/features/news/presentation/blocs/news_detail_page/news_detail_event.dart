import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_detail_event.freezed.dart';

@freezed
class NewsDetailEvent with _$NewsDetailEvent {
  const factory NewsDetailEvent.loadDetail() = LoadDetail;
  const factory NewsDetailEvent.toggleLike() = ToggleLike;
  const factory NewsDetailEvent.refresh() = RefreshDetail;
}
