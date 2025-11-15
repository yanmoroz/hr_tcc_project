import '../../../../core/types/result.dart';
import '../domain.dart';

class GetResellEquipmentTypesUsecase {
  final ResellRepository resellRepository;

  GetResellEquipmentTypesUsecase(this.resellRepository);

  Future<Result<List<ResellEquipmentType>>> call() async {
    return await resellRepository.getResellEquipmentTypes();
  }
}
