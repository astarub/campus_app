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

  Future<Map<String, dynamic>> getTicket() async {
    final Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();

    final Map<String, dynamic> ticket = {
      'barcode': '',
      'valid_from': '',
      'valid_till': '',
      'owner': '',
      'birthdate': '',
    };

    final String? loginId = await secureStorage.read(key: 'loginId');
    final String? password = await secureStorage.read(key: 'password');

    if (loginId == null || password == null) {
      return ticket;
    }

    HeadlessInAppWebView? headlessWebView;
    headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(rideTicketing)),
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
            if (args.isEmpty && args.length != 4) return;

            ticket['valid_from'] = args[0];
            ticket['valid_till'] = args[1];
            ticket['owner'] = args[2];
            ticket['birthdate'] = args[3];

            completer.complete(ticket);
            headlessWebView!.dispose();
          },
        );

        controller.addJavaScriptHandler(
          handlerName: 'error',
          callback: (args) {
            debugPrint('An error occurred. Error: $args');

            completer.completeError(args);
            headlessWebView!.dispose();
          },
        );

        controller.addJavaScriptHandler(
          handlerName: 'dispose',
          callback: (args) {
            headlessWebView!.dispose();
          },
        );
      },
      onLoadStop: (controller, url) async {
        if (url.toString().startsWith('https://aai.ruhr-uni-bochum.de/idp/profile/SAML2/POST/SSO') &&
            url.toString().endsWith('s1')) {
          await controller.evaluateJavascript(
            source: """
              document.getElementById('username').value="${await secureStorage.read(key: 'loginID')}";
              document.getElementById('password').value="";
              setTimeout(function(){
                document.getElementById('shibbutton').click();
              }, 500);
              """,
          );
        } else if (url.toString().startsWith('https://aai.ruhr-uni-bochum.de/idp/profile/SAML2/POST/SSO') &&
            url.toString().endsWith('s2')) {
          await controller.evaluateJavascript(
            source: """
              setTimeout(function(){
                document.getElementById('consentbutton_2').click();
              }, 500);
              """,
          );
        } else {
          await controller.evaluateJavascript(
            source: '''
              setTimeout(function(){
                if(!document.URL.startsWith("https://abo.ride-ticketing.de/app/subscription")) {
                  window.flutter_inappwebview.callHandler('error', "Ride ticketing not opened.");
                  return;
                }
                document.getElementsByClassName("abo-card-wrapper")[0].click();
              }, 1000);
              ''',
          );
          await controller.evaluateJavascript(
            source: '''
              setTimeout(function(){
                if(!document.URL.startsWith("https://abo.ride-ticketing.de/app/ticket")) {
                  window.flutter_inappwebview.callHandler('test', "Could not open ticket page.");
                  return;
                }
                window.flutter_inappwebview.callHandler('barcode', document.getElementsByClassName("barcode")[0].src);

                const ticket_details = document.getElementsByClassName("value-column");
                const arr = [];

                for(const detail of ticket_details) {
                  arr.push(detail.innerText);
                }

                window.flutter_inappwebview.callHandler('ticket_details', arr);
              }, 1500);
              ''',
          );

          // Fallback to ensure that the headless web view is always disposed, even if the ticket cannot be fetched.
          await controller.evaluateJavascript(
            source: '''
              setTimeout(function(){
                window.flutter_inappwebview.callHandler('dispose', '');
              }, 10000);
              ''',
          );
        }
      },
    );

    return completer.future;
  }
}
