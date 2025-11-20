import 'package:flutter/material.dart';

class EmptyApplicationsState extends StatelessWidget {
  const EmptyApplicationsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Empty state message
            const Text(
              'Здесь появится список всех\nсозданных заявок',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF757575),
                height: 1.4,
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
