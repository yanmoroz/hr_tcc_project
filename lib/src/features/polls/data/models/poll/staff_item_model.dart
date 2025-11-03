import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'staff_item_model.freezed.dart';
part 'staff_item_model.g.dart';

@freezed
abstract class StaffItemModel with _$StaffItemModel {
  const factory StaffItemModel({required int id, required String title}) = _StaffItemModel;

  factory StaffItemModel.fromJson(Map<String, dynamic> json) => _$StaffItemModelFromJson(json);
}

extension StaffItemModelX on StaffItemModel {
  StaffItem toDomain() => StaffItem(id: id, title: title);
}
