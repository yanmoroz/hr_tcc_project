import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../users/presentation/presentation.dart';
import '../widgets/more_item.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = _buildMenuItems(context);

    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _ShadowedUserBarDelegate(extent: 56.0),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            sliver: SliverList.separated(
              itemCount: menuItems.length,
              itemBuilder: (context, index) => menuItems[index],
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    return [
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
    ];
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ShadowedUserBarDelegate extends SliverPersistentHeaderDelegate {
  final double extent;

  _ShadowedUserBarDelegate({required this.extent});

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return const UserInfoBar(enableCorners: true, showShadow: true);
  }

  @override
  bool shouldRebuild(covariant _ShadowedUserBarDelegate oldDelegate) => false;
}
