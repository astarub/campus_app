import 'package:campus_app/core/authentication/authentication_datasource.dart';
import 'package:campus_app/core/authentication/authentication_repository.dart';
import 'package:campus_app/core/authentication/bloc/authentication_bloc.dart';
import 'package:campus_app/pages/calendar/bloc/calendar_bloc.dart';
import 'package:campus_app/pages/calendar/calendar_remote_datasource.dart';
import 'package:campus_app/pages/calendar/calendar_repository.dart';
import 'package:campus_app/pages/calendar/calendar_usecases.dart';
//import 'package:campus_app/pages/ecampus/bloc/ecampus_bloc.dart';
//import 'package:campus_app/pages/ecampus/ticket_datasource.dart';
//import 'package:campus_app/pages/ecampus/ticket_repository.dart';
import 'package:campus_app/pages/moodle/bloc/moodle_bloc.dart';
import 'package:campus_app/pages/moodle/moodle_datasource.dart';
import 'package:campus_app/pages/moodle/moodle_repository.dart';
import 'package:campus_app/pages/moodle/moodle_usecases.dart';
import 'package:campus_app/pages/rubnews/bloc/rubnews_bloc.dart';
import 'package:campus_app/pages/rubnews/rubnews_remote_datasource.dart';
import 'package:campus_app/pages/rubnews/rubnews_repository.dart';
import 'package:campus_app/pages/rubnews/rubnews_usecases.dart';
import 'package:campus_app/pages/rubsignin/bloc/rubsignin_bloc.dart';
import 'package:campus_app/utils/apis/forgerock_api.dart';
import 'package:campus_app/utils/dio_utils.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance; // service locator

Future<void> init() async {
  //! BloCs
  sl.registerFactory(() => RubnewsBloc(usecases: sl()));
  sl.registerFactory(() => CalendarBloc(usecases: sl()));
  sl.registerFactory(() => RUBSignInBloc(authenticationRepository: sl()));
  sl.registerFactory(() => AuthenticationBloc(authenticationRepository: sl()));
  sl.registerFactory(() => MoodleBloc(moodleUsecases: sl()));
  //sl.registerFactory(() => EcampusBloc(ticketRepository: sl()));

  //! Usecases
  sl.registerLazySingleton(() => RubnewsUsecases(rubnewsRepository: sl()));
  sl.registerLazySingleton(() => CalendarUsecases(calendarRepository: sl()));
  sl.registerLazySingleton(() => MoodleUsecases(moodleRepository: sl()));

  //! Repositories
  sl.registerLazySingleton<RubnewsRepository>(
    () => RubnewsRepositoryImpl(rubnewsRemoteDatasource: sl()),
  );
  sl.registerLazySingleton<CalendarRepository>(
    () => CalendarRepositoryImpl(calendarRemoteDatasource: sl()),
  );
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(authenticationDatasource: sl()),
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

  //! Datasources
  sl.registerLazySingleton<RubnewsRemoteDatasource>(
    () => RubnewsRemoteDatasourceImpl(client: sl()),
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

  //! Utils
  sl.registerLazySingleton(
    () => DioUtils(
      client: sl(),
      cookieJar: sl(),
    )..init(),
  );
  sl.registerLazySingleton(ForgerockAPIUtils.new);

  //! External
  sl.registerLazySingleton(http.Client.new);
  sl.registerLazySingleton(FlutterSecureStorage.new);
  sl.registerLazySingleton(Dio.new);
  sl.registerLazySingleton(CookieJar.new);
}
