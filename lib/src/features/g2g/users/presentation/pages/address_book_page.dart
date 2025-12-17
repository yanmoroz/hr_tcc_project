import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../blocs/address_book/bloc.dart';
import '../delegates/address_book_header_delegate.dart';
import '../widgets/address_book_user_item.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({super.key});

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  final ScrollController _scrollController = ScrollController();

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.grey100,
        body: BlocBuilder<AddressBookBloc, AddressBookState>(
          builder: (context, state) {
            return CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: AddressBookHeaderDelegate(
                    userBarExtent: 48.0,
                    searchBarExtent: 64.0,
                    searchBarMinHeight: 8.0,
                    state: state,
                    onSearchChanged: (query) {
                      context.read<AddressBookBloc>().add(
                        AddressBookEvent.searchAddressBook(query: query),
                      );
                    },
                  ),
                ),
                SliverRefreshControl(
                  onRefresh: () async {
                    context.read<AddressBookBloc>().add(
                      const AddressBookEvent.refreshAddressBook(),
                    );
                  },
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: switch (state.status) {
                    LoadingStatus.initial => _buildLoadingState(),
                    LoadingStatus.loading => _buildLoadingState(),
                    LoadingStatus.error => _buildErrorState(context),
                    LoadingStatus.success => _buildLoadedState(context, state),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Widget _buildErrorState(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: NetworkErrorMessageWidget(
        onRetry: () => context.read<AddressBookBloc>().add(
          const AddressBookEvent.loadAddressBook(),
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, AddressBookState state) {
    return switch (state.filteringStatus) {
      LoadingStatus.error => _buildErrorState(context),
      _ => _buildUsersList(context, state),
    };
  }

  Widget _buildLoadingState() {
    return SliverMainAxisGroup(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
        SliverShimmeringList(spacing: 12, maxHeight: 175),
      ],
    );
  }

  Widget _buildUsersList(BuildContext context, AddressBookState state) {
    if (state.users.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            'Таких сотрудников нет',
            style: AppTypography.textRegular1.black,
          ),
        ),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
        SliverList.separated(
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
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<AddressBookBloc>().add(
        const AddressBookEvent.loadMoreAddressBook(),
      );
    }
  }
}
