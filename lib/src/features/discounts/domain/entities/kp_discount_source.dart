import 'package:freezed_annotation/freezed_annotation.dart';

part 'kp_discount_source.freezed.dart';

@freezed
abstract class KpDiscountSource with _$KpDiscountSource {
  const factory KpDiscountSource({required int code, required String name}) =
      _KpDiscountSource;
}
