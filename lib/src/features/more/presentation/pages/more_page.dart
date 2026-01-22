import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/di/bloc_factory.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../delegates/more_page_header_delegate.dart';
import '../widgets/more_item.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);

    final logoutUsecase = sl<LogoutUsecase>();
    final result = await logoutUsecase();

    result.fold(
      (error) {
        setState(() => _isLoggingOut = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка выхода: ${error.toString()}'),
            backgroundColor: AppColors.red500,
          ),
        );
      },
      (_) {
        // Notify AuthStatusNotifier - GoRouter will automatically redirect to login
        BlocFactory.getAuthStatusNotifier().notifyLoggedOut();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = _buildMenuItems(context);

    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: ShadowedUserBarDelegate(extent: 56.0),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  sliver: SliverList.separated(
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) => menuItems[index],
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                  ),
                ),
              ],
            ),
          ),
          _buildLogoutButton(context),
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

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SafeArea(
        top: false,
        child: PrimaryButton(
          label: 'Выйти',
          size: PrimaryButtonSize.large,
          style: PrimatyButtonStyle.colored,
          enabled: !_isLoggingOut,
          isLoading: _isLoggingOut,
          onPressed: _handleLogout,
        ),
      ),
    );
  }
}
