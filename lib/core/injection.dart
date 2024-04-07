import 'package:appwrite/appwrite.dart';
import 'package:campus_app/utils/pages/wallet_utils.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:campus_app/core/backend/backend_repository.dart';
import 'package:campus_app/pages/calendar/calendar_datasource.dart';
import 'package:campus_app/pages/calendar/calendar_repository.dart';
import 'package:campus_app/pages/calendar/calendar_usecases.dart';
import 'package:campus_app/pages/mensa/mensa_datasource.dart';
import 'package:campus_app/pages/mensa/mensa_repository.dart';
import 'package:campus_app/pages/mensa/mensa_usecases.dart';

import 'package:campus_app/pages/feed/news/news_datasource.dart';
import 'package:campus_app/pages/feed/news/news_repository.dart';
import 'package:campus_app/pages/feed/news/news_usecases.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_datasource.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_repository.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_usecases.dart';
import 'package:campus_app/utils/pages/calendar_utils.dart';
import 'package:campus_app/utils/pages/feed_utils.dart';
import 'package:campus_app/utils/pages/mensa_utils.dart';
import 'package:campus_app/utils/pages/main_utils.dart';
import 'package:campus_app/utils/dio_utils.dart';
import 'package:campus_app/utils/constants.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';

final sl = GetIt.instance; // service locator

Future<void> init() async {
  //!
  //! Datasources
  //!

  //! Datasources
  sl.registerSingletonAsync(() async {
    final client = Dio();
    client.httpClientAdapter = NativeAdapter();

    return MensaDataSource(client: client, mensaCache: await Hive.openBox('mensaCache'));
  });

  sl.registerSingletonAsync(
    () async => NewsDatasource(
      client: sl(),
      rubnewsCache: await Hive.openBox('postsCache'),
    ),
  );

  sl.registerSingletonAsync(
    () async => CalendarDatasource(
      client: sl(),
      eventCache: await Hive.openBox('eventsCache'),
    ),
  );

  sl.registerLazySingleton(() {
    return TicketDataSource(
      secureStorage: sl(),
    );
  });

  //!
  //! Repositories
  //!

  sl.registerLazySingleton(() {
    final Client client = Client().setEndpoint(appwrite).setProject('campus_app');
    return BackendRepository(client: client);
  });

  sl.registerSingletonWithDependencies(
    () => NewsRepository(newsDatasource: sl()),
    dependsOn: [NewsDatasource],
  );

  sl.registerSingletonWithDependencies(
    () => CalendarRepository(calendarDatasource: sl()),
    dependsOn: [CalendarDatasource],
  );

  sl.registerSingletonWithDependencies(
    () => MensaRepository(mensaDatasource: sl()),
    dependsOn: [MensaDataSource],
  );

  sl.registerLazySingleton(
    () => TicketRepository(ticketDataSource: sl(), secureStorage: sl()),
  );

  //!
  //! Usecases
  //!

  sl.registerSingletonWithDependencies(
    () => NewsUsecases(newsRepository: sl()),
    dependsOn: [NewsRepository],
  );

  sl.registerSingletonWithDependencies(
    () => CalendarUsecases(calendarRepository: sl()),
    dependsOn: [CalendarRepository],
  );

  sl.registerSingletonWithDependencies(
    () => MensaUsecases(mensaRepository: sl()),
    dependsOn: [MensaRepository],
  );

  sl.registerLazySingleton(
    () => TicketUsecases(ticketRepository: sl()),
  );

  //!
  //! Utils
  //!

  sl.registerLazySingleton(
    () => DioUtils(
      client: sl(),
      cookieJar: sl(),
    )..init(),
  );

  sl.registerLazySingleton(CalendarUtils.new);
  sl.registerLazySingleton(FeedUtils.new);
  sl.registerLazySingleton(MensaUtils.new);
  sl.registerLazySingleton(MainUtils.new);
  sl.registerLazySingleton(WalletUtils.new);

  //!
  //! External
  //!

  //sl.registerLazySingleton(http.Client.new);
  sl.registerLazySingleton(Dio.new);
  sl.registerLazySingleton(CookieJar.new);
  sl.registerLazySingleton(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );

  await sl.allReady();
}
