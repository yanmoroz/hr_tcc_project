import '../../../../core/base_types/result.dart';
import '../../domain/domain.dart';
import '../models/resell_detail_model.dart';
import '../models/resell_equipment_type_model.dart';
import '../models/resell_list_response_model.dart';

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
  Future<Result<void>> confirmBooking({
    required String id,
    required BookingTransition transition,
    String? inn,
    String? address,
    String? employeePlace,
    bool? pickupLotMyself,
  });

  Future<Result<List<ResellEquipmentTypeModel>>> getResellEquipmentTypes();
}
