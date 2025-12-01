import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const UserProfileHeader(enableCorners: false),
        Expanded(
          child: BlocBuilder<AddressBookBloc, AddressBookState>(
            builder: (context, state) {
              if (state.status == LoadingStatus.initial ||
                  state.status == LoadingStatus.loading) {
                return const Center(child: AppProgressIndicator());
              }

              if (state.status == LoadingStatus.error) {
                return NetworkErrorMessageWidget(
                  onRetry: () => context
                      .read<AddressBookBloc>()
                      .add(const AddressBookEvent.loadAddressBook()),
                );
              }

              return _buildSuccessContent(context, state);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessContent(BuildContext context, AddressBookState state) {
    return Container(
      color: AppColors.grey100,
      child: Column(
        children: [
          // Search bar
          AppSearchBar(
            hintText: 'Поиск',
            isLoading: state.filteringStatus == LoadingStatus.loading,
            onSearchChanged: (query) {
              context.read<AddressBookBloc>().add(
                AddressBookEvent.searchAddressBook(query: query),
              );
            },
          ),

          // Content area or filtering error
          Expanded(
            child: state.filteringStatus == LoadingStatus.error
                ? NetworkErrorMessageWidget(
                    onRetry: () => context.read<AddressBookBloc>().add(
                      AddressBookEvent.searchAddressBook(
                        query: state.searchQuery ?? '',
                      ),
                    ),
                  )
                : _buildUsersList(context, state),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(BuildContext context, AddressBookState state) {
    if (state.users.isEmpty) {
      return Center(
        child: Text(
          'Таких сотрудников нет',
          style: AppTypography.textRegular1.copyWith(color: AppColors.grey700),
        ),
      );
    }

    return AppRefreshIndicator(
      onRefresh: () async {
        context.read<AddressBookBloc>().add(
          const AddressBookEvent.refreshAddressBook(),
        );
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.users.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.users.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: AppProgressIndicator(),
              ),
            );
          }
          return AddressBookUserItem(user: state.users[index]);
        },
      ),
    );
  }
}
