import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_item.freezed.dart';

@freezed
abstract class FilterItem<T> with _$FilterItem<T> {
  const factory FilterItem({
    required T? value,
    required String label,
    int? count,
  }) = _FilterItem<T>;
}
