import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';

part 'setup_pincode_state.freezed.dart';

enum SetupPincodeStep { enter, confirm }

@freezed
sealed class SetupPincodeState with _$SetupPincodeState {
  const factory SetupPincodeState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(SetupPincodeStep.enter) SetupPincodeStep step,
    @Default('') String enteredPincode,
    @Default('') String confirmedPincode,
    String? errorMessage,
    @Default(false) bool isComplete,
  }) = _SetupPincodeState;
}
