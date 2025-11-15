import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../../domain/domain.dart';
import '../data.dart';

abstract class ResellRemoteDataSource {
  /// Get paginated list of resell items with filtering
  Future<Result<ResellListResponseModel>> getResellItems({
    required ResellStatus status,
    String? search,
    required int page,
    required int pageSize,
  });

  /// Get detailed information about a specific resell item
  Future<Result<ResellDetailModel>> getResellDetail(String id);

  /// Initiate booking process for a resell item
  Future<Result<void>> bookResellItem(String id);

  /// Confirm or cancel booking with additional details
  Future<Result<ResellBookingConfirmModel>> confirmBooking({
    required String id,
    required BookingTransition transition,
    String? inn,
    String? address,
    String? employeePlace,
    bool? pickupLotMyself,
  });

  Future<Result<List<ResellEquipmentTypeModel>>> getResellEquipmentTypes();
}
