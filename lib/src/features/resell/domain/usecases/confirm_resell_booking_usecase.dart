import 'package:hr_tcc_project/src/core/types/result.dart';

import '../entities/resell_booking_confirm.dart';
import '../entities/resell_booking_confirmation.dart';
import '../repositories/resell_repository.dart';

class ConfirmResellBookingUsecase {
  final ResellRepository resellRepository;

  ConfirmResellBookingUsecase(this.resellRepository);

  Future<Result<ResellBookingConfirm>> call({
    required String id,
    required ResellBookingConfirmation confirmation,
  }) async {
    return await resellRepository.confirmBooking(id: id, confirmation: confirmation);
  }
}
