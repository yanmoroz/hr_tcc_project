import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    required this.onSearchChanged,
    this.hintText = 'Поиск',
    this.debounceMilliseconds = 300,
    super.key,
  });

  final ValueChanged<String> onSearchChanged;
  final String hintText;
  final int debounceMilliseconds;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: widget.debounceMilliseconds), () {
      widget.onSearchChanged(query);
    });
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: _controller,
        onChanged: _onSearchChanged,
        autocorrect: false,
        enableSuggestions: false,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: const Color(0xFFBABABE),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: SvgPicture.asset(
              Assets.icons.searchIcon,
              width: 20,
              height: 20,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 20,
            minHeight: 20,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: _clearSearch,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: SvgPicture.asset(
                      Assets.icons.crossIcon,
                      width: 20,
                      height: 20,
                    ),
                  ),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 20,
            minHeight: 20,
          ),
          filled: true,
          fillColor: const Color(0xFFF2F2F6),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
