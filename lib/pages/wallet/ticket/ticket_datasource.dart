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

    final Map<String, dynamic> ticket = {
      'barcode': '',
      'valid_from': '',
      'valid_till': '',
      'validity_region': '',
      'owner': '',
      'birthdate': '',
    };

    final String? loginId = await secureStorage.read(key: 'loginId');
    final String? password = await secureStorage.read(key: 'password');

    if (loginId != null && password != null) {
      HeadlessInAppWebView? headlessWebView;
      headlessWebView = HeadlessInAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(rideTicketing)),
        initialSettings: InAppWebViewSettings(cacheEnabled: false, clearCache: true),
        onWebViewCreated: (controller) {
          controller.addJavaScriptHandler(
            handlerName: 'barcode',
            callback: (args) {
              if (args.isNotEmpty && args[0] is String) {
                final String image = List<String>.from(args)[0].split(',')[1];

                ticket['barcode'] = image;
              }
            },
          );

          controller.addJavaScriptHandler(
            handlerName: 'ticket_details',
            callback: (args) {
              if (args.isEmpty || List.of(args)[0] is! List || List.of(args[0]).length != 4) {
                completer.completeError('Invalid ticket details');
              }

              final List<dynamic> arguments = List.of(args)[0];

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

          controller.addJavaScriptHandler(
            handlerName: 'error',
            callback: (args) {
              debugPrint('An error occurred. Error: $args');

              completer.completeError(args[0]);
              headlessWebView!.dispose();
            },
          );
        },
        onLoadStop: (controller, url) async {
          if (url.toString().startsWith('https://aai.ruhr-uni-bochum.de/idp/profile/SAML2/POST/SSO') &&
              url.toString().endsWith('s1')) {
            Timer(const Duration(milliseconds: 300), () async {
              await controller.evaluateJavascript(
                source: """
                document.getElementById('username').value="$loginId";
                document.getElementById('password').value="$password";
                setTimeout(function(){
                  document.getElementById('shibbutton').click();
                }, 500);
                """,
              );
            });
          } else if (url.toString().startsWith('https://aai.ruhr-uni-bochum.de/idp/profile/SAML2/POST/SSO') &&
              url.toString().endsWith('s2')) {
            await controller.evaluateJavascript(
              source: """
              if(document.getElementsByClassName("form-error").length == 1) {
                window.flutter_inappwebview.callHandler('error', "Invalid credentials.");
              }
              setTimeout(function(){
                document.getElementById('consentbutton_2').click();
              }, 500);
              """,
            );
          } else if (url.toString().startsWith('https://abo.ride-ticketing.de')) {
            await controller.evaluateJavascript(
              source: '''
              setTimeout(function(){
                document.getElementsByClassName("abo-card-wrapper")[0].click();
              }, 1000);
              ''',
            );
            await controller.evaluateJavascript(
              source: '''
              setTimeout(function(){
                if(!document.URL.startsWith("https://abo.ride-ticketing.de/app/ticket")) {
                  window.flutter_inappwebview.callHandler('error', "Could not open ticket page.");
                  return;
                }
                window.flutter_inappwebview.callHandler('stateChange', "ticketPage");

                window.flutter_inappwebview.callHandler('barcode', document.getElementsByClassName("barcode")[0].src);

                const ticket_details = document.getElementsByClassName("value-column");
                const arr = [];

                for(const detail of ticket_details) {
                  arr.push(detail.innerText);
                }

                window.flutter_inappwebview.callHandler('ticket_details', arr);
              }, 2500);
              ''',
            );
          }
        },
      );

      await headlessWebView.run();

      Timer(const Duration(seconds: 15), () async {
        if (headlessWebView != null) {
          await headlessWebView.dispose();
        }
      });
    } else {
      completer.completeError('No login credentials found.');
    }

    return completer.future;
  }
}
