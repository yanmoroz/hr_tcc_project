import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../entities/resell_detail.dart';
import '../entities/resell_equipment_type.dart';
import '../entities/resell_item.dart';
import '../value_objects/booking_transition.dart';
import '../value_objects/resell_status.dart';

typedef ResellItemsResult = ({List<ResellItem> items, int total});

abstract class ResellRepository {
  Future<Result<ResellItemsResult>> getResellItems({
    required ResellStatus status,
    String? search,
    required int page,
    required int pageSize,
  });

  Future<Result<ResellDetail>> getResellDetail(String id);

  Future<Result<void>> bookResellItem(String id);

  Future<Result<void>> confirmBooking({
    required String id,
    required BookingTransition transition,
    String? inn,
    String? address,
    String? employeePlace,
    bool? pickupLotMyself,
  });

  Future<Result<List<ResellEquipmentType>>> getResellEquipmentTypes();
}
