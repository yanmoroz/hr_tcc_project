import 'package:hr_tcc_project/src/core/types/result.dart';

import '../../domain.dart';

class ConfirmResellBookingUsecase {
  final ResellRepository resellRepository;

  ConfirmResellBookingUsecase(this.resellRepository);

  Future<Result<void>> call({
    required ConfirmResellBookingUsecaseParams params,
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
