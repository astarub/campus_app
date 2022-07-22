import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class DioUtils {
  final Dio client;
  final CookieJar cookieJar;

  DioUtils({
    required this.client,
    required this.cookieJar,
  });

  void init() {
    // Dio cookie managment (store cookies in RAM)
    client.interceptors.add(CookieManager(cookieJar));

    // some RUB certificates are not valid
    (client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  void configure({
    int connectTimeout = 5000,
    int receiveTimeout = 3000,
    String? baseUrl,
  }) {
    // Dio timeout options
    client.options.connectTimeout = connectTimeout;
    client.options.receiveTimeout = receiveTimeout;

    // set baseUrl when given
    if (baseUrl != null) {
      client.options.baseUrl = baseUrl;
    }
  }

  // ignore: avoid_void_async
  void setCookieForRequest(String uri, List<Cookie> cookies) async {
    await cookieJar.saveFromResponse(Uri.parse(uri), cookies);
  }

  // ignore: avoid_void_async
  void printCookies(String uri) async {
    print(await cookieJar.loadForRequest(Uri.parse(uri)));
  }
}
