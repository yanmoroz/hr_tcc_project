import 'package:hr_tcc_project/src/core/types/result.dart';

import '../entities/resell_booking.dart';
import '../entities/resell_booking_confirm.dart';
import '../entities/resell_booking_confirmation.dart';
import '../entities/resell_detail.dart';
import '../entities/resell_item.dart';

abstract class ResellRepository {
  /// Get paginated list of resell items with filtering
  Future<Result<List<ResellItem>>> getResellItems({
    required int status,
    String? search,
    required int page,
    required int pageSize,
  });

  /// Get detailed information about a specific resell item
  Future<Result<ResellDetail>> getResellDetail(String id);

  /// Initiate booking process for a resell item
  Future<Result<ResellBooking>> bookResellItem(String id);

  /// Confirm or cancel booking with additional details
  Future<Result<ResellBookingConfirm>> confirmBooking({
    required String id,
    required ResellBookingConfirmation confirmation,
  });
}
