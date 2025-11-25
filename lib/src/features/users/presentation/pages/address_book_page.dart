import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/widgets/search_bar_widget.dart';
import '../blocs/address_book_page/bloc.dart';
import '../widgets/address_book_user_item.dart';
import '../widgets/user_profile_header.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({super.key});

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<AddressBookBloc>().add(
        const AddressBookEvent.loadMoreAddressBook(),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    context.read<AddressBookBloc>().add(
      AddressBookEvent.searchAddressBook(query: query),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // User profile header with search bar
        UserProfileHeader(enableCorners: false),
        Container(
          height: 56,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: SearchBarWidget(
            onSearchChanged: _onSearchChanged,
            hintText: 'Поиск',
          ),
        ),
        // List
        Expanded(
          child: Container(
            color: const Color(0xFFF2F2F6),
            child: BlocBuilder<AddressBookBloc, AddressBookState>(
              builder: (context, state) {
                return _buildBody(context, state);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AddressBookState state) {
    if (state.status == LoadingStatus.initial) {
      return const SizedBox.shrink();
    }

    if (state.status == LoadingStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == LoadingStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ошибка: ${state.errorMessage ?? 'Unknown error'}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<AddressBookBloc>().add(
                  const AddressBookEvent.loadAddressBook(),
                );
              },
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    // Success state
    final users = state.users;
    final isLoadingMore = state.isLoadingMore;

    if (users.isEmpty) {
      return const Center(
        child: Text(
          'Таких сотрудников нет',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<AddressBookBloc>().add(
          const AddressBookEvent.refreshAddressBook(),
        );
        // Wait for the refresh to complete
        await context.read<AddressBookBloc>().stream.firstWhere(
          (state) => state.status != LoadingStatus.loading,
        );
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: users.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= users.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final user = users[index];
          return AddressBookUserItem(user: user);
        },
      ),
    );
  }
}
