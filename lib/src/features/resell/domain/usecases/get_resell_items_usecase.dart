import 'package:hr_tcc_project/src/core/types/result.dart';

import '../domain.dart';

class GetResellItemsUsecase {
  final ResellRepository resellRepository;

  GetResellItemsUsecase(this.resellRepository);

  Future<Result<List<ResellItem>>> call({
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
