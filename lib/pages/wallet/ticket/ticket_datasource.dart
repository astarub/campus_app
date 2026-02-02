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
      'date_issued': '',
    };

    // Load the user's credentials
    final String? loginId = await secureStorage.read(key: 'loginId');
    final String? password = await secureStorage.read(key: 'password');

    Timer? loginTimer;

    if (loginId != null && password != null) {
      // Create a headless web view
      HeadlessInAppWebView? headlessWebView;

      // centralize dispose calls and guard against dispose being called on a disposed webview
      bool webViewDisposed = false;

      Future<void> webDispose() async {
        if (webViewDisposed == true) return;
        try {
          await headlessWebView?.dispose();
          webViewDisposed = true;
        } catch (e) {
          debugPrint('Semesterticket: Failed to dispose webview!');
        }
      }

      headlessWebView = HeadlessInAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(rideTicketing)),
        initialSettings: InAppWebViewSettings(cacheEnabled: false, clearCache: true),
        onWebViewCreated: (controller) {
          // Callback handler for the ticket
          controller.addJavaScriptHandler(
            handlerName: 'ticket',
            callback: (args) {
              /* Important to understand:
                  args = [document.getElementsByClassName("barcode")[0].src, arr] with args[0] image source and args[1]/arr ticket details
              */
              //Sanity Check Completer
              if (completer.isCompleted == true) {
                webDispose();
                return;
              }

              if (args.length < 2 || args.isEmpty || args[1] is! List || List.of(args[1]).isEmpty) {
                if (!completer.isCompleted) {
                  completer.completeError('Invalid ticket details');
                  webDispose();
                  return; //don't let an invalid ticket continue filling information
                }
                webDispose();
                return;
              }

              // debugging prints to check args validity, currently args is often missing the ticket details
              // (Prints will be removed after degugging the issue)
              final partialargs = args[1];
              final len = args[1].length;
              debugPrint('-------------!!!! Full args: $args');
              debugPrint('-------------!!!! Details: $partialargs');
              debugPrint('--------------!!!!!! Details length: $len');

              final List<dynamic> arguments = List.of(args)[1];
              final String image = List<dynamic>.from(args)[0].toString().split(',')[1];

              ticket['aztec_code'] = image;

              if (arguments.length == 6) {
                //changing to 6 since this is the amount of details currently pulled + correct assignments
                ticket['valid_from'] = arguments[0];
                ticket['valid_till'] = arguments[1];
                ticket['date_issued'] = arguments[2];
                ticket['validity_region'] = arguments[3];
                ticket['owner'] = arguments[4];
                ticket['birthdate'] = arguments[5];
              } else {
                // if the details aren't there, complete with error ideally
                if (!completer.isCompleted) {
                  completer.completeError('Invalid ticket details!');
                  webDispose();
                  return;
                }
                debugPrint(
                  'Invalid ticket details: $arguments and completer is already completed: ${completer.isCompleted}',
                );
                webDispose();
                return;
              }

              debugPrint('Loaded semesterticket.');

              if (!completer.isCompleted) completer.complete(ticket);
              webDispose();
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

              if (!completer.isCompleted) completer.completeError(args[0]);
              webDispose();
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
                const cards = document.getElementsByClassName("abo-card-wrapper");
                if (cards.length > 0) cards[0].click();
              }, 100);
              
              // variable to count successful ticket info pulls
              let success = 0;

              const ticketInfoInterval = setInterval(function(){
                if(document.URL.startsWith("https://abo.ride-ticketing.de/app/ticket")) {
                  clearInterval(ticketClickInterval);
                  const ticket_details = document.getElementsByClassName("value-column");
                  const arr = [];
                  for(const detail of ticket_details) {
                    arr.push(detail.innerText.trim());
                  }

                  let emptyItem = false;

                  //checking if a text item was loaded empty, if yes we wait for next interval
                  for (const item of arr) {
                    if (item === ''){
                    emptyItem = true;
                    }
                  }
                  
                  //check if our pull was a success, at least 4 items and not empty items
                  if (arr.length >= 6 && emptyItem == false) {
                    success++;
                  } else {
                    success = 0;
                  }

                  // fire handler ater 2 successful pulls -> stability check
                  if(success >= 2) {
                    clearInterval(ticketInfoInterval); // stop pulling
                    window.flutter_inappwebview.callHandler('ticket', document.getElementsByClassName("barcode")[0].src, arr);
                  }
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
          if (!completer.isCompleted) completer.completeError('Could not open ticket page.');
          await webDispose();
        }
      });
    } else {
      if (!completer.isCompleted) completer.completeError('No login credentials found.');
    }

    return completer.future;
  }
}
