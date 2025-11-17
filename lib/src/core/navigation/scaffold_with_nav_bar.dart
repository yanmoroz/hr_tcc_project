import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: currentIndex,
                onTap: (index) => _onItemTapped(index, context),
                selectedItemColor: const Color(0xFF0A3899),
                unselectedItemColor: Colors.grey[600],
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedFontSize: 10,
                unselectedFontSize: 10,
                items: [
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                      'assets/icons/home-icon.svg',
                      0,
                      currentIndex,
                    ),
                    label: 'Главная',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                      'assets/icons/applications-icon.svg',
                      1,
                      currentIndex,
                    ),
                    label: 'Мои заявки',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                      'assets/icons/contacts-icon.svg',
                      2,
                      currentIndex,
                    ),
                    label: 'Контакты',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                      'assets/icons/more-icon.svg',
                      3,
                      currentIndex,
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

  Widget _buildIcon(String assetPath, int index, int currentIndex) {
    final isSelected = index == currentIndex;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0A3899) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: SvgPicture.asset(
          assetPath,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.white : Colors.grey[600]!,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/applications')) {
      return 1;
    }
    if (location.startsWith('/contacts')) {
      return 2;
    }
    if (location.startsWith('/more')) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/applications');
        break;
      case 2:
        context.go('/contacts');
        break;
      case 3:
        context.go('/more');
        break;
    }
  }
}
