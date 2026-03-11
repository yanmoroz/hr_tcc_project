import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/theme.dart';
import '../app_check_box.dart';

class AppCheckBoxGroup<T> extends StatelessWidget {
  final Set<T> value;
  final ValueChanged<Set<T>>? onChanged;
  final List<CheckBoxItem<T>> items;
  final Axis direction;
  final double spacing;
  final double checkBoxSize;

  const AppCheckBoxGroup({
    super.key,
    required this.value,
    this.onChanged,
    required this.items,
    this.direction = Axis.vertical,
    this.spacing = 12.0,
    this.checkBoxSize = 24.0,
  });

  bool get _isEnabled => onChanged != null;

  void _handleItemTap(CheckBoxItem<T> item) {
    if (_isEnabled && item.enabled) {
      final newValue = Set<T>.from(value);
      if (newValue.contains(item.value)) {
        newValue.remove(item.value);
      } else {
        newValue.add(item.value);
      }
      onChanged!(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = items.map((item) {
      final isChecked = value.contains(item.value);
      final isItemEnabled = _isEnabled && item.enabled;

      return _CheckBoxTile(
        item: item,
        isChecked: isChecked,
        isEnabled: isItemEnabled,
        checkBoxSize: checkBoxSize,
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
        if (axis == Axis.horizontal) {
          result.add(SizedBox(width: spacing));
        } else {
          result.add(
            Padding(
              padding: EdgeInsets.symmetric(vertical: spacing / 2),
              child: const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.white,
              ),
            ),
          );
        }
      }
    }
    return result;
  }
}

class _CheckBoxTile<T> extends StatelessWidget {
  final CheckBoxItem<T> item;
  final bool isChecked;
  final bool isEnabled;
  final double checkBoxSize;
  final Axis direction;
  final VoidCallback onTap;

  const _CheckBoxTile({
    required this.item,
    required this.isChecked,
    required this.isEnabled,
    required this.checkBoxSize,
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

    final checkBox = AppCheckBox(
      value: isChecked,
      onChanged: isEnabled ? (_) => onTap() : null,
      size: checkBoxSize,
    );

    // Vertical: label left (expanded), checkbox right with max spacing
    // Horizontal: checkbox left, label right (compact)
    final children = direction == Axis.vertical
        ? [Expanded(child: label), checkBox]
        : [checkBox, const SizedBox(width: 8), label];

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
