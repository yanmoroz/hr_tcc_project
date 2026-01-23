import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/theme.dart';

enum AppTextFieldStyle {
  outlined,
  filled,
}

class AppTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final AppTextFieldStyle fieldStyle;

  const AppTextFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.fieldStyle = AppTextFieldStyle.outlined,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  FocusNode? _internalFocusNode;
  TextEditingController? _internalController;
  String? _errorText;
  bool _hasBeenFocused = false;

  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  Color _getBackgroundColor(bool isFocused) {
    if (!widget.enabled) return AppColors.grey50;

    if (widget.fieldStyle == AppTextFieldStyle.filled) {
      return isFocused ? AppColors.white : AppColors.grey100;
    }
    return AppColors.white;
  }

  Border _getBorder(bool hasError, bool isFocused) {
    if (hasError) {
      return Border.all(color: AppColors.red500, width: 1);
    }

    if (widget.fieldStyle == AppTextFieldStyle.filled) {
      if (isFocused) {
        return Border.all(color: AppColors.blue300, width: 1);
      }
      return Border.all(color: AppColors.transparent, width: 0);
    }

    return Border.all(
      color: isFocused ? AppColors.blue300 : AppColors.grey500,
      width: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_focusNode, _controller]),
      builder: (context, child) {
        final isFocused = _focusNode.hasFocus;
        final hasText = _controller.text.isNotEmpty;
        final hasError = _errorText != null;
        final showLabel = isFocused || hasText;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: _getBackgroundColor(isFocused),
                borderRadius: BorderRadius.circular(8),
                border: _getBorder(hasError, isFocused),
              ),
              child: TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                obscureText: widget.obscureText,
                enabled: widget.enabled,
                readOnly: widget.readOnly,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                maxLength: widget.maxLength,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                textCapitalization: widget.textCapitalization,
                inputFormatters: widget.inputFormatters,
                style: AppTypography.textRegular1.black,
                onChanged: widget.onChanged,
                onFieldSubmitted: widget.onFieldSubmitted,
                onTap: widget.onTap,
                autocorrect: false,
                enableSuggestions: false,
                validator: widget.validator,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  labelText: showLabel ? widget.labelText : null,
                  labelStyle: AppTypography.textRegular1.grey700,
                  floatingLabelStyle: AppTypography.textRegular2.grey700,
                  hintText: showLabel ? null : widget.labelText,
                  hintStyle: AppTypography.textRegular1.grey700,
                  alignLabelWithHint: true,
                  errorStyle: const TextStyle(height: 0, fontSize: 0),
                  border: InputBorder.none,
                  suffixIcon: widget.suffixIcon,
                  prefixIcon: widget.prefixIcon,
                ),
                cursorColor: AppColors.blue300,
              ),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _errorText!,
                  style: AppTypography.textRegular2.red500,
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _internalFocusNode?.dispose();
    _internalController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_hasBeenFocused && !_focusNode.hasFocus) {
      _validate();
    }
    if (_focusNode.hasFocus) {
      _hasBeenFocused = true;
    }
  }

  void _validate() {
    final error = widget.validator?.call(_controller.text);
    if (_errorText != error) {
      setState(() => _errorText = error);
    }
  }
}
