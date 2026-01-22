import 'package:fpdart/fpdart.dart';

import '../../../../core/base_types/result.dart';
import '../repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository _repository;

  LogoutUsecase(this._repository);

  Future<Result<Unit>> call() {
    return _repository.logout();
  }
}
