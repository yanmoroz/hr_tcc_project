import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class NumericKeypad extends StatelessWidget {
  final void Function(String digit) onDigitPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback? onBiometricsPressed;
  final VoidCallback? onPasswordLoginPressed;
  final bool showBiometrics;
  final bool showDelete;
  final bool showPasswordLogin;

  const NumericKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onDeletePressed,
    this.onBiometricsPressed,
    this.onPasswordLoginPressed,
    this.showBiometrics = false,
    this.showDelete = true,
    this.showPasswordLogin = false,
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
    // Left: "Вход по паролю" button (if showPasswordLogin)
    // Center: "0" digit
    // Right: Biometrics (if showBiometrics && no digits) OR Delete (if digits) OR empty
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        showPasswordLogin
            ? _buildPasswordLoginButton()
            : const SizedBox(width: 64),
        _buildDigitButton('0'),
        _buildRightButton(),
      ],
    );
  }

  Widget _buildRightButton() {
    // Show biometrics only when no digits entered (showDelete is false)
    if (showBiometrics && !showDelete) {
      return _buildBiometricsButton();
    }
    if (showDelete) {
      return _buildDeleteButton();
    }
    return const SizedBox(width: 64);
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
    return Container(
      width: 64,
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: onBiometricsPressed,
            borderRadius: BorderRadius.circular(40),
            child: Container(
              alignment: Alignment.center,
              child: const Icon(
                Icons.fingerprint,
                color: AppColors.black,
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordLoginButton() {
    return Container(
      width: 64,
      height: 64,
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onPasswordLoginPressed,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'Вход по\nпаролю',
              style: AppTypography.textRegular2.copyWith(
                color: AppColors.grey700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
