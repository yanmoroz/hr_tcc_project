import 'package:fpdart/fpdart.dart';

import '../../../../core/auth/auth_token_provider.dart';
import '../../../../core/base_types/result.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthTokenProvider _tokenProvider;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthTokenProvider tokenProvider,
  }) : _remoteDataSource = remoteDataSource,
       _tokenProvider = tokenProvider;

  @override
  Future<Result<AuthTokens>> login({
    required String username,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      username: username,
      password: password,
    );

    return result.match((error) => Left(error), (model) async {
      final tokens = model.toDomain();
      // Store tokens immediately after successful login
      await _tokenProvider.setToken(tokens.accessToken);
      await _tokenProvider.setRefreshToken(tokens.refreshToken);
      return Right(tokens);
    });
  }

  @override
  Future<Result<Unit>> logout() async {
    await _tokenProvider.clearToken();
    return const Right(unit);
  }

  @override
  Future<Result<AuthTokens>> refreshToken(String refreshToken) async {
    final result = await _remoteDataSource.refreshToken(refreshToken);

    return result.match((error) => Left(error), (model) async {
      final tokens = model.toDomain();
      // Update stored tokens after successful refresh
      await _tokenProvider.setToken(tokens.accessToken);
      await _tokenProvider.setRefreshToken(tokens.refreshToken);
      return Right(tokens);
    });
  }
}
