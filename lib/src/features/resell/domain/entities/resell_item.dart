import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/entities/system_status.dart';
import 'author.dart';
import 'resell_equipment_type.dart';

part 'resell_item.freezed.dart';

@freezed
abstract class ResellItem with _$ResellItem {
  const factory ResellItem({
    required String id,
    String? generalPhoto,
    required int price,
    required bool lottery,
    required bool bookingFinish,
    required String shortName,
    required ResellEquipmentType equipmentType,
    Author? author,
    required DateTime creationDate,
    required SystemStatus status,
    String? bookedUser,
    DateTime? finishDateReservation,
    String? idProcessReservation,
  }) = _ResellItem;
}
