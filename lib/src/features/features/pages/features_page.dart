import 'package:flutter/material.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Features')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              title: const Text('Notifications'),
              subtitle: const Text('View and manage your notifications'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Polls'),
              subtitle: const Text('View and participate in polls'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/polls');
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Users'),
              subtitle: const Text('Browse users by system type'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/users');
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Discounts'),
              subtitle: const Text('Browse discount categories and offers'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/discount-categories');
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('News'),
              subtitle: const Text('Read latest news and updates'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/news');
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Resell'),
              subtitle: const Text('Browse and book items from marketplace'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/resell');
              },
            ),
          ),
        ],
      ),
    );
  }
}
