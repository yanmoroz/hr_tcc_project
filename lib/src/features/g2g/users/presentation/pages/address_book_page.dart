import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

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
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Column(
        children: [
          const UserProfileHeader(enableCorners: false),
          Expanded(
            child: BlocBuilder<AddressBookBloc, AddressBookState>(
              builder: (context, state) {
                return switch (state.status) {
                  LoadingStatus.initial => _buildLoadingState(),
                  LoadingStatus.loading => _buildLoadingState(),
                  LoadingStatus.error => _buildErrorState(context),
                  LoadingStatus.success => _buildLoadedState(context, state),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Shimmer.fromColors(
                baseColor: AppColors.grey200,
                highlightColor: AppColors.grey100,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(height: 40, width: double.infinity),
                ),
              ),
            ),
          ),
          SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: AppColors.grey200,
                highlightColor: AppColors.grey100,
                child: Container(
                  width: double.infinity,
                  height: 175,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: 10,
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return NetworkErrorMessageWidget(
      onRetry: () => context.read<AddressBookBloc>().add(
        const AddressBookEvent.loadAddressBook(),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, AddressBookState state) {
    return Container(
      color: AppColors.grey100,
      child: Column(
        children: [
          // Search bar
          Container(
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SearchBarWidget(
                hintText: 'Поиск',
                isLoading: state.filteringStatus == LoadingStatus.loading,
                onSearchChanged: (query) {
                  context.read<AddressBookBloc>().add(
                    AddressBookEvent.searchAddressBook(query: query),
                  );
                },
              ),
            ),
          ),
          // Content area or filtering error
          Expanded(
            child: switch (state.filteringStatus) {
              LoadingStatus.error => NetworkErrorMessageWidget(
                onRetry: () => context.read<AddressBookBloc>().add(
                  AddressBookEvent.searchAddressBook(
                    query: state.searchQuery ?? '',
                  ),
                ),
              ),
              _ => _buildUsersList(context, state),
            },
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 28),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                controller: _scrollController,
                itemCount: state.users.length + (state.isLoadingMore ? 1 : 0),
                separatorBuilder: (context, index) => const SizedBox(height: 8),
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
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
