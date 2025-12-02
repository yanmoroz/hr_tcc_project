import 'package:flutter_html/flutter_html.dart';

/// Common HTML element styles to prevent font family from being overridden by deeper nodes.
///
/// This constant provides consistent styling for HTML content rendered across the app,
/// ensuring SF Pro Display font is applied to all common HTML elements.
final Map<String, Style> commonHtmlElementStyles = {
  "p": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
  "div": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
  "span": Style(),
  "strong": Style(),
  "b": Style(),
  "em": Style(),
  "i": Style(),
};
