import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/auth/auth_status_notifier.dart';
import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/entities/security_settings.dart';
import '../../../domain/usecases/authenticate_with_biometrics_usecase.dart';
import '../../../domain/usecases/check_biometrics_availability_usecase.dart';
import '../../../domain/usecases/get_security_settings_usecase.dart';
import '../../../domain/usecases/verify_pincode_usecase.dart';
import 'verify_pincode_event.dart';
import 'verify_pincode_state.dart';

class VerifyPincodeBloc extends Bloc<VerifyPincodeEvent, VerifyPincodeState> {
  final VerifyPincodeUsecase _verifyPincodeUsecase;
  final AuthenticateWithBiometricsUsecase _authenticateWithBiometricsUsecase;
  final GetSecuritySettingsUsecase _getSecuritySettingsUsecase;
  final CheckBiometricsAvailabilityUsecase _checkBiometricsAvailabilityUsecase;
  final AuthStatusNotifier _authStatusNotifier;
  static const _pincodeLength = 4;

  VerifyPincodeBloc({
    required VerifyPincodeUsecase verifyPincodeUsecase,
    required AuthenticateWithBiometricsUsecase authenticateWithBiometricsUsecase,
    required GetSecuritySettingsUsecase getSecuritySettingsUsecase,
    required CheckBiometricsAvailabilityUsecase checkBiometricsAvailabilityUsecase,
    required AuthStatusNotifier authStatusNotifier,
  })  : _verifyPincodeUsecase = verifyPincodeUsecase,
        _authenticateWithBiometricsUsecase = authenticateWithBiometricsUsecase,
        _getSecuritySettingsUsecase = getSecuritySettingsUsecase,
        _checkBiometricsAvailabilityUsecase = checkBiometricsAvailabilityUsecase,
        _authStatusNotifier = authStatusNotifier,
        super(const VerifyPincodeState()) {
    on<VerifyDigitEntered>(_onDigitEntered);
    on<VerifyDigitDeleted>(_onDigitDeleted);
    on<Verify>(_onVerify);
    on<CheckBiometrics>(_onCheckBiometrics);
    on<AuthenticateWithBiometrics>(_onAuthenticateWithBiometrics);
    on<VerifyReset>(_onReset);
  }

  Future<void> _onCheckBiometrics(
    CheckBiometrics event,
    Emitter<VerifyPincodeState> emit,
  ) async {
    final settingsResult = await _getSecuritySettingsUsecase();
    final availabilityResult = await _checkBiometricsAvailabilityUsecase();

    settingsResult.fold(
      (error) {},
      (settings) {
        availabilityResult.fold(
          (error) {},
          (biometricsType) {
            final isAvailable = biometricsType != BiometricsType.none;
            emit(
              state.copyWith(
                isBiometricsAvailable: isAvailable,
                isBiometricsEnabled: settings.isBiometricsEnabled,
                biometricsType: biometricsType,
              ),
            );

            if (isAvailable && settings.isBiometricsEnabled) {
              add(const AuthenticateWithBiometrics());
            }
          },
        );
      },
    );
  }

  void _onDigitEntered(
    VerifyDigitEntered event,
    Emitter<VerifyPincodeState> emit,
  ) {
    if (state.enteredPincode.length >= _pincodeLength) return;

    final newPincode = state.enteredPincode + event.digit;
    emit(state.copyWith(enteredPincode: newPincode, errorMessage: null));

    if (newPincode.length == _pincodeLength) {
      add(const Verify());
    }
  }

  void _onDigitDeleted(
    VerifyDigitDeleted event,
    Emitter<VerifyPincodeState> emit,
  ) {
    if (state.enteredPincode.isEmpty) return;
    emit(
      state.copyWith(
        enteredPincode: state.enteredPincode.substring(
          0,
          state.enteredPincode.length - 1,
        ),
      ),
    );
  }

  Future<void> _onVerify(
    Verify event,
    Emitter<VerifyPincodeState> emit,
  ) async {
    if (state.enteredPincode.length != _pincodeLength) return;

    emit(state.copyWith(status: LoadingStatus.loading));

    final result = await _verifyPincodeUsecase(state.enteredPincode);

    result.fold(
      (error) => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: error.toString(),
          enteredPincode: '',
        ),
      ),
      (isValid) {
        if (isValid) {
          emit(state.copyWith(status: LoadingStatus.success, isVerified: true));
          _authStatusNotifier.notifyUnlocked();
        } else {
          final newAttempts = state.attempts + 1;
          emit(
            state.copyWith(
              status: LoadingStatus.error,
              errorMessage: 'Неверный пин-код',
              enteredPincode: '',
              attempts: newAttempts,
            ),
          );

          if (newAttempts >= state.maxAttempts) {
            _authStatusNotifier.notifyLoggedOut();
          }
        }
      },
    );
  }

  Future<void> _onAuthenticateWithBiometrics(
    AuthenticateWithBiometrics event,
    Emitter<VerifyPincodeState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final result = await _authenticateWithBiometricsUsecase();

    result.fold(
      (error) => emit(
        state.copyWith(status: LoadingStatus.initial, errorMessage: null),
      ),
      (isAuthenticated) {
        if (isAuthenticated) {
          emit(state.copyWith(status: LoadingStatus.success, isVerified: true));
          _authStatusNotifier.notifyUnlocked();
        } else {
          emit(state.copyWith(status: LoadingStatus.initial));
        }
      },
    );
  }

  void _onReset(VerifyReset event, Emitter<VerifyPincodeState> emit) {
    emit(const VerifyPincodeState());
  }
}
