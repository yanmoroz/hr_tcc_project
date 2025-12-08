import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class CustomSliverAppBar extends StatelessWidget {
  final Widget? title;

  const CustomSliverAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: title,
      pinned: true,
      floating: true,
      elevation: 0, // Disable default elevation
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow300,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }
}
