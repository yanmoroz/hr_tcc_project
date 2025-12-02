import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../news/presentation/blocs/news_page/bloc.dart';
import '../../../../users/presentation/widgets/user_profile_header.dart';
import '../widgets/menu_section.dart';
import '../widgets/news_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Column(
        children: [
          const UserProfileHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<NewsListBloc, NewsListState>(
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
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 16),
          MenuSection(),
          SizedBox(height: 24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: AppColors.grey200,
              highlightColor: AppColors.grey100,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        MenuSection(),
        Expanded(
          child: NetworkErrorMessageWidget(
            onRetry: () => context.read<NewsListBloc>().add(
              const NewsListEvent.loadNews(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadedState(BuildContext context, NewsListState state) {
    return AppRefreshIndicator(
      onRefresh: () async {
        context.read<NewsListBloc>().add(const NewsListEvent.loadNews());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 16),
            MenuSection(),
            SizedBox(height: 24),
            NewsSection(newsItems: state.newsItems),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
