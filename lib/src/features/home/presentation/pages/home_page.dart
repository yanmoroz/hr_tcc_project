import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../users/presentation/widgets/user_profile_header.dart';
import '../widgets/home_icon_button.dart';
import '../widgets/home_news_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F6),
      body: Column(
        children: [
          const UserProfileHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon buttons row
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        HomeIconButton(
                          iconPath: Assets.icons.telegramIcon,
                          label: 'Телеграм-\nканал S8',
                          onTap: () => _launchUrl('http://telegram.org'),
                        ),
                        HomeIconButton(
                          iconPath: Assets.icons.discountsIcon,
                          label: 'Льготы\nи возмож...',
                          onTap: () =>
                              context.push('/home/discount-categories'),
                        ),
                        HomeIconButton(
                          iconPath: Assets.icons.pollsIcon,
                          label: 'Опросы',
                          onTap: () => context.push('/home/polls'),
                        ),
                        HomeIconButton(
                          iconPath: Assets.icons.resellIcon,
                          label: 'Ресейл',
                          onTap: () => context.push('/home/resell'),
                        ),
                        HomeIconButton(
                          iconPath: Assets.icons.s8Icon,
                          label: 'ИТ-портал',
                          onTap: () => _launchUrl('https://s8.capital'),
                        ),
                      ],
                    ),
                  ),

                  // News section
                  const SizedBox(height: 8),
                  const HomeNewsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
