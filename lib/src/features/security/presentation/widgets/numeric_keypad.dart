import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class NumericKeypad extends StatelessWidget {
  final void Function(String digit) onDigitPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback? onBiometricsPressed;
  final bool showBiometrics;
  final bool showDelete;

  const NumericKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onDeletePressed,
    this.onBiometricsPressed,
    this.showBiometrics = false,
    this.showDelete = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(['1', '2', '3']),
        const SizedBox(height: 12),
        _buildRow(['4', '5', '6']),
        const SizedBox(height: 12),
        _buildRow(['7', '8', '9']),
        const SizedBox(height: 12),
        _buildBottomRow(),
      ],
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: digits.map((digit) => _buildDigitButton(digit)).toList(),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        showBiometrics ? _buildBiometricsButton() : const SizedBox(width: 64),
        _buildDigitButton('0'),
        showDelete ? _buildDeleteButton() : const SizedBox(width: 64),
      ],
    );
  }

  Widget _buildDigitButton(String digit) {
    return Container(
      width: 64,
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: () => onDigitPressed(digit),
            borderRadius: BorderRadius.circular(40),
            child: Container(
              alignment: Alignment.center,
              child: Text(digit, style: AppTypography.numbersRegular2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Container(
      width: 64,
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: onDeletePressed,
            borderRadius: BorderRadius.circular(40),
            child: Container(
              alignment: Alignment.center,
              child: const Icon(
                Icons.backspace_outlined,
                color: AppColors.grey700,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricsButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
