import 'package:flutter_html/flutter_html.dart';

import '../../../gen/fonts.gen.dart';

/// Common HTML element styles to prevent font family from being overridden by deeper nodes.
///
/// This constant provides consistent styling for HTML content rendered across the app,
/// ensuring SF Pro Display font is applied to all common HTML elements.
final Map<String, Style> commonHtmlElementStyles = {
  "p": Style(
    fontFamily: FontFamily.sFProDisplay,
    margin: Margins.zero,
    padding: HtmlPaddings.zero,
  ),
  "div": Style(
    fontFamily: FontFamily.sFProDisplay,
    margin: Margins.zero,
    padding: HtmlPaddings.zero,
  ),
  "span": Style(fontFamily: FontFamily.sFProDisplay),
  "strong": Style(fontFamily: FontFamily.sFProDisplay),
  "b": Style(fontFamily: FontFamily.sFProDisplay),
  "em": Style(fontFamily: FontFamily.sFProDisplay),
  "i": Style(fontFamily: FontFamily.sFProDisplay),
};
