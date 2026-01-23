import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/usecases/setup_pincode_usecase.dart';
import 'setup_pincode_event.dart';
import 'setup_pincode_state.dart';

class SetupPincodeBloc extends Bloc<SetupPincodeEvent, SetupPincodeState> {
  final SetupPincodeUsecase _setupPincodeUsecase;
  static const _pincodeLength = 4;

  SetupPincodeBloc({required SetupPincodeUsecase setupPincodeUsecase})
    : _setupPincodeUsecase = setupPincodeUsecase,
      super(const SetupPincodeState()) {
    on<DigitEntered>(_onDigitEntered);
    on<DigitDeleted>(_onDigitDeleted);
    on<PincodeEntered>(_onPincodeEntered);
    on<PincodeConfirmed>(_onPincodeConfirmed);
    on<Reset>(_onReset);
  }

  void _onDigitEntered(DigitEntered event, Emitter<SetupPincodeState> emit) {
    final currentPincode = state.step == SetupPincodeStep.enter
        ? state.enteredPincode
        : state.confirmedPincode;

    if (currentPincode.length >= _pincodeLength) return;

    final newPincode = currentPincode + event.digit;

    if (state.step == SetupPincodeStep.enter) {
      emit(state.copyWith(enteredPincode: newPincode, errorMessage: null));

      if (newPincode.length == _pincodeLength) {
        add(const PincodeEntered());
      }
    } else {
      emit(state.copyWith(confirmedPincode: newPincode, errorMessage: null));

      if (newPincode.length == _pincodeLength) {
        add(const PincodeConfirmed());
      }
    }
  }

  void _onDigitDeleted(DigitDeleted event, Emitter<SetupPincodeState> emit) {
    if (state.step == SetupPincodeStep.enter) {
      if (state.enteredPincode.isEmpty) return;
      emit(
        state.copyWith(
          enteredPincode: state.enteredPincode.substring(
            0,
            state.enteredPincode.length - 1,
          ),
        ),
      );
    } else {
      if (state.confirmedPincode.isEmpty) return;
      emit(
        state.copyWith(
          confirmedPincode: state.confirmedPincode.substring(
            0,
            state.confirmedPincode.length - 1,
          ),
        ),
      );
    }
  }

  void _onPincodeEntered(
    PincodeEntered event,
    Emitter<SetupPincodeState> emit,
  ) {
    if (state.enteredPincode.length != _pincodeLength) return;

    emit(state.copyWith(step: SetupPincodeStep.confirm, confirmedPincode: ''));
  }

  Future<void> _onPincodeConfirmed(
    PincodeConfirmed event,
    Emitter<SetupPincodeState> emit,
  ) async {
    if (state.confirmedPincode.length != _pincodeLength) return;

    if (state.enteredPincode != state.confirmedPincode) {
      emit(
        state.copyWith(errorMessage: 'Код не совпадает', confirmedPincode: ''),
      );
      return;
    }

    emit(state.copyWith(status: LoadingStatus.loading));

    final result = await _setupPincodeUsecase(state.enteredPincode);

    result.fold(
      (error) => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: error.toString(),
        ),
      ),
      (_) {
        emit(state.copyWith(status: LoadingStatus.success, isComplete: true));
      },
    );
  }

  void _onReset(Reset event, Emitter<SetupPincodeState> emit) {
    emit(const SetupPincodeState());
  }
}
