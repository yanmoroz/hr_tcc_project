import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../gen/assets.gen.dart';
import '../base_types/loading_status.dart';
import '../blocs/current_user/bloc.dart';
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
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_barContainerCornerRadius),
                topRight: Radius.circular(_barContainerCornerRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.05),
                  blurRadius: _shadowBlurRadius,
                  offset: _shadowOffset,
                ),
              ],
            ),
            child: NavigationBar(
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: _onItemTapped,
              height: 68,
              backgroundColor: AppColors.transparent,
              indicatorColor: AppColors.transparent,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              labelPadding: const EdgeInsets.only(top: _iconToLabelSpacing),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTypography.captionMedium3.copyWith(
                    color: AppColors.blue700,
                  );
                }
                return AppTypography.captionMedium3.copyWith(
                  color: AppColors.grey700,
                );
              }),
              destinations: [
                NavigationDestination(
                  icon: _buildIcon(
                    assetPath: Assets.icons.homeIcon,
                    isSelected: widget.navigationShell.currentIndex == 0,
                  ),
                  label: 'Главная',
                ),
                NavigationDestination(
                  icon: _buildIcon(
                    assetPath: Assets.icons.applicationsIcon,
                    isSelected: widget.navigationShell.currentIndex == 1,
                  ),
                  label: 'Мои заявки',
                ),
                NavigationDestination(
                  icon: _buildIcon(
                    assetPath: Assets.icons.contactsIcon,
                    isSelected: widget.navigationShell.currentIndex == 2,
                  ),
                  label: 'Контакты',
                ),
                NavigationDestination(
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
