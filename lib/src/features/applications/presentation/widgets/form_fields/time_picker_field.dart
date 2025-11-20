import 'package:flutter/material.dart';

class TimePickerField extends StatelessWidget {
  final String label;
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay?> onTimeSelected;
  final String? Function(String?)? validator;

  const TimePickerField({
    super.key,
    required this.label,
    required this.selectedTime,
    required this.onTimeSelected,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: selectedTime != null ? selectedTime!.format(context) : '',
    );

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.access_time),
        border: const OutlineInputBorder(),
      ),
      readOnly: true,
      validator: validator,
      onTap: () async {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );

        if (pickedTime != null) {
          onTimeSelected(pickedTime);
        }
      },
    );
  }
}
