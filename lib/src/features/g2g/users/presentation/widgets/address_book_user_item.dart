import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../../../../../core/widgets/user_avatar.dart';
import '../../domain/domain.dart';

class AddressBookUserItem extends StatelessWidget {
  final AddressBookUser user;

  const AddressBookUserItem({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            UserAvatar.fromName(
              firstName: user.firstName,
              lastName: user.lastName,
              id: user.id,
              photoFuture: createUserPhotoFuture(
                systemType: SystemType.tcc,
                photoExists: user.photoExists,
                userId: user.id,
              ),
            ),
            const SizedBox(width: 12),
            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full name
                  Text(user.title, style: AppTypography.textSemibold1.black),
                  const SizedBox(height: 8),
                  // Position pill
                  if (user.position != null && user.position!.isNotEmpty) ...[
                    _buildInfoPill(user.position!),
                    const SizedBox(height: 6),
                  ],
                  // Department pill
                  if (user.department.name != null &&
                      user.department.name!.isNotEmpty) ...[
                    _buildInfoPill(user.department.name!),
                    const SizedBox(height: 8),
                  ],
                  // Contact info
                  // Mobile phone
                  _buildPhoneNumber(user.mobile, '(моб.)'),
                  // Work phone
                  if (user.workPhone != null) ...[
                    const SizedBox(height: 4),
                    _buildPhoneNumber(user.workPhone!, '(раб.)'),
                  ],
                  // Email
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => _launchEmail(user.mail),
                    child: Text(
                      user.mail,
                      style: AppTypography.textLink2.blue500.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.grey500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: AppTypography.captionMedium2.black),
    );
  }

  Widget _buildPhoneNumber(String phone, String label) {
    final formattedPhone = _formatPhoneNumber(phone);

    return GestureDetector(
      onTap: () => _launchPhone(phone),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: formattedPhone,
              style: AppTypography.textLink2.blue500.copyWith(
                decoration: TextDecoration.underline,
                decorationColor: AppColors.grey500,
              ),
            ),
            TextSpan(text: ' $label', style: AppTypography.textLink2.grey700),
          ],
        ),
      ),
    );
  }

  String _formatPhoneNumber(String phone) {
    // Extract only digits from the phone number
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length >= 11) {
      // Format as +X XXX XXX-XX-XX
      return '+${digits[0]} ${digits.substring(1, 4)} ${digits.substring(4, 7)}-${digits.substring(7, 9)}-${digits.substring(9, 11)}';
    }

    return phone; // Return original if format doesn't match
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
