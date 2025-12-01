import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'search_bar_widget.dart';

/// A standardized search bar with consistent padding.
///
/// Wraps [SearchBarWidget] with standard horizontal padding (16px)
/// and vertical padding (8px).
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.backgroundColor = AppColors.white,
    this.hintText = 'Поиск',
    this.isLoading = false,
    this.debounceMilliseconds = 300,
    required this.onSearchChanged,
  });

  /// Background color of the search bar.
  final Color backgroundColor;

  /// Placeholder text shown when the search field is empty.
  final String hintText;

  /// Whether to show a loading indicator in the suffix area.
  final bool isLoading;

  /// Debounce delay in milliseconds before triggering [onSearchChanged].
  final int debounceMilliseconds;

  /// Called when the search query changes (debounced).
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: SearchBarWidget(
          hintText: hintText,
          isLoading: isLoading,
          debounceMilliseconds: debounceMilliseconds,
          onSearchChanged: onSearchChanged,
        ),
      ),
    );
  }
}
