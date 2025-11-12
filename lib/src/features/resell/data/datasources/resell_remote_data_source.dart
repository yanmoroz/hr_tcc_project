import 'package:hr_tcc_project/src/core/types/result.dart';

import '../models/resell_booking_confirmation_model.dart';
import '../models/resell_booking_model.dart';
import '../models/resell_detail_model.dart';
import '../models/resell_list_response_model.dart';

abstract class ResellRemoteDataSource {
  /// Get paginated list of resell items with filtering
  Future<Result<ResellListResponseModel>> getResellItems({
    required int status,
    String? search,
    required int page,
    required int pageSize,
  });

  /// Get detailed information about a specific resell item
  Future<Result<ResellDetailModel>> getResellDetail(String id);

  /// Initiate booking process for a resell item
  Future<Result<ResellBookingModel>> bookResellItem(String id);

  /// Confirm or cancel booking with additional details
  Future<Result<ResellBookingModel>> confirmBooking({
    required String id,
    required ResellBookingConfirmationModel confirmation,
  });
}
