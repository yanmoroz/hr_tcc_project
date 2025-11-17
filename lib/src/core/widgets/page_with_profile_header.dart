import 'package:flutter/material.dart';

import '../../features/users/presentation/widgets/user_profile_header.dart';

class PageWithProfileHeader extends StatelessWidget {
  const PageWithProfileHeader({
    required this.title,
    required this.body,
    super.key,
  });

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const UserProfileHeader(),
          Expanded(child: body),
        ],
      ),
    );
  }
}
