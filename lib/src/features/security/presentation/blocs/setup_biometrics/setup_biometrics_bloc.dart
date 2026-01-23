import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/auth/auth_status_notifier.dart';
import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/entities/security_settings.dart';
import '../../../domain/usecases/authenticate_with_biometrics_usecase.dart';
import '../../../domain/usecases/check_biometrics_availability_usecase.dart';
import '../../../domain/usecases/enable_biometrics_usecase.dart';
import 'setup_biometrics_event.dart';
import 'setup_biometrics_state.dart';

class SetupBiometricsBloc
    extends Bloc<SetupBiometricsEvent, SetupBiometricsState> {
  final CheckBiometricsAvailabilityUsecase _checkBiometricsAvailabilityUsecase;
  final EnableBiometricsUsecase _enableBiometricsUsecase;
  final AuthenticateWithBiometricsUsecase _authenticateWithBiometricsUsecase;
  final AuthStatusNotifier _authStatusNotifier;

  SetupBiometricsBloc({
    required CheckBiometricsAvailabilityUsecase
        checkBiometricsAvailabilityUsecase,
    required EnableBiometricsUsecase enableBiometricsUsecase,
    required AuthenticateWithBiometricsUsecase authenticateWithBiometricsUsecase,
    required AuthStatusNotifier authStatusNotifier,
  })  : _checkBiometricsAvailabilityUsecase = checkBiometricsAvailabilityUsecase,
        _enableBiometricsUsecase = enableBiometricsUsecase,
        _authenticateWithBiometricsUsecase = authenticateWithBiometricsUsecase,
        _authStatusNotifier = authStatusNotifier,
        super(const SetupBiometricsState()) {
    on<CheckAvailability>(_onCheckAvailability);
    on<EnableBiometrics>(_onEnableBiometrics);
    on<Skip>(_onSkip);
  }

  Future<void> _onCheckAvailability(
    CheckAvailability event,
    Emitter<SetupBiometricsState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final result = await _checkBiometricsAvailabilityUsecase();

    result.fold(
      (error) => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: error.toString(),
          availableType: BiometricsType.none,
        ),
      ),
      (biometricsType) {
        if (biometricsType == BiometricsType.none) {
          emit(state.copyWith(status: LoadingStatus.success, isSkipped: true));
          _authStatusNotifier.notifyBiometricsSetupComplete();
        } else {
          emit(
            state.copyWith(
              status: LoadingStatus.success,
              availableType: biometricsType,
            ),
          );
        }
      },
    );
  }

  Future<void> _onEnableBiometrics(
    EnableBiometrics event,
    Emitter<SetupBiometricsState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final authResult = await _authenticateWithBiometricsUsecase();

    await authResult.fold(
      (error) async {
        emit(
          state.copyWith(
            status: LoadingStatus.error,
            errorMessage: 'Не удалось выполнить биометрическую аутентификацию',
          ),
        );
      },
      (isAuthenticated) async {
        if (!isAuthenticated) {
          emit(
            state.copyWith(
              status: LoadingStatus.error,
              errorMessage: 'Биометрическая аутентификация не пройдена',
            ),
          );
          return;
        }

        final enableResult = await _enableBiometricsUsecase(true);

        enableResult.fold(
          (error) => emit(
            state.copyWith(
              status: LoadingStatus.error,
              errorMessage: error.toString(),
            ),
          ),
          (_) {
            emit(state.copyWith(status: LoadingStatus.success, isEnabled: true));
            _authStatusNotifier.notifyBiometricsSetupComplete();
          },
        );
      },
    );
  }

  void _onSkip(Skip event, Emitter<SetupBiometricsState> emit) {
    emit(state.copyWith(isSkipped: true));
    _authStatusNotifier.notifyBiometricsSetupComplete();
  }
}
