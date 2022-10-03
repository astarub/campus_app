import 'package:campus_app/core/authentication/authentication_datasource.dart';
import 'package:campus_app/core/authentication/authentication_handler.dart';
import 'package:campus_app/core/authentication/authentication_repository.dart';
import 'package:campus_app/pages/calendar/calendar_datasource.dart';
import 'package:campus_app/pages/calendar/calendar_repository.dart';
import 'package:campus_app/pages/calendar/calendar_usecases.dart';
//import 'package:campus_app/pages/ecampus/bloc/ecampus_bloc.dart';
//import 'package:campus_app/pages/ecampus/ticket_datasource.dart';
//import 'package:campus_app/pages/ecampus/ticket_repository.dart';
import 'package:campus_app/pages/moodle/moodle_datasource.dart';
import 'package:campus_app/pages/moodle/moodle_repository.dart';
import 'package:campus_app/pages/moodle/moodle_usecases.dart';
import 'package:campus_app/pages/rubnews/rubnews_datasource.dart';
import 'package:campus_app/pages/rubnews/rubnews_repository.dart';
import 'package:campus_app/pages/rubnews/rubnews_usecases.dart';
import 'package:campus_app/utils/apis/forgerock_api.dart';
import 'package:campus_app/utils/dio_utils.dart';
import 'package:campus_app/utils/pages/calendar_utils.dart';
import 'package:campus_app/utils/pages/feed_utils.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance; // service locator

Future<void> init() async {
  //sl.registerFactory(() => EcampusBloc(ticketRepository: sl()));

  //! Datasources
  sl.registerSingletonAsync(
    () async => RubnewsDatasource(
      client: sl(),
      rubnewsCach: await Hive.openBox('rubnewsCach'),
    ),
  );
  sl.registerLazySingleton<CalendarRemoteDatasource>(
    () => CalendarRemoteDatasourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AuthenticationDatasource>(
    () => AuthenticationDatasourceImpl(
      client: sl(),
      dioUtils: sl(),
      storage: sl(),
      apiUtils: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => MoodleDatasource(client: sl()),
  );
  /*sl.registerLazySingleton(
    () => TicketDatasource(
      client: sl(),
      client2: sl(),
      dioUtils: sl(),
    ),
  );*/

  //! Handlers
  sl.registerLazySingleton(AuthenticationHandler.new);

  //! Datasources
  sl.registerLazySingleton<RubnewsRemoteDatasource>(
    () => RubnewsRemoteDatasourceImpl(client: sl()),
  );
  sl.registerSingletonAsync(
    () async => CalendarDatasource(
      client: sl(),
      eventCach: await Hive.openBox('eventCach'),
    ),
  );
  sl.registerLazySingleton<AuthenticationDatasource>(
    () => AuthenticationDatasourceImpl(
      client: sl(),
      dioUtils: sl(),
      storage: sl(),
      apiUtils: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => MoodleDatasource(client: sl()),
  );
  /*sl.registerLazySingleton(
    () => TicketDatasource(
      client: sl(),
      client2: sl(),
      dioUtils: sl(),
    ),
  );*/

  //! Repositories
  sl.registerSingletonWithDependencies(
    () => RubnewsRepository(rubnewsDatasource: sl()),
    dependsOn: [RubnewsDatasource],
  );
  sl.registerSingletonWithDependencies(
    () => CalendarRepository(calendarDatasource: sl()),
    dependsOn: [CalendarDatasource],
  );
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      authenticationDatasource: sl(),
      authenticationHandler: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => MoodleRepository(
      moodleDatasource: sl(),
      authenticationDatasource: sl(),
    ),
  );
  /*sl.registerLazySingleton(
    () => TicketRepository(
      authenticationDatasource: sl(),
      ticketDatasource: sl(),
    ),
  );*/

  //! Usecases
  sl.registerSingletonWithDependencies(
    () => RubnewsUsecases(rubnewsRepository: sl()),
    dependsOn: [RubnewsRepository],
  sl.registerSingletonWithDependencies(
    () => CalendarUsecases(calendarRepository: sl()),
    dependsOn: [CalendarRepository],
  );
  sl.registerLazySingleton(() => MoodleUsecases(moodleRepository: sl()));

  //! Utils
  sl.registerLazySingleton(
    () => DioUtils(
      client: sl(),
      cookieJar: sl(),
    )..init(),
  );
  sl.registerLazySingleton(ForgerockAPIUtils.new);
  sl.registerLazySingleton(CalendarUtils.new);
  sl.registerLazySingleton(FeedUtils.new);

  //! External
  sl.registerLazySingleton(http.Client.new);
  sl.registerLazySingleton(FlutterSecureStorage.new);
  sl.registerLazySingleton(Dio.new);
  sl.registerLazySingleton(CookieJar.new);

  await sl.allReady();
}
