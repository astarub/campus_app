//! Uniform Resource Identifiers
import 'package:campus_app/env/env.dart';

// TODO: Write an API for Wordpress events and maybe RUB website too

const String astaEvents = 'https://asta-bochum.de/wp-json/tribe/events/v1/events?per_page=50';
const String astaFavicon = 'https://asta-bochum.de/wp-content/themes/rt_notio/custom/images/favicon.ico';
const String rubNewsfeed = 'https://news.rub.de/newsfeed'; // there is no non-german

// TODO: Change IP to domain name of an asta-bocum.de server
const String mensaData = 'https://85.214.40.154/get_meal';

// See: https://codewithandrea.com/articles/flutter-api-keys-dart-define-env-files/
final String mensaApiKey = Env.mensaApiKey;

final String firebaseAndroidApiKey = Env.firebaseAndroidApiKey;
final String firebaseIosApiKey = Env.firebaseIosApiKey;
