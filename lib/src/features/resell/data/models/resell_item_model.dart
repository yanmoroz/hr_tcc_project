import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/master_data/models/system_status_model.dart';
import '../../domain/domain.dart';
import 'author_model.dart';
import 'resell_equipment_type_model.dart';

part 'resell_item_model.freezed.dart';
part 'resell_item_model.g.dart';

@freezed
abstract class ResellItemModel with _$ResellItemModel {
  const ResellItemModel._();

  const factory ResellItemModel({
    required String id,
    String? generalPhoto,
    required int price,
    required bool lottery,
    required bool bookingFinish,
    required String shortName,
    required ResellEquipmentTypeModel equipmentType,
    AuthorModel? author,
    required DateTime creationDate,
    required SystemStatusModel status,
    String? bookedUser,
    DateTime? finishDateReservation,
    String? idProcessReservation,
  }) = _ResellItemModel;

  factory ResellItemModel.fromJson(Map<String, dynamic> json) =>
      _$ResellItemModelFromJson(json);

  ResellItem toDomain() => ResellItem(
    id: id,
    generalPhoto: generalPhoto,
    price: price,
    lottery: lottery,
    bookingFinish: bookingFinish,
    shortName: shortName,
    equipmentType: equipmentType.toDomain(),
    author: author?.toDomain(),
    creationDate: creationDate,
    status: status.toDomain(),
    bookedUser: bookedUser,
    finishDateReservation: finishDateReservation,
    idProcessReservation: idProcessReservation,
  );
}
