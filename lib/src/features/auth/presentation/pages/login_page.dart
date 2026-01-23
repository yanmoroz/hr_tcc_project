import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _consentChecked = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _validateForm();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid =
        _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _consentChecked;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthEvent.loginRequested(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _showPrivacyPolicy() {
    // TODO: Implement privacy policy display
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == LoadingStatus.success && state.isAuthenticated) {
            context.go('/home');
          }
          if (state.status == LoadingStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Ошибка входа'),
                backgroundColor: AppColors.red500,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == LoadingStatus.loading;
          final isKeyboardVisible =
              MediaQuery.of(context).viewInsets.bottom > 0;

          return SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Scrollable content
                SingleChildScrollView(
                  physics: isKeyboardVisible
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 56),
                        Text(
                          'Войдите в учётную запись',
                          style: AppTypography.titleBold3.black,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        AppTextFormField(
                          controller: _usernameController,
                          labelText: 'Логин',
                          fieldStyle: AppTextFieldStyle.filled,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Введите логин';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextFormField(
                          controller: _passwordController,
                          labelText: 'Пароль',
                          fieldStyle: AppTextFieldStyle.filled,
                          obscureText: _obscurePassword,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          enabled: !isLoading,
                          onFieldSubmitted: (_) => _handleLogin(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.grey700,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введите пароль';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        _buildConsentRow(isLoading),
                      ],
                    ),
                  ),
                ),
                // Button - pinned above keyboard, visible when keyboard shows
                if (isKeyboardVisible)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    child: PrimaryButton(
                      label: 'Продолжить',
                      size: PrimaryButtonSize.large,
                      style: PrimatyButtonStyle.colored,
                      enabled: _isFormValid && !isLoading,
                      isLoading: isLoading,
                      onPressed: _handleLogin,
                    ),
                  ),
                // Bottom text - pinned, keyboard covers it
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).padding.bottom + 24,
                  child: Text(
                    'Если у вас нет учётной записи, обратитесь в компанию',
                    style: AppTypography.textRegular2.grey700,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildConsentRow(bool isLoading) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: AppCheckBox(
            value: _consentChecked,
            onChanged: isLoading
                ? null
                : (value) {
                    setState(() => _consentChecked = value);
                    _validateForm();
                  },
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: AppTypography.textRegular2.black,
              children: [
                const TextSpan(text: 'Я согласен(на) на '),
                TextSpan(
                  text: 'обработку персональных данных',
                  style: AppTypography.textRegular2.blue500,
                  recognizer: TapGestureRecognizer()
                    ..onTap = _showPrivacyPolicy,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
