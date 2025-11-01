import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_item.freezed.dart';

@freezed
abstract class StaffItem with _$StaffItem {
  const factory StaffItem({required int id, required String title}) = _StaffItem;
}
