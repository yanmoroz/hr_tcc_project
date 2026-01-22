import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/auth/auth_token_provider.dart';
import '../../../../core/base_types/loading_status.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;
  final AuthTokenProvider _tokenProvider;

  AuthBloc({
    required LoginUsecase loginUsecase,
    required LogoutUsecase logoutUsecase,
    required AuthTokenProvider tokenProvider,
  })  : _loginUsecase = loginUsecase,
        _logoutUsecase = logoutUsecase,
        _tokenProvider = tokenProvider,
        super(const AuthState()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final result = await _loginUsecase(
      username: event.username,
      password: event.password,
    );

    result.fold(
      (error) => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: error.toString(),
          isAuthenticated: false,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: LoadingStatus.success,
          isAuthenticated: true,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final result = await _logoutUsecase();

    result.fold(
      (error) => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: error.toString(),
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: LoadingStatus.success,
          isAuthenticated: false,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final hasToken = await _tokenProvider.hasToken();
    emit(
      state.copyWith(
        isAuthenticated: hasToken,
        status: hasToken ? LoadingStatus.success : LoadingStatus.initial,
      ),
    );
  }
}
