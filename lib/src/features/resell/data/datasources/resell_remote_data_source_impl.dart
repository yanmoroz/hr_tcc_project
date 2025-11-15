import 'package:hr_tcc_project/src/core/network/api_call_executor.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/network/api_constants.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';

import '../../domain/domain.dart';
import '../data.dart';

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
  Future<Result<ResellBookingConfirmModel>> confirmBooking({
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
        return ResellBookingConfirmModel.fromJson(response.data);
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
