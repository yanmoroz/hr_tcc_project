import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/base_types/loading_status.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/security_settings.dart';
import '../blocs/setup_biometrics/setup_biometrics_bloc.dart';
import '../blocs/setup_biometrics/setup_biometrics_event.dart';
import '../blocs/setup_biometrics/setup_biometrics_state.dart';

class SetupBiometricsPage extends StatelessWidget {
  const SetupBiometricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<SetupBiometricsBloc, SetupBiometricsState>(
        listener: (context, state) {
          if (state.isEnabled || state.isSkipped) {
            context.go('/home');
          }
          if (state.status == LoadingStatus.error &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.red500,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == LoadingStatus.loading &&
              state.availableType == BiometricsType.none) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  SvgPicture.asset(
                    Assets.icons.faceid,
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 56),

                  Text(
                    'Хотите использовать Face ID для входа в приложение?',
                    style: AppTypography.titleBold2,
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 3),

                  PrimaryButton(
                    label: 'Использовать Face ID',
                    size: PrimaryButtonSize.large,
                    style: PrimatyButtonStyle.colored,
                    isLoading: state.status == LoadingStatus.loading,
                    onPressed: () {
                      context.read<SetupBiometricsBloc>().add(
                        const SetupBiometricsEvent.enableBiometrics(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  PrimaryButton(
                    label: 'Входить только с кодом',
                    size: PrimaryButtonSize.large,
                    style: PrimatyButtonStyle.white,
                    onPressed: () {
                      context.read<SetupBiometricsBloc>().add(
                        const SetupBiometricsEvent.skip(),
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
