import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/theme.dart';
import '../app_radio_button.dart';

class AppRadioButtonGroup<T> extends StatelessWidget {
  final T? value;
  final ValueChanged<T?>? onChanged;
  final List<RadioButtonItem<T>> items;
  final Axis direction;
  final double spacing;
  final double radioSize;

  const AppRadioButtonGroup({
    super.key,
    required this.value,
    this.onChanged,
    required this.items,
    this.direction = Axis.vertical,
    this.spacing = 12.0,
    this.radioSize = 24.0,
  });

  bool get _isEnabled => onChanged != null;

  void _handleItemTap(RadioButtonItem<T> item) {
    if (_isEnabled && item.enabled) {
      onChanged!(item.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = items.map((item) {
      final isSelected = value == item.value;
      final isItemEnabled = _isEnabled && item.enabled;

      return _RadioButtonTile(
        item: item,
        isSelected: isSelected,
        isEnabled: isItemEnabled,
        radioSize: radioSize,
        direction: direction,
        onTap: () => _handleItemTap(item),
      );
    }).toList();

    if (direction == Axis.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: _insertSpacing(children, spacing, Axis.horizontal),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _insertSpacing(children, spacing, Axis.vertical),
    );
  }

  List<Widget> _insertSpacing(List<Widget> widgets, double spacing, Axis axis) {
    if (widgets.isEmpty) return widgets;

    final result = <Widget>[];
    for (var i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      if (i < widgets.length - 1) {
        result.add(
          axis == Axis.horizontal
              ? SizedBox(width: spacing)
              : SizedBox(height: spacing),
        );
      }
    }
    return result;
  }
}

class _RadioButtonTile<T> extends StatelessWidget {
  final RadioButtonItem<T> item;
  final bool isSelected;
  final bool isEnabled;
  final double radioSize;
  final Axis direction;
  final VoidCallback onTap;

  const _RadioButtonTile({
    required this.item,
    required this.isSelected,
    required this.isEnabled,
    required this.radioSize,
    required this.direction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = Text(
      item.label,
      style: AppTypography.textRegular1.copyWith(
        color: isEnabled ? AppColors.black : AppColors.grey500,
      ),
    );

    final radio = AppRadioButton(
      value: isSelected,
      onChanged: isEnabled ? (_) => onTap() : null,
      size: radioSize,
    );

    // Vertical: label left (expanded), radio right with max spacing
    // Horizontal: radio left, label right (compact)
    final children = direction == Axis.vertical
        ? [Expanded(child: label), radio]
        : [radio, const SizedBox(width: 8), label];

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: direction == Axis.horizontal
            ? MainAxisSize.min
            : MainAxisSize.max,
        children: children,
      ),
    );
  }
}
