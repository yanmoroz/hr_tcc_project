import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../gen/assets.gen.dart';
import 'menu_button.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MenuButton(
          iconPath: Assets.icons.telegramIcon,
          label: 'Телеграм-канал S8',
          onTap: () => _launchUrl('http://telegram.org'),
        ),
        MenuButton(
          iconPath: Assets.icons.discountsIcon,
          label: 'Льготы и возможности',
          onTap: () => context.push('/home/discount-categories'),
        ),
        MenuButton(
          iconPath: Assets.icons.pollsIcon,
          label: 'Опросы',
          onTap: () => context.push('/home/polls'),
        ),
        MenuButton(
          iconPath: Assets.icons.resellIcon,
          label: 'Ресейл',
          onTap: () => context.push('/home/resell'),
        ),
        MenuButton(
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
