import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/base_types/loading_status.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../news/presentation/blocs/news_page/bloc.dart';
import '../../../users/presentation/widgets/user_profile_header.dart';
import '../widgets/home_icon_button.dart';
import '../widgets/home_news_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F6),
      body: Column(
        children: [
          const UserProfileHeader(),
          _HomeIconButtonsRow(onLaunchUrl: _launchUrl),
          Expanded(
            child: BlocBuilder<NewsListBloc, NewsListState>(
              builder: (context, state) {
                if (state.status == LoadingStatus.loading ||
                    state.status == LoadingStatus.initial) {
                  return const Center(child: AppProgressIndicator());
                }

                if (state.status == LoadingStatus.error) {
                  return NetworkErrorMessageWidget(
                    onRetry: () => context
                        .read<NewsListBloc>()
                        .add(const NewsListEvent.loadNews()),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const HomeNewsSection(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeIconButtonsRow extends StatelessWidget {
  final Future<void> Function(String) onLaunchUrl;

  const _HomeIconButtonsRow({required this.onLaunchUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          HomeIconButton(
            iconPath: Assets.icons.telegramIcon,
            label: 'Телеграм-\nканал S8',
            onTap: () => onLaunchUrl('http://telegram.org'),
          ),
          HomeIconButton(
            iconPath: Assets.icons.discountsIcon,
            label: 'Льготы\nи возмож...',
            onTap: () => context.push('/home/discount-categories'),
          ),
          HomeIconButton(
            iconPath: Assets.icons.pollsIcon,
            label: 'Опросы',
            onTap: () => context.push('/home/polls'),
          ),
          HomeIconButton(
            iconPath: Assets.icons.resellIcon,
            label: 'Ресейл',
            onTap: () => context.push('/home/resell'),
          ),
          HomeIconButton(
            iconPath: Assets.icons.s8Icon,
            label: 'ИТ-портал',
            onTap: () => onLaunchUrl('https://s8.capital'),
          ),
        ],
      ),
    );
  }
}
