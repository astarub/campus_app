import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance; // service locator

Future<void> init() async {
  //! BloCs

  //! Usecases

  //! Repositories

  //! Datasources

  //! Utils

  //! External
  sl.registerLazySingleton(http.Client.new);
  sl.registerLazySingleton(FlutterSecureStorage.new);
  sl.registerLazySingleton(Dio.new);
  sl.registerLazySingleton(CookieJar.new);
}
