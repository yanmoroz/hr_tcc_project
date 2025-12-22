import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../repositories/resell_repository.dart';
import '../value_objects/resell_status.dart';

class GetResellItemsUsecase {
  final ResellRepository resellRepository;

  GetResellItemsUsecase(this.resellRepository);

  Future<Result<ResellItemsResult>> call({
    required ResellStatus status,
    String? search,
    required int page,
    required int pageSize,
  }) async {
    return await resellRepository.getResellItems(
      status: status,
      search: search,
      page: page,
      pageSize: pageSize,
    );
  }
}
