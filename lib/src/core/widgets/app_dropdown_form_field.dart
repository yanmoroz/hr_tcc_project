import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/theme.dart';
import 'app_radio_button.dart';

class AppDropdownFormField<T> extends StatefulWidget {
  final T? value;
  final ValueChanged<T?>? onChanged;
  final List<RadioButtonItem<T>> items;
  final String? labelText;
  final String? modalTitle;
  final bool enabled;
  final String? Function(T?)? validator;

  const AppDropdownFormField({
    super.key,
    this.value,
    this.onChanged,
    required this.items,
    this.labelText,
    this.modalTitle,
    this.enabled = true,
    this.validator,
  });

  @override
  State<AppDropdownFormField<T>> createState() =>
      _AppDropdownFormFieldState<T>();
}

class _AppDropdownFormFieldState<T> extends State<AppDropdownFormField<T>> {
  bool _isOpen = false;
  String? _errorText;

  void _openModal() {
    if (!widget.enabled) return;

    setState(() => _isOpen = true);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(ctx).size.height * 0.065),
        child: _DropdownModal<T>(
          title: widget.modalTitle ?? widget.labelText ?? '',
          items: widget.items,
          selectedValue: widget.value,
          onSelected: (val) {
            Navigator.pop(ctx);
            widget.onChanged?.call(val);
            _runValidation(val);
          },
        ),
      ),
    ).whenComplete(() {
      if (mounted) setState(() => _isOpen = false);
    });
  }

  void _runValidation(T? val) {
    final error = widget.validator?.call(val);
    if (_errorText != error) {
      setState(() => _errorText = error);
    }
  }

  Border _getBorder() {
    if (_errorText != null) {
      return Border.all(color: AppColors.red500, width: 1);
    }
    return Border.all(
      color: _isOpen ? AppColors.blue300 : AppColors.grey500,
      width: 1,
    );
  }

  Color _getBackgroundColor() {
    return widget.enabled ? AppColors.white : AppColors.grey50;
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.value != null;
    final selectedLabel = hasValue
        ? widget.items
              .where((i) => i.value == widget.value)
              .map((i) => i.label)
              .firstOrNull
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _openModal,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: BorderRadius.circular(8),
              border: _getBorder(),
            ),
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: hasValue && selectedLabel != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.labelText ?? '',
                              style: AppTypography.textRegular2.grey700,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              selectedLabel,
                              style: AppTypography.textRegular1.black,
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            widget.labelText ?? '',
                            style: AppTypography.textRegular1.grey700,
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: widget.enabled ? AppColors.grey700 : AppColors.grey500,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(_errorText!, style: AppTypography.textRegular2.red500),
          ),
      ],
    );
  }
}

class _DropdownModal<T> extends StatelessWidget {
  final String title;
  final List<RadioButtonItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T?> onSelected;

  const _DropdownModal({
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title, style: AppTypography.titleBold1.black),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: const Icon(
                      Icons.close,
                      color: AppColors.grey700,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.grey200),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _buildTiles(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTiles(BuildContext context) {
    final tiles = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final isSelected = item.value == selectedValue;

      tiles.add(
        GestureDetector(
          onTap: item.enabled ? () => onSelected(item.value) : null,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: AppTypography.textRegular1.copyWith(
                      color: item.enabled ? AppColors.black : AppColors.grey500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                AppRadioButton(
                  value: isSelected,
                  onChanged: item.enabled
                      ? (_) => onSelected(item.value)
                      : null,
                ),
              ],
            ),
          ),
        ),
      );

      if (i < items.length - 1) {
        tiles.add(
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.grey200,
            indent: 16,
            endIndent: 16,
          ),
        );
      }
    }
    return tiles;
  }
}
