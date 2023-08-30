//! Uniform Resource Identifiers
import 'package:campus_app/env/env.dart';

// TODO: Write an API for Wordpress events and maybe RUB website too

const String astaEvents = 'https://asta-bochum.de/wp-json/tribe/events/v1/events';
const String astaFeed = 'https://asta-bochum.de/wp-json/wp/v2/posts?per_page=20';
const String astaFavicon = 'https://asta-bochum.de/wp-content/themes/rt_notio/custom/images/favicon.ico';
const String appEvents = 'https://app2.asta-bochum.de/wp-json/tribe/events/v1/events';
const String appFeed = 'https://app2.asta-bochum.de/wp-json/wp/v2/posts';
const String rubNewsfeed = 'https://news.rub.de/newsfeed'; // there is no non-german

const String appwrite = 'https://api-app2.asta-bochum.de/v1';

const String mensaData = 'https://api-app2.asta-bochum.de/get_meal';

// See: https://codewithandrea.com/articles/flutter-api-keys-dart-define-env-files/
final String mensaApiKey = Env.mensaApiKey;
final String firebaseAndroidApiKey = Env.firebaseAndroidApiKey;
final String firebaseIosApiKey = Env.firebaseIosApiKey;
