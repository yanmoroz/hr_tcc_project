import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../../repositories/resell_repository.dart';
import '../../params/confirm_resell_booking_params.dart';

class ConfirmResellBookingUsecase {
  final ResellRepository resellRepository;

  ConfirmResellBookingUsecase(this.resellRepository);

  Future<Result<void>> call({
    required ConfirmResellBookingParams params,
  }) async {
    return await resellRepository.confirmBooking(
      id: params.id,
      transition: params.transition,
      inn: params.inn,
      address: params.address,
      employeePlace: params.employeePlace,
      pickupLotMyself: params.pickupLotMyself,
    );
  }
}
