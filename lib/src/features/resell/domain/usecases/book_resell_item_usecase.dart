import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../repositories/resell_repository.dart';

class BookResellItemUsecase {
  final ResellRepository resellRepository;

  BookResellItemUsecase(this.resellRepository);

  Future<Result<void>> call(String id) async {
    return await resellRepository.bookResellItem(id);
  }
}
