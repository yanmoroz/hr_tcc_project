import 'package:flutter/material.dart';

import '../../../users/presentation/widgets/user_profile_header.dart';
import '../widgets/more_menu_card.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
              icon: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: Color(0xFF5E6AD2),
                  size: 32,
                ),
              ),
              onTap: () {
                // TODO: Implement ISpring integration (external link)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Переход на платформу ISpring'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      ],
    );
  }
}
