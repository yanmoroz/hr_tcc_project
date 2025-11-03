import 'package:flutter/material.dart';
import 'package:hr_tcc_project/src/core/di/service_locator.dart';
import 'package:hr_tcc_project/src/core/files/domain/entities/system_type.dart';
import 'package:hr_tcc_project/src/features/users/domain/entities/user.dart';
import 'package:hr_tcc_project/src/features/users/domain/usecases/get_users_usecase.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final GetUsersUsecase _getUsersUsecase = sl<GetUsersUsecase>();
  final TextEditingController _searchController = TextEditingController();

  SystemType _selectedSystemType = SystemType.elma;
  List<User>? _users;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _getUsersUsecase(
      systemType: _selectedSystemType,
      search: _searchController.text.isEmpty ? null : _searchController.text,
    );

    result.fold(
      (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = error.toString();
        });
      },
      (users) {
        setState(() {
          _isLoading = false;
          _users = users;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // System Type Dropdown
                DropdownButtonFormField<SystemType>(
                  initialValue: _selectedSystemType,
                  decoration: const InputDecoration(labelText: 'System Type', border: OutlineInputBorder()),
                  items: SystemType.values.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type.name));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedSystemType = value;
                      });
                      _loadUsers();
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Search Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by name',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: _loadUsers),
                  ),
                  onSubmitted: (_) => _loadUsers(),
                ),
              ],
            ),
          ),
          // Users List
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: $_errorMessage',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadUsers, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_users == null || _users!.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return ListView.builder(
      itemCount: _users!.length,
      itemBuilder: (context, index) {
        final user = _users![index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(child: Text(user.title.isNotEmpty ? user.title[0].toUpperCase() : '?')),
            title: Text(user.title),
            subtitle: Text(user.position.toString()),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (user.idPersonElma != null) const Text('ELMA', style: TextStyle(fontSize: 10, color: Colors.grey)),
                if (user.idPersonKp != null) const Text('KP', style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
        );
      },
    );
  }
}
