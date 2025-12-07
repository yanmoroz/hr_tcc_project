import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../gen/assets.gen.dart';
import 'quick_link_button.dart';

class QuickLinkBar extends StatelessWidget {
  const QuickLinkBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuickLinkButton(
          iconPath: Assets.icons.telegramIcon,
          label: 'Телеграм-канал S8',
          onTap: () => _launchUrl('http://telegram.org'),
        ),
        QuickLinkButton(
          iconPath: Assets.icons.discountsIcon,
          label: 'Льготы и возможности',
          onTap: () => context.push('/home/discount-categories'),
        ),
        QuickLinkButton(
          iconPath: Assets.icons.pollsIcon,
          label: 'Опросы',
          onTap: () => context.push('/home/polls'),
        ),
        QuickLinkButton(
          iconPath: Assets.icons.resellIcon,
          label: 'Ресейл',
          onTap: () => context.push('/home/resell'),
        ),
        QuickLinkButton(
          iconPath: Assets.icons.s8Icon,
          label: 'ИТ-портал',
          onTap: () => _launchUrl('https://s8.capital'),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
