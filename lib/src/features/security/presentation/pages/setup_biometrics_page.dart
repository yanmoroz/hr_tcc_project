import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
          if (state.status == LoadingStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.red500,
              ),
            );
          }
        },
        builder: (context, state) {
          final biometricName = state.availableType == BiometricsType.faceId
              ? 'Face ID'
              : 'Touch ID';
          final biometricIcon = state.availableType == BiometricsType.faceId
              ? Icons.face
              : Icons.fingerprint;

          if (state.status == LoadingStatus.loading &&
              state.availableType == BiometricsType.none) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  Icon(biometricIcon, size: 80, color: AppColors.blue700),
                  const SizedBox(height: 32),

                  Text(
                    'Включить $biometricName?',
                    style: AppTypography.titleBold1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Используйте $biometricName для быстрого и безопасного входа в приложение',
                    style: AppTypography.textRegular1.grey700,
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 3),

                  PrimaryButton(
                    label: 'Включить $biometricName',
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

                  TextButton(
                    onPressed: () {
                      context.read<SetupBiometricsBloc>().add(
                        const SetupBiometricsEvent.skip(),
                      );
                    },
                    child: Text(
                      'Пропустить',
                      style: AppTypography.textMedium1.copyWith(
                        color: AppColors.blue700,
                      ),
                    ),
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
