import 'package:freezed_annotation/freezed_annotation.dart';

part 'kp_news_category.freezed.dart';

@freezed
abstract class KpNewsCategory with _$KpNewsCategory {
  const factory KpNewsCategory({required int code, required String name}) =
      _KpNewsCategory;
}
