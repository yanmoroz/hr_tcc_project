import 'package:freezed_annotation/freezed_annotation.dart';

part 'discount_source.freezed.dart';

@freezed
abstract class DiscountSource with _$DiscountSource {
  const factory DiscountSource({required int code, required String name}) =
      _DiscountSource;
}
