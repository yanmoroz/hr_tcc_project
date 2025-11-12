import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_tcc_project/src/features/resell/domain/domain.dart';
import 'package:hr_tcc_project/src/shared/master_data/data/data.dart';

import 'author_model.dart';

part 'resell_detail_model.freezed.dart';
part 'resell_detail_model.g.dart';

@freezed
abstract class ResellDetailModel with _$ResellDetailModel {
  const ResellDetailModel._();

  const factory ResellDetailModel({
    required String id,
    String? generalPhoto,
    List<String>? photo,
    required int price,
    required bool lottery,
    required bool bookingFinish,
    required String name,
    @JsonKey(name: 'equipmentType') required ResellEquipmentTypeModel equipmentTypeModel,
    @JsonKey(name: 'author') required AuthorModel authorModel,
    String? location,
    String? description,
    required DateTime creationDate,
    @JsonKey(name: 'status') required SystemStatusModel statusModel,
    String? bookedUser,
    DateTime? finishDateReservation,
    String? idProcessReservation,
  }) = _ResellDetailModel;

  factory ResellDetailModel.fromJson(Map<String, dynamic> json) => _$ResellDetailModelFromJson(json);

  ResellDetail toDomain() => ResellDetail(
    id: id,
    generalPhoto: generalPhoto,
    photo: photo,
    price: price,
    lottery: lottery,
    bookingFinish: bookingFinish,
    name: name,
    equipmentType: equipmentTypeModel.toDomain(),
    author: authorModel.toDomain(),
    location: location,
    description: description,
    creationDate: creationDate,
    status: statusModel.toDomain(),
    bookedUser: bookedUser,
    finishDateReservation: finishDateReservation,
    idProcessReservation: idProcessReservation,
  );
}
