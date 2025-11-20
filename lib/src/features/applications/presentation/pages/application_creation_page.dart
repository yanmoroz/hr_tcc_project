import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/entities/application_form.dart';
import '../../../../core/entities/application_form_group.dart';
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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<ApplicationCreationBloc, ApplicationCreationState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded:
                (
                  allForms,
                  groups,
                  filteredForms,
                  selectedGroupId,
                  searchQuery,
                ) {
                  return Column(
                    children: [
                      const SizedBox(height: 8),

                      // Filter tabs - optimized with BlocSelector
                      BlocSelector<
                        ApplicationCreationBloc,
                        ApplicationCreationState,
                        _FilterTabsState
                      >(
                        selector: (state) {
                          return state.maybeWhen(
                            loaded:
                                (allForms, groups, _, selectedGroupId, __) =>
                                    _FilterTabsState(
                                      groups: groups,
                                      allForms: allForms,
                                      selectedGroupId: selectedGroupId,
                                    ),
                            orElse: () => const _FilterTabsState(
                              groups: [],
                              allForms: [],
                              selectedGroupId: null,
                            ),
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
                                selectedGroupId:
                                    filterTabsState.selectedGroupId,
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
                                return state.maybeWhen(
                                  loaded: (_, __, ___, ____, _____) =>
                                      const _SearchBarState(),
                                  orElse: () => const _SearchBarState(),
                                );
                              },
                              builder: (context, searchBarState) {
                                return SearchBarWidget(
                                  hintText: 'Наименование заявки',
                                  onSearchChanged: (query) {
                                    context.read<ApplicationCreationBloc>().add(
                                      ApplicationCreationEvent.searchForms(
                                        query,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                      ),

                      // Forms list
                      if (filteredForms.isEmpty)
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
                            itemCount: filteredForms.length,
                            itemBuilder: (context, index) {
                              final form = filteredForms[index];
                              return ApplicationFormItem(
                                applicationForm: form,
                                onTap: () {
                                  context.push(
                                    '/application-form/${form.code}',
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
            error: (message) => Center(
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
                      message,
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
            ),
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
