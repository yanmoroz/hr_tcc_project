import '../../../../core/base_types/result.dart';
import '../../../../core/network/api_call_executor.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../domain/domain.dart';
import '../models/responses/resell_detail_model.dart';
import '../models/responses/resell_equipment_type_model.dart';
import '../models/responses/resell_list_response_model.dart';
import 'resell_remote_data_source.dart';

class ResellRemoteDataSourceImpl implements ResellRemoteDataSource {
  final ApiClient _apiClient;

  ResellRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<ResellListResponseModel>> getResellItems({
    required ResellStatus status,
    String? search,
    required int page,
    required int pageSize,
  }) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(
        ApiConstants.resellListEndpoint,
        queryParameters: {
          'status': status.value,
          if (search != null) 'search': search,
          'page': page,
          'pageSize': pageSize,
        },
      ),
      successParser: (response) {
        return ResellListResponseModel.fromJson(response.data);
      },
    );
  }

  @override
  Future<Result<ResellDetailModel>> getResellDetail(String id) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.resellDetailEndpoint(id)),
      successParser: (response) {
        return ResellDetailModel.fromJson(response.data);
      },
    );
  }

  @override
  Future<Result<void>> bookResellItem(String id) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.post(ApiConstants.resellBookingEndpoint(id)),
      successParser: (response) {
        return null;
      },
    );
  }

  @override
  Future<Result<void>> confirmBooking({
    required String id,
    required BookingTransition transition,
    String? inn,
    String? address,
    String? employeePlace,
    bool? pickupLotMyself,
  }) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.post(
        ApiConstants.resellConfirmBookingEndpoint(id),
        data: {
          'transition': transition.value,
          if (inn != null) 'inn': inn,
          if (address != null) 'address': address,
          if (employeePlace != null) 'employeePlace': employeePlace,
          if (pickupLotMyself != null) 'pickupLotMyself': pickupLotMyself,
        },
      ),
      successParser: (response) {
        return null;
      },
    );
  }

  @override
  Future<Result<List<ResellEquipmentTypeModel>>>
  getResellEquipmentTypes() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.resellEquipmentTypeEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final equipmentTypesJson = data['equipmentTypes'] as List<dynamic>;
        return equipmentTypesJson
            .map(
              (json) => ResellEquipmentTypeModel.fromJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList();
      },
    );
  }
}
