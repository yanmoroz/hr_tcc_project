import 'package:hr_tcc_project/src/core/types/result.dart';

import '../domain.dart';

abstract class ResellRepository {
  /// Get paginated list of resell items with filtering
  Future<Result<List<ResellItem>>> getResellItems({
    required ResellStatus status,
    String? search,
    required int page,
    required int pageSize,
  });

  /// Get detailed information about a specific resell item
  Future<Result<ResellDetail>> getResellDetail(String id);

  /// Initiate booking process for a resell item
  Future<Result<void>> bookResellItem(String id);

  /// Confirm or cancel booking with additional details
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
