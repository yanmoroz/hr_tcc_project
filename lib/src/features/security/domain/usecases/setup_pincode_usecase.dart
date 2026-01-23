import 'package:fpdart/fpdart.dart';

import '../../../../core/base_types/result.dart';
import '../repositories/security_repository.dart';

class SetupPincodeUsecase {
  final SecurityRepository _repository;

  SetupPincodeUsecase(this._repository);

  Future<Result<Unit>> call(String pincode) {
    return _repository.setupPincode(pincode);
  }
}
