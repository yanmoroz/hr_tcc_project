import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_status_notifier.dart';
import '../../../../core/base_types/loading_status.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../blocs/setup_pincode/setup_pincode_bloc.dart';
import '../blocs/setup_pincode/setup_pincode_event.dart';
import '../blocs/setup_pincode/setup_pincode_state.dart';
import '../widgets/numeric_keypad.dart';
import '../widgets/pincode_dots.dart';

class SetupPincodePage extends StatelessWidget {
  const SetupPincodePage({super.key});

  Future<void> _handleBackNavigation() async {
    await sl<LogoutUsecase>().call();
    sl<AuthStatusNotifier>().notifyLoggedOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(),
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

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              await _handleBackNavigation();
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // const SizedBox(height: 56),
                    Text(
                      state.step == SetupPincodeStep.enter
                          ? 'Создайте код доступа'
                          : 'Повторите ПИН-код',
                      style: AppTypography.titleBold2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    Text(
                      state.step == SetupPincodeStep.enter
                          ? 'Войдите в свою учётную запись'
                          : 'Для быстрого входа в приложение',
                      style: AppTypography.textRegular1.black,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: NumericKeypad(
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
                          showDelete: currentPincode.isNotEmpty,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
