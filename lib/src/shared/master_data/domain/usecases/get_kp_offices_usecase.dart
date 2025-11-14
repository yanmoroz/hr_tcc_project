import '../../../../core/types/result.dart';

import '../domain.dart';

class GetKpOfficesUsecase {
  final KpOfficeRepository kpOfficeRepository;

  GetKpOfficesUsecase(this.kpOfficeRepository);

  Future<Result<List<KpOffice>>> call() async {
    return await kpOfficeRepository.getKpOffices();
  }
}
