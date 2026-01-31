import 'package:freezed_annotation/freezed_annotation.dart';

part 'radio_button_item.freezed.dart';

@freezed
abstract class RadioButtonItem<T> with _$RadioButtonItem<T> {
  const factory RadioButtonItem({
    required T value,
    required String label,
    @Default(true) bool enabled,
  }) = _RadioButtonItem<T>;
}
