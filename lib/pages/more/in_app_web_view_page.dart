import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/main.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// This page shows an [InAppWebView] in order to display external
/// websites from the helpful ressources that are not yet natively implemented
class InAppWebViewPage extends StatefulWidget {
  /// The url that should be opened
  final String url;

  const InAppWebViewPage({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  InAppWebViewController? webViewController;
  late PullToRefreshController pullToRefreshController;

  InAppWebViewSettings settings = InAppWebViewSettings(
    mediaPlaybackRequiresUserGesture: false,
    verticalScrollBarEnabled: false,
    horizontalScrollBarEnabled: false,
    allowsInlineMediaPlayback: true,
    useHybridComposition: false,
  );

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: Colors.black),
      onRefresh: () async {
        if (Platform.isAndroid) {
          await webViewController?.reload();
        } else if (Platform.isIOS) {
          await webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (await webViewController!.canGoBack()) {
          await webViewController?.goBack();
        } else {
          if (homeKey.currentState != null) {
            homeKey.currentState!.setSwipeDisabled();
          }
          navigator.pop();
        }
      },
      child: VisibilityDetector(
        onVisibilityChanged: (info) {
          final bool isVisible = info.visibleFraction > 0;

          if (isVisible) {
            if (homeKey.currentState != null) {
              homeKey.currentState!.setSwipeDisabled(disableSwipe: true);
            }
          }
        },
        key: const Key('visibility-key'),
        child: Scaffold(
          backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
          body: SafeArea(
            child: Stack(
              children: [
                InAppWebView(
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
                    ..add(const Factory<VerticalDragGestureRecognizer>(VerticalDragGestureRecognizer.new)),
                  pullToRefreshController: pullToRefreshController,
                  initialSettings: settings,
                  initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //backbutton
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: CampusIconButton(
                        iconPath: 'assets/img/icons/arrow-left.svg',
                        onTap: () {
                          Navigator.maybePop(context);
                        },
                      ),
                    ),
                    //closeButton
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 20),
                      child: CampusIconButton(
                        iconPath: 'assets/img/icons/x.svg',
                        onTap: () {
                          webViewController?.clearHistory();
                          Navigator.maybePop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
