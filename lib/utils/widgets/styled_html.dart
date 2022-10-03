import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

/// This widget extends the default HTML widget and add a custom style.
/// Should be used when HTML data has to displayed on the screen. So we
/// can sytle all HTML elements equal.
///
/// It also implements a redirect to other apps if there are links inside the
/// HTML, for example a mailto:<url> href.
class StyledHTML extends Html {
  final String text;
  final TextStyle? textStyle;
  final TextAlign? textAlign;

  StyledHTML({
    Key? key,
    required this.text,
    this.textStyle,
    this.textAlign,
  }) : super(
          key: key,
          data: text,
          style: {
            'h4': Style(
              fontSize: const FontSize(17),
            ),
            '*': Style(
              color: textStyle?.color ?? const Color.fromARGB(255, 129, 129, 129),
              fontWeight: textStyle?.fontWeight ?? FontWeight.w500,
              letterSpacing: textStyle?.letterSpacing,
              backgroundColor: textStyle?.backgroundColor,
              fontStyle: textStyle?.fontStyle,
              fontFamily: textStyle?.fontFamily,
              height: textStyle?.height,
              wordSpacing: textStyle?.wordSpacing,
              textAlign: textAlign,
              fontSize: textStyle?.fontSize == null ? null : FontSize(textStyle?.fontSize),
            ),
          },
          onLinkTap: (url, context, attributes, element) => openURL(url.toString()),
        );

  /// Opens a url either in webview or external application e.g. mail app
  static Future<void> openURL(
    String url, {
    bool webView = false,
  }) async {
    String _url = url;

    // If a RUB news article refers to another RUB news article, than we
    // have to add a leading https://news.rub.de/
    if (url.startsWith(RegExp('/'))) {
      _url = url.replaceFirst(RegExp('/'), 'https://news.rub.de/');
    }

    final uri = Uri.parse(_url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        // LaunchMode.platformDefault: On iOS and Android, this treats web URLs as
        // LaunchMode.inAppWebView and all other URLs as LaunchMode.externalApplication.
        mode: webView ? LaunchMode.platformDefault : LaunchMode.externalApplication,
      );
    }
  }
}
