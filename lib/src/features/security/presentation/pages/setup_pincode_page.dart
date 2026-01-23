import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/theme/theme.dart';
import '../blocs/setup_pincode/setup_pincode_bloc.dart';
import '../blocs/setup_pincode/setup_pincode_event.dart';
import '../blocs/setup_pincode/setup_pincode_state.dart';
import '../widgets/numeric_keypad.dart';
import '../widgets/pincode_dots.dart';

class SetupPincodePage extends StatelessWidget {
  const SetupPincodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<SetupPincodeBloc, SetupPincodeState>(
        listener: (context, state) {
          if (state.isComplete) {
            context.go('/security/setup-biometrics');
          }
        },
        builder: (context, state) {
          final currentPincode = state.step == SetupPincodeStep.enter
              ? state.enteredPincode
              : state.confirmedPincode;

          return SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                Text(
                  state.step == SetupPincodeStep.enter
                      ? 'Создайте пин-код'
                      : 'Подтвердите пин-код',
                  style: AppTypography.titleBold1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  state.step == SetupPincodeStep.enter
                      ? 'Введите 4-значный пин-код'
                      : 'Введите пин-код повторно',
                  style: AppTypography.textRegular1.grey700,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                PincodeDots(
                  filledCount: currentPincode.length,
                  hasError: state.errorMessage != null,
                ),

                if (state.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage!,
                    style: AppTypography.textRegular2.copyWith(
                      color: AppColors.red500,
                    ),
                  ),
                ],

                const Spacer(flex: 1),

                if (state.status == LoadingStatus.loading)
                  const CircularProgressIndicator()
                else
                  NumericKeypad(
                    onDigitPressed: (digit) {
                      context.read<SetupPincodeBloc>().add(
                        SetupPincodeEvent.digitEntered(digit),
                      );
                    },
                    onDeletePressed: () {
                      context.read<SetupPincodeBloc>().add(
                        const SetupPincodeEvent.digitDeleted(),
                      );
                    },
                  ),

                const SizedBox(height: 48),
              ],
            ),
          );
        },
      ),
    );
  }
}
