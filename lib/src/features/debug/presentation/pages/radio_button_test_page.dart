import 'package:flutter/material.dart';

import '../../../../core/models/models.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

class RadioButtonTestPage extends StatefulWidget {
  const RadioButtonTestPage({super.key});

  @override
  State<RadioButtonTestPage> createState() => _RadioButtonTestPageState();
}

class _RadioButtonTestPageState extends State<RadioButtonTestPage> {
  bool _standaloneValue = false;
  String? _selectedFruit;
  int? _selectedNumber;
  String? _horizontalValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radio Button Test'),
        backgroundColor: AppColors.blue500,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Standalone AppRadioButton',
              child: Row(
                children: [
                  AppRadioButton(
                    value: _standaloneValue,
                    onChanged: (value) {
                      setState(() => _standaloneValue = value);
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _standaloneValue ? 'Selected' : 'Not selected',
                    style: AppTypography.textRegular1,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Vertical Group (String values)',
              subtitle: 'Selected: ${_selectedFruit ?? "none"}',
              child: AppRadioButtonGroup<String>(
                value: _selectedFruit,
                onChanged: (value) {
                  setState(() => _selectedFruit = value);
                },
                items: const [
                  RadioButtonItem(value: 'apple', label: 'Apple'),
                  RadioButtonItem(value: 'banana', label: 'Banana'),
                  RadioButtonItem(value: 'orange', label: 'Orange'),
                  RadioButtonItem(
                    value: 'grape',
                    label: 'Grape (disabled)',
                    enabled: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Vertical Group (int values)',
              subtitle: 'Selected: ${_selectedNumber ?? "none"}',
              child: AppRadioButtonGroup<int>(
                value: _selectedNumber,
                onChanged: (value) {
                  setState(() => _selectedNumber = value);
                },
                items: const [
                  RadioButtonItem(value: 1, label: 'Option 1'),
                  RadioButtonItem(value: 2, label: 'Option 2'),
                  RadioButtonItem(value: 3, label: 'Option 3'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Horizontal Group',
              subtitle: 'Selected: ${_horizontalValue ?? "none"}',
              child: AppRadioButtonGroup<String>(
                value: _horizontalValue,
                onChanged: (value) {
                  setState(() => _horizontalValue = value);
                },
                direction: Axis.horizontal,
                spacing: 24,
                items: const [
                  RadioButtonItem(value: 'yes', label: 'Yes'),
                  RadioButtonItem(value: 'no', label: 'No'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Disabled Group',
              child: AppRadioButtonGroup<String>(
                value: 'option1',
                onChanged: null,
                items: const [
                  RadioButtonItem(value: 'option1', label: 'Option 1'),
                  RadioButtonItem(value: 'option2', label: 'Option 2'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Different Sizes',
              child: Row(
                children: [
                  AppRadioButton(value: true, onChanged: (_) {}, size: 16),
                  const SizedBox(width: 16),
                  AppRadioButton(value: true, onChanged: (_) {}, size: 24),
                  const SizedBox(width: 16),
                  AppRadioButton(value: true, onChanged: (_) {}, size: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleMedium2.copyWith(color: AppColors.blue700),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTypography.textRegular2.copyWith(
              color: AppColors.grey700,
            ),
          ),
        ],
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowCard.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}
