import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../users/presentation/widgets/user_profile_header.dart';
import '../widgets/more_menu_card.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F6),
      body: Column(
        children: [
          const UserProfileHeader(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Report violations menu item
                MoreMenuCard(
                  title: 'Сообщить о нарушениях',
                  onTap: () {
                    // TODO: Implement violations reporting feature
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Функция в разработке'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                // ISpring menu item
                MoreMenuCard(
                  title: 'ISpring',
                  subtitle: 'Дистанционное обучение организаций',
                  icon: SvgPicture.asset(
                    Assets.icons.ispringIcon,
                    width: 32,
                    height: 32,
                    fit: BoxFit.none,
                  ),
                  onTap: () {
                    _launchUrl('https://ispring.ru');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
