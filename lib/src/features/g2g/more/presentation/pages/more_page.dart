import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../users/presentation/widgets/user_profile_header.dart';
import '../widgets/more_item.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Column(
        children: [
          const UserProfileHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Report violations menu item
                    MoreItem(
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

                    const SizedBox(height: 8),

                    // ISpring menu item
                    MoreItem(
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

                    const SizedBox(height: 16),
                  ],
                ),
              ),
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
