import '../../../../core/base_types/result.dart';
import '../../domain/domain.dart';
import '../models/responses/resell_detail_model.dart';
import '../models/responses/resell_equipment_type_model.dart';
import '../models/responses/resell_list_response_model.dart';

abstract class ResellRemoteDataSource {
  Future<Result<void>> bookResellItem(String id);

  Future<Result<void>> confirmBooking({
    required String id,
    required BookingTransition transition,
    String? inn,
    String? address,
    String? employeePlace,
    bool? pickupLotMyself,
  });

  Future<Result<ResellDetailModel>> getResellDetail(String id);

  Future<Result<List<ResellEquipmentTypeModel>>> getResellEquipmentTypes();

  Future<Result<ResellListResponseModel>> getResellItems({
    required ResellStatus status,
    String? search,
    required int page,
    required int pageSize,
  });
}
