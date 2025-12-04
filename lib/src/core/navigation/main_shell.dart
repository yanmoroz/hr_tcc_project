import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../gen/assets.gen.dart';
import '../../features/g2g/users/presentation/blocs/current_user/bloc.dart';
import '../base_types/loading_status.dart';
import '../di/service_locator.dart';
import '../retry/retry_notifier.dart';
import '../theme/theme.dart';

class MainShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const double _barContainerCornerRadius = 16;
  static const double _barContainerTopPadding = 12;
  static const double _barItemSize = 32;
  static const double _barItemCornerRadius = 8;
  static const double _iconToLabelSpacing = 2;
  static const double _shadowBlurRadius = 12;
  static const Offset _shadowOffset = Offset(0, -4);

  late final RetryNotifier _retryNotifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(child: widget.navigationShell),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
        ),
        child: Container(
          color: AppColors.grey100,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_barContainerCornerRadius),
                topRight: Radius.circular(_barContainerCornerRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow100,
                  blurRadius: _shadowBlurRadius,
                  offset: _shadowOffset,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: _barContainerTopPadding),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: widget.navigationShell.currentIndex,
                onTap: _onItemTapped,
                elevation: 0,
                backgroundColor: AppColors.transparent,
                selectedItemColor: AppColors.blue700,
                unselectedItemColor: AppColors.grey700,
                selectedLabelStyle: AppTypography.captionMedium3,
                unselectedLabelStyle: AppTypography.captionMedium3,
                items: [
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                      assetPath: Assets.icons.homeIcon,
                      isSelected: widget.navigationShell.currentIndex == 0,
                    ),
                    label: 'Главная',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                      assetPath: Assets.icons.applicationsIcon,
                      isSelected: widget.navigationShell.currentIndex == 1,
                    ),
                    label: 'Мои заявки',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                      assetPath: Assets.icons.contactsIcon,
                      isSelected: widget.navigationShell.currentIndex == 2,
                    ),
                    label: 'Контакты',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                      assetPath: Assets.icons.moreIcon,
                      isSelected: widget.navigationShell.currentIndex == 3,
                    ),
                    label: 'Ещё',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _retryNotifier.removeListener(_onRetry);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _retryNotifier = sl<RetryNotifier>();
    _retryNotifier.addListener(_onRetry);
  }

  Widget _buildIcon({required String assetPath, required bool isSelected}) {
    return Container(
      margin: const EdgeInsets.only(bottom: _iconToLabelSpacing),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.blue700 : AppColors.transparent,
        borderRadius: BorderRadius.circular(_barItemCornerRadius),
      ),
      child: SvgPicture.asset(
        assetPath,
        width: _barItemSize,
        height: _barItemSize,
        colorFilter: ColorFilter.mode(
          isSelected ? AppColors.white : AppColors.grey700,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _onRetry() {
    final userState = context.read<CurrentUserBloc>().state;
    if (userState.status == LoadingStatus.error) {
      context.read<CurrentUserBloc>().add(
        const CurrentUserEvent.loadCurrentUser(),
      );
    }
  }
}
