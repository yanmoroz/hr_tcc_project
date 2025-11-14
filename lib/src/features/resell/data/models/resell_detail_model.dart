import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/data/models/resell_equipment_type_model.dart';
import '../../../../core/data/models/system_status_model.dart';
import '../../domain/domain.dart';
import '../data.dart';

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
    required ResellEquipmentTypeModel equipmentType,
    AuthorModel? author,
    String? location,
    String? description,
    required DateTime creationDate,
    required SystemStatusModel status,
    String? bookedUser,
    DateTime? finishDateReservation,
    String? idProcessReservation,
  }) = _ResellDetailModel;

  factory ResellDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ResellDetailModelFromJson(json);

  ResellDetail toDomain() => ResellDetail(
    id: id,
    generalPhoto: generalPhoto,
    photo: photo,
    price: price,
    lottery: lottery,
    bookingFinish: bookingFinish,
    name: name,
    equipmentType: equipmentType.toDomain(),
    author: author?.toDomain(),
    location: location,
    description: description,
    creationDate: creationDate,
    status: status.toDomain(),
    bookedUser: bookedUser,
    finishDateReservation: finishDateReservation,
    idProcessReservation: idProcessReservation,
  );
}
