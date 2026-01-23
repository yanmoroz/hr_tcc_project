import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class NumericKeypad extends StatelessWidget {
  final void Function(String digit) onDigitPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback? onBiometricsPressed;
  final bool showBiometrics;

  const NumericKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onDeletePressed,
    this.onBiometricsPressed,
    this.showBiometrics = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(['1', '2', '3']),
        const SizedBox(height: 16),
        _buildRow(['4', '5', '6']),
        const SizedBox(height: 16),
        _buildRow(['7', '8', '9']),
        const SizedBox(height: 16),
        _buildBottomRow(),
      ],
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: digits.map((digit) => _buildDigitButton(digit)).toList(),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        showBiometrics ? _buildBiometricsButton() : const SizedBox(width: 80),
        _buildDigitButton('0'),
        _buildDeleteButton(),
      ],
    );
  }

  Widget _buildDigitButton(String digit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: () => onDigitPressed(digit),
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            child: Text(digit, style: AppTypography.titleBold1),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onDeletePressed,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            child: const Icon(
              Icons.backspace_outlined,
              color: AppColors.grey700,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricsButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onBiometricsPressed,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            child: const Icon(
              Icons.fingerprint,
              color: AppColors.blue700,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
