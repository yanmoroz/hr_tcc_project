import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/entities/application_form.dart';

class ApplicationFormItem extends StatelessWidget {
  final ApplicationForm applicationForm;
  final VoidCallback onTap;

  const ApplicationFormItem({
    super.key,
    required this.applicationForm,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: _getFormIcon(),
                ),
              ),
              const SizedBox(width: 12),

              // Form name
              Expanded(
                child: Text(
                  applicationForm.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF212121),
                  ),
                ),
              ),

              // Arrow icon
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF9E9E9E),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getFormIcon() {
    // Map form codes/names to icons
    // Based on the Figma, using common icons for each type
    final iconPath = _getIconPath(applicationForm.code);

    return SvgPicture.asset(
      iconPath,
      width: 24,
      height: 24,
      colorFilter: const ColorFilter.mode(
        Color(0xFF757575),
        BlendMode.srcIn,
      ),
    );
  }

  String _getIconPath(String code) {
    // Map application form codes to icon paths
    // These are generic mappings - adjust based on actual codes from API
    switch (code.toLowerCase()) {
      case 'propusk':
      case 'пропуск':
        return 'assets/icons/comments-icon.svg'; // Replace with appropriate icon
      case 'parking':
      case 'парковка':
        return 'assets/icons/comments-icon.svg'; // Replace with car icon
      case 'absence':
      case 'отсутствие':
        return 'assets/icons/comments-icon.svg'; // Replace with calendar icon
      case 'violation':
      case 'нарушение':
        return 'assets/icons/comments-icon.svg'; // Replace with alert icon
      default:
        // Default icon for all forms
        return 'assets/icons/comments-icon.svg';
    }
  }
}
