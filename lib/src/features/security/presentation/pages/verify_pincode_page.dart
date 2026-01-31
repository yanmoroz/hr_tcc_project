import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/theme/theme.dart';
import '../blocs/verify_pincode/verify_pincode_bloc.dart';
import '../blocs/verify_pincode/verify_pincode_event.dart';
import '../blocs/verify_pincode/verify_pincode_state.dart';
import '../widgets/numeric_keypad.dart';
import '../widgets/pincode_dots.dart';

class VerifyPincodePage extends StatelessWidget {
  const VerifyPincodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(),
      body: BlocConsumer<VerifyPincodeBloc, VerifyPincodeState>(
        listener: (context, state) {
          if (state.isVerified) {
            context.go('/home');
          }
        },
        builder: (context, state) {
          final showBiometrics =
              state.isBiometricsAvailable && state.isBiometricsEnabled;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    'Введите код доступа',
                    style: AppTypography.titleBold2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  if (state.attempts > 0)
                    Text(
                      'Осталось попыток: ${state.maxAttempts - state.attempts}',
                      style: AppTypography.textRegular2.copyWith(
                        color: AppColors.red500,
                      ),
                      textAlign: TextAlign.center,
                    )
                  else
                    Text(
                      'Для доступа к приложению',
                      style: AppTypography.textRegular1.black,
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 48),

                  PincodeDots(
                    filledCount: state.enteredPincode.length,
                    hasError: state.errorMessage != null,
                  ),

                  if (state.status == LoadingStatus.loading) ...[
                    const SizedBox(height: 48),
                    const CircularProgressIndicator(),
                  ] else if (state.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage!,
                      style: AppTypography.textRegular2.copyWith(
                        color: AppColors.red500,
                      ),
                    ),
                  ],

                  const Spacer(flex: 1),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: NumericKeypad(
                      showBiometrics: showBiometrics,
                      showDelete: state.enteredPincode.isNotEmpty,
                      showPasswordLogin: true,
                      onDigitPressed: (digit) {
                        context.read<VerifyPincodeBloc>().add(
                          VerifyPincodeEvent.digitEntered(digit),
                        );
                      },
                      onDeletePressed: () {
                        context.read<VerifyPincodeBloc>().add(
                          const VerifyPincodeEvent.digitDeleted(),
                        );
                      },
                      onBiometricsPressed: showBiometrics
                          ? () {
                              context.read<VerifyPincodeBloc>().add(
                                const VerifyPincodeEvent.authenticateWithBiometrics(),
                              );
                            }
                          : null,
                      onPasswordLoginPressed: () {
                        context.read<VerifyPincodeBloc>().add(
                          const VerifyPincodeEvent.passwordLoginRequested(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
