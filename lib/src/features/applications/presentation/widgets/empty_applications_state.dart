import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

class EmptyApplicationsState extends StatelessWidget {
  const EmptyApplicationsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Text(
          'Здесь появится список всех созданных заявок',
          textAlign: TextAlign.center,
          style: AppTypography.textRegular1.black,
        ),
      ),
    );
  }
}
