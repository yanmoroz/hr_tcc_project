import '../../../../core/base_types/result.dart';
import '../repositories/security_repository.dart';

class VerifyPincodeUsecase {
  final SecurityRepository _repository;

  VerifyPincodeUsecase(this._repository);

  Future<Result<bool>> call(String pincode) {
    return _repository.verifyPincode(pincode);
  }
}
