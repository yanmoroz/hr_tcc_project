import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/base_types/loading_status.dart';
import '../../../../core/entities/application_form.dart';
import '../../../../core/entities/application_form_group.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/search_bar_widget.dart';
import '../blocs/application_creation_page/bloc.dart';
import '../widgets/application_form_filter_tabs.dart';
import '../widgets/application_form_item.dart';

class ApplicationCreationPage extends StatelessWidget {
  const ApplicationCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание заявки'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: SvgPicture.asset(Assets.icons.closeIcon),
            onPressed: () {
              context.go('/applications');
            },
          ),
        ],
      ),
      body: BlocBuilder<ApplicationCreationBloc, ApplicationCreationState>(
        builder: (context, state) {
          if (state.status == LoadingStatus.loading ||
              state.status == LoadingStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == LoadingStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Color(0xFF757575),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ошибка загрузки',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.errorMessage ?? 'Unknown error',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ApplicationCreationBloc>().add(
                        const ApplicationCreationEvent.loadApplicationForms(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Filter tabs - optimized with BlocSelector
              Container(
                decoration: BoxDecoration(color: AppColors.white),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    BlocSelector<
                      ApplicationCreationBloc,
                      ApplicationCreationState,
                      _FilterTabsState
                    >(
                      selector: (state) {
                        if (state.status == LoadingStatus.success) {
                          return _FilterTabsState(
                            groups: state.groups,
                            allForms: state.allForms,
                            selectedGroupId: state.selectedGroupId,
                          );
                        }
                        return const _FilterTabsState(
                          groups: [],
                          allForms: [],
                          selectedGroupId: null,
                        );
                      },
                      builder: (context, filterTabsState) {
                        if (filterTabsState.groups.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          children: [
                            ApplicationFormFilterTabs(
                              groups: filterTabsState.groups,
                              allForms: filterTabsState.allForms,
                              selectedGroupId: filterTabsState.selectedGroupId,
                              onGroupChanged: (groupId) {
                                context.read<ApplicationCreationBloc>().add(
                                  ApplicationCreationEvent.filterByGroup(
                                    groupId,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),

                    // Search bar - optimized with BlocSelector
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child:
                          BlocSelector<
                            ApplicationCreationBloc,
                            ApplicationCreationState,
                            _SearchBarState
                          >(
                            selector: (state) {
                              return const _SearchBarState();
                            },
                            builder: (context, searchBarState) {
                              return SearchBarWidget(
                                hintText: 'Наименование заявки',
                                onSearchChanged: (query) {
                                  context.read<ApplicationCreationBloc>().add(
                                    ApplicationCreationEvent.searchForms(query),
                                  );
                                },
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ),

              // Forms list
              if (state.filteredForms.isEmpty)
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'Заявок не найдено',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: state.filteredForms.length,
                    itemBuilder: (context, index) {
                      final form = state.filteredForms[index];
                      return ApplicationFormItem(
                        applicationForm: form,
                        onTap: () {
                          context.push(
                            '/applications/form/${form.code}',
                            extra: form,
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// Helper classes for BlocSelector to prevent unnecessary rebuilds

class _SearchBarState {
  const _SearchBarState();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _SearchBarState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class _FilterTabsState {
  final List<ApplicationFormGroup> groups;
  final List<ApplicationForm> allForms;
  final String? selectedGroupId;

  const _FilterTabsState({
    required this.groups,
    required this.allForms,
    required this.selectedGroupId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _FilterTabsState &&
          runtimeType == other.runtimeType &&
          groups == other.groups &&
          allForms == other.allForms &&
          selectedGroupId == other.selectedGroupId;

  @override
  int get hashCode =>
      groups.hashCode ^ allForms.hashCode ^ selectedGroupId.hashCode;
}
