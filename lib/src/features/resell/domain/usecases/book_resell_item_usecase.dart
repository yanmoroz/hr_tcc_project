import 'package:hr_tcc_project/src/core/types/result.dart';

import '../entities/resell_booking.dart';
import '../repositories/resell_repository.dart';

class BookResellItemUsecase {
  final ResellRepository resellRepository;

  BookResellItemUsecase(this.resellRepository);

  Future<Result<ResellBooking>> call(String id) async {
    return await resellRepository.bookResellItem(id);
  }
}
