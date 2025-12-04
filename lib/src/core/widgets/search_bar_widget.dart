import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';
import '../theme/theme.dart';
import 'app_progress_indicator.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final String hintText;
  final int debounceMilliseconds;
  final bool isLoading;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Поиск',
    this.debounceMilliseconds = 300,
    required this.onSearchChanged,
    this.isLoading = false,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onSearchChanged,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        labelStyle: AppTypography.textRegular1.black,
        hintText: widget.hintText,
        hintStyle: AppTypography.textRegular1.grey500,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: SvgPicture.asset(Assets.icons.searchIcon),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 20,
          minHeight: 20,
        ),
        suffixIcon: widget.isLoading
            ? const Padding(
                padding: EdgeInsets.only(left: 12, right: 8),
                child: AppProgressIndicator(radius: 8, strokeWidth: 2),
              )
            : _controller.text.isNotEmpty
            ? GestureDetector(
                onTap: _clearSearch,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: SvgPicture.asset(Assets.icons.closeIcon),
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 24,
          minHeight: 24,
        ),
        filled: true,
        fillColor: AppColors.grey100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        isDense: true,
        contentPadding: const EdgeInsets.all(8),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearchChanged('');
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: widget.debounceMilliseconds), () {
      widget.onSearchChanged(query);
    });
  }
}
