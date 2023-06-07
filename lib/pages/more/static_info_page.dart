import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';

/// This page displays static information, optionally in an InAppWebView
class StaticInfoPage extends StatefulWidget {
  /// The page title that is displayed above the content
  final String title;

  /// The content that is displayed on the page
  final String? content;

  /// When the content that should be displayed is outside the app,
  /// an [InAppWebView] with the given url is shown.
  final String? url;

  const StaticInfoPage({
    Key? key,
    required this.title,
    required this.content,
    this.url = '',
  }) : super(key: key);

  const StaticInfoPage.external({
    Key? key,
    required this.title,
    this.content = '',
    required this.url,
  }) : super(key: key);

  @override
  State<StaticInfoPage> createState() => _StaticInfoPageState();
}

class _StaticInfoPageState extends State<StaticInfoPage> {
  InAppWebViewController? webViewController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      verticalScrollBarEnabled: false,
      horizontalScrollBarEnabled: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            // Back button & page title
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    CampusIconButton(
                      iconPath: 'assets/img/icons/arrow-left.svg',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Align(
                      child: Text(
                        widget.title,
                        style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding:
                    widget.content != '' ? const EdgeInsets.only(bottom: 20, left: 20, right: 20) : EdgeInsets.zero,
                child: widget.content != ''
                    ? Text(
                        widget.content!,
                        style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                      )
                    : InAppWebView(
                        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
                          ..add(const Factory<VerticalDragGestureRecognizer>(VerticalDragGestureRecognizer.new)),
                        initialOptions: options,
                        initialUrlRequest: URLRequest(url: Uri.parse(widget.url!)),
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
