import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetKpOfficesUsecase {
  final KpOfficeRepository kpOfficeRepository;

  GetKpOfficesUsecase(this.kpOfficeRepository);

  Future<Either<NetworkException, List<KpOffice>>> call() async {
    return await kpOfficeRepository.getKpOffices();
  }
}
