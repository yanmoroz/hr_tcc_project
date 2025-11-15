import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entities/system_status.dart';
import 'author.dart';
import 'resell_equipment_type.dart';

part 'resell_detail.freezed.dart';

@freezed
abstract class ResellDetail with _$ResellDetail {
  const factory ResellDetail({
    required String id,
    String? generalPhoto,
    List<String>? photo,
    required int price,
    required bool lottery,
    required bool bookingFinish,
    required String name,
    required ResellEquipmentType equipmentType,
    Author? author,
    String? location,
    String? description,
    required DateTime creationDate,
    required SystemStatus status,
    String? bookedUser,
    DateTime? finishDateReservation,
    String? idProcessReservation,
  }) = _ResellDetail;
}
