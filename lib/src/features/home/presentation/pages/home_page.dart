import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Column(
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
                        iconPath: 'assets/icons/telegram-icon.svg',
                        label: 'Телеграм-\nканал S8',
                        onTap: () => _launchUrl('http://telegram.org'),
                      ),
                      HomeIconButton(
                        iconPath: 'assets/icons/discounts-icon.svg',
                        label: 'Льготы\nи возмож...',
                        onTap: () => context.push('/discount-categories'),
                      ),
                      HomeIconButton(
                        iconPath: 'assets/icons/polls-icon.svg',
                        label: 'Опросы',
                        onTap: () => context.push('/polls'),
                      ),
                      HomeIconButton(
                        iconPath: 'assets/icons/resell-icon.svg',
                        label: 'Ресейл',
                        onTap: () => context.push('/resell'),
                      ),
                      HomeIconButton(
                        iconPath: 'assets/icons/s8-icon.svg',
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
    );
  }
}
