import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: navigationShell),
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
                currentIndex: navigationShell.currentIndex,
                onTap: _onItemTapped,
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
                      navigationShell.currentIndex,
                    ),
                    label: 'Главная',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                      'assets/icons/applications-icon.svg',
                      1,
                      navigationShell.currentIndex,
                    ),
                    label: 'Мои заявки',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                      'assets/icons/contacts-icon.svg',
                      2,
                      navigationShell.currentIndex,
                    ),
                    label: 'Контакты',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                      'assets/icons/more-icon.svg',
                      3,
                      navigationShell.currentIndex,
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

  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
