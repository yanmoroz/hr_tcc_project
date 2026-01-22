import '../../../../core/base_types/result.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenUsecase {
  final AuthRepository _repository;

  RefreshTokenUsecase(this._repository);

  Future<Result<AuthTokens>> call(String refreshToken) {
    return _repository.refreshToken(refreshToken);
  }
}
