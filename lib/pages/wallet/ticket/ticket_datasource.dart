import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:campus_app/utils/constants.dart';

class TicketDataSource {
  final FlutterSecureStorage secureStorage;

  TicketDataSource({
    required this.secureStorage,
  });

  Future<Map<String, dynamic>> getRemoteTicket() async {
    debugPrint('Loading semester ticket');

    final Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();

    // Define empty ticket
    final Map<String, dynamic> ticket = {
      'aztec_code': '',
      'valid_from': '',
      'valid_till': '',
      'validity_region': '',
      'owner': '',
      'birthdate': '',
    };

    // Load the user's credentials
    final String? loginId = await secureStorage.read(key: 'loginId');
    final String? password = await secureStorage.read(key: 'password');

    Timer? loginTimer;

    if (loginId != null && password != null) {
      // Create a headless web view
      HeadlessInAppWebView? headlessWebView;
      headlessWebView = HeadlessInAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(rideTicketing)),
        initialSettings: InAppWebViewSettings(cacheEnabled: false, clearCache: true),
        onWebViewCreated: (controller) {
          // Callback handler for the ticket
          controller.addJavaScriptHandler(
            handlerName: 'ticket',
            callback: (args) {
              if (args.isEmpty || List.of(args)[1] is! List || List.of(args[1]).isEmpty) {
                completer.completeError('Invalid ticket details');
              }

              final List<dynamic> arguments = List.of(args)[1];
              final String image = List<dynamic>.from(args)[0].toString().split(',')[1];

              ticket['aztec_code'] = image;

              if (arguments.length == 4) {
                ticket['valid_from'] = arguments[0];
                ticket['valid_till'] = arguments[1];
                ticket['owner'] = arguments[2];
                ticket['birthdate'] = arguments[3];
              } else {
                ticket['valid_from'] = arguments[0];
                ticket['valid_till'] = arguments[1];
                ticket['validity_region'] = arguments[2];
                ticket['owner'] = arguments[3];
                ticket['birthdate'] = arguments[4];
              }

              debugPrint('Loaded semesterticket.');

              completer.complete(ticket);
              headlessWebView!.dispose();
            },
          );

          // Error handler
          controller.addJavaScriptHandler(
            handlerName: 'error',
            callback: (args) {
              debugPrint('An error occurred. Error: $args');

              if (loginTimer != null) {
                loginTimer!.cancel();
              }

              completer.completeError(args[0]);
              headlessWebView!.dispose();
            },
          );
        },
        onLoadStop: (controller, uri) async {
          final String url = uri.toString();

          // Click through the RUB login and extract the ticket from the ticket portal
          if (url.startsWith('https://aai.ruhr-uni-bochum.de/idp/profile/SAML2/POST/SSO') && url.endsWith('s1')) {
            Timer(const Duration(milliseconds: 300), () async {
              await controller.evaluateJavascript(
                source: """
                document.getElementById('username').value="$loginId";
                document.getElementById('password').value="$password";
                setTimeout(function(){
                  document.getElementById('shibbutton').click();
                }, 100);
                """,
              );
            });
          } else if (url.startsWith('https://aai.ruhr-uni-bochum.de/idp/profile/SAML2/POST/SSO') &&
              url.endsWith('s2')) {
            Timer.periodic(const Duration(milliseconds: 100), (ti) async {
              loginTimer = ti;

              if (headlessWebView != null && headlessWebView.isRunning()) {
                await controller.evaluateJavascript(
                  source: """
                if(document.getElementsByClassName("form-error").length == 1) {
                  window.flutter_inappwebview.callHandler('error', "Invalid credentials.");
                }
                document.getElementById('consentbutton_2').click();
                """,
                );
              }
            });
          } else if (url.startsWith('https://abo.ride-ticketing.de')) {
            await controller.evaluateJavascript(
              source: '''
              const ticketClickInterval = setInterval(function(){
                document.getElementsByClassName("abo-card-wrapper")[0].click();
              }, 100);

              setInterval(function(){
                if(document.URL.startsWith("https://abo.ride-ticketing.de/app/ticket")) {
                  clearInterval(ticketClickInterval);
                  const ticket_details = document.getElementsByClassName("value-column");
                  const arr = [];
                  for(const detail of ticket_details) {
                    arr.push(detail.innerText);
                  }
                  window.flutter_inappwebview.callHandler('ticket', document.getElementsByClassName("barcode")[0].src, arr);
                } 
              }, 200);
              ''',
            );
          }
        },
      );

      await headlessWebView.run();

      // Fallback error handler, in case the webview hang up
      Timer(const Duration(seconds: 10), () async {
        if (loginTimer != null) {
          loginTimer!.cancel();
        }
        if (headlessWebView != null && headlessWebView.isRunning()) {
          if (headlessWebView.webViewController!.getUrl().toString().startsWith('https://abo.ride-ticketing.de')) {
            await headlessWebView.webViewController!.evaluateJavascript(
              source: '''
                const cardWrappers = document.getElementsByClassName("abo-card-wrapper");
                if(cardWrappers.length == 0) {
                  window.flutter_inappwebview.callHandler('error', "Ticket removed.");
                  return;
                }
              ''',
            );
          }
          completer.completeError('Could not open ticket page.');
          await headlessWebView.dispose();
        }
      });
    } else {
      completer.completeError('No login credentials found.');
    }

    return completer.future;
  }
}
