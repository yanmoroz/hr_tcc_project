import 'package:flutter/material.dart';

class CommentField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;

  const CommentField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.maxLines = 5,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
    );
  }
}
