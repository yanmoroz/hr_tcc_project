import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_box_item.freezed.dart';

@freezed
abstract class CheckBoxItem<T> with _$CheckBoxItem<T> {
  const factory CheckBoxItem({
    required T value,
    required String label,
    @Default(true) bool enabled,
  }) = _CheckBoxItem<T>;
}
