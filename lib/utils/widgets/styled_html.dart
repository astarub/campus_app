import 'package:campus_app/core/settings.dart';
import 'package:campus_app/pages/more/in_app_web_view_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// This widget extends the default HTML widget and add a custom style.
/// Should be used when HTML data has to displayed on the screen. So we
/// can sytle all HTML elements equal.
///
/// It also implements a redirect to other apps if there are links inside the
/// HTML, for example a mailto:<url> href.
class StyledHTML extends Html {
  final BuildContext context;
  final String text;
  final TextStyle? textStyle;
  final TextAlign? textAlign;

  StyledHTML({
    Key? key,
    required this.context,
    required this.text,
    this.textStyle,
    this.textAlign,
  }) : super(
          key: key,
          data: text,
          style: {
            'h4': Style(
              fontSize: FontSize(17),
            ),
            '*': Style(
              color:
                  textStyle?.color ?? Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium?.color,
              fontWeight: textStyle?.fontWeight ?? FontWeight.w500,
              letterSpacing: textStyle?.letterSpacing ?? 0.2,
              backgroundColor: textStyle?.backgroundColor,
              fontStyle: textStyle?.fontStyle,
              fontFamily: textStyle?.fontFamily,
              height: textStyle?.height != null ? Height(textStyle!.height!) : null,
              wordSpacing: textStyle?.wordSpacing,
              textAlign: textAlign,
              fontSize: textStyle?.fontSize == null ? null : FontSize(textStyle!.fontSize!),
            ),
          },
          onLinkTap: (url, renderContext, element) => openURL(context, url.toString()),
        );

  /// Opens a url either in webview or external application e.g. mail app
  static void openURL(
    BuildContext context,
    String url,
  ) {
    String _url = url;

    // If a RUB news article refers to another RUB news article, than we
    // have to add a leading https://news.rub.de/
    if (url.startsWith(RegExp('/'))) {
      _url = url.replaceFirst(RegExp('/'), 'https://news.rub.de/');
    }

    final uri = Uri.parse(_url);

    // Enforces to open social links in external browser to let the system handle these
    // and open designated apps, if installed
    if (Provider.of<SettingsHandler>(context, listen: false).currentSettings.useExternalBrowser ||
        url.contains('instagram') ||
        url.contains('facebook') ||
        url.contains('twitch') ||
        url.contains('mailto:') ||
        url.contains('tel:')) {
      // Open in external browser
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Open in InAppView
      Navigator.push(context, MaterialPageRoute(builder: (context) => InAppWebViewPage(url: url)));
    }
  }
}
