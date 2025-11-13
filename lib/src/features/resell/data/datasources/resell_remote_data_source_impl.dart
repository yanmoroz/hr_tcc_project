import 'package:hr_tcc_project/src/core/network/api_call_executor.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/network/api_constants.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';

import '../models/resell_booking_confirmation_model.dart';
import '../models/resell_booking_confirm_model.dart';
import '../models/resell_booking_model.dart';
import '../models/resell_detail_model.dart';
import '../models/resell_list_response_model.dart';
import 'resell_remote_data_source.dart';

class ResellRemoteDataSourceImpl implements ResellRemoteDataSource {
  final ApiClient _apiClient;

  ResellRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<ResellListResponseModel>> getResellItems({
    required int status,
    String? search,
    required int page,
    required int pageSize,
  }) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(
        ApiConstants.resellListEndpoint,
        queryParameters: {'status': status, if (search != null) 'search': search, 'page': page, 'pageSize': pageSize},
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
  Future<Result<ResellBookingModel>> bookResellItem(String id) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.post(ApiConstants.resellBookingEndpoint(id)),
      successParser: (response) {
        return ResellBookingModel.fromJson(response.data);
      },
    );
  }

  @override
  Future<Result<ResellBookingConfirmModel>> confirmBooking({
    required String id,
    required ResellBookingConfirmationModel confirmation,
  }) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.post(ApiConstants.resellConfirmBookingEndpoint(id), data: confirmation.toJson()),
      successParser: (response) {
        return ResellBookingConfirmModel.fromJson(response.data);
      },
    );
  }
}
