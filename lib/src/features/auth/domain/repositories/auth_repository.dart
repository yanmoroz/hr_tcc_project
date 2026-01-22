import 'package:fpdart/fpdart.dart';

import '../../../../core/base_types/result.dart';
import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  Future<Result<AuthTokens>> login({
    required String username,
    required String password,
  });

  Future<Result<Unit>> logout();

  Future<Result<AuthTokens>> refreshToken(String refreshToken);
}
