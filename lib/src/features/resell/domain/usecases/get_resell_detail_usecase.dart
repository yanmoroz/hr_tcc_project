import 'package:hr_tcc_project/src/core/types/result.dart';

import '../domain.dart';

class GetResellDetailUsecase {
  final ResellRepository resellRepository;

  GetResellDetailUsecase(this.resellRepository);

  Future<Result<ResellDetail>> call(String id) async {
    return await resellRepository.getResellDetail(id);
  }
}
