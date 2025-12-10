import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../news/presentation/blocs/news_page/bloc.dart';
import '../../../users/presentation/presentation.dart';
import '../widgets/news_section.dart';
import '../widgets/quick_link_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: BlocBuilder<NewsListBloc, NewsListState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _ShadowedUserBarDelegate(extent: 56.0),
              ),
              SliverRefreshControl(
                onRefresh: () async {
                  context.read<NewsListBloc>().add(
                    const NewsListEvent.loadNews(),
                  );
                },
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: switch (state.status) {
                  LoadingStatus.initial => _buildLoadingState(),
                  LoadingStatus.loading => _buildLoadingState(),
                  LoadingStatus.error => _buildErrorState(context),
                  LoadingStatus.success => _buildLoadedState(state),
                  // _ => _buildLoadingState(),
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: 16),
          sliver: const SliverToBoxAdapter(child: QuickLinkBar()),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: NetworkErrorMessageWidget(
            onRetry: () => context.read<NewsListBloc>().add(
              const NewsListEvent.loadNews(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadedState(NewsListState state) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      sliver: SliverList.separated(
        itemCount: 2,
        itemBuilder: (context, index) {
          if (index == 0) return const QuickLinkBar();
          return NewsSection(newsItems: state.newsItems);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 24),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: 16),
          sliver: const SliverToBoxAdapter(child: QuickLinkBar()),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        SliverShimmeringList(spacing: 12, maxHeight: 150),
      ],
    );
  }
}

class _ShadowedUserBarDelegate extends SliverPersistentHeaderDelegate {
  final double extent;

  _ShadowedUserBarDelegate({required this.extent});

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return const UserInfoBar(enableCorners: true, showShadow: true);
  }

  @override
  bool shouldRebuild(covariant _ShadowedUserBarDelegate oldDelegate) => false;
}
