import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_tcc_project/src/features/resell/domain/domain.dart';
import 'package:hr_tcc_project/src/shared/master_data/data/data.dart';

import 'author_model.dart';

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
    @JsonKey(name: 'equipmentType') required ResellEquipmentTypeModel equipmentTypeModel,
    @JsonKey(name: 'author') AuthorModel? authorModel,
    required DateTime creationDate,
    @JsonKey(name: 'status') required SystemStatusModel statusModel,
    String? bookedUser,
    DateTime? finishDateReservation,
    String? idProcessReservation,
  }) = _ResellItemModel;

  factory ResellItemModel.fromJson(Map<String, dynamic> json) => _$ResellItemModelFromJson(json);

  ResellItem toDomain() => ResellItem(
    id: id,
    generalPhoto: generalPhoto,
    price: price,
    lottery: lottery,
    bookingFinish: bookingFinish,
    shortName: shortName,
    equipmentType: equipmentTypeModel.toDomain(),
    author: authorModel?.toDomain(),
    creationDate: creationDate,
    status: statusModel.toDomain(),
    bookedUser: bookedUser,
    finishDateReservation: finishDateReservation,
    idProcessReservation: idProcessReservation,
  );
}
