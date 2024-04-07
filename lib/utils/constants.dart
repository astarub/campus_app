//! Uniform Resource Identifiers
import 'package:campus_app/env/env.dart';

const String appWordpressHost = 'https://app.asta-bochum.de';

const String appwrite = 'https://api-app.asta-bochum.de/v1';

const String astaEvents = 'https://asta-bochum.de/wp-json/tribe/events/v1/events';
const String astaFeed = 'https://asta-bochum.de/wp-json/wp/v2/posts?per_page=20';
const String astaFavicon = 'https://asta-bochum.de/wp-content/themes/rt_notio/custom/images/favicon.ico';
const String appEvents = 'https://app.asta-bochum.de/wp-json/tribe/events/v1/events';
const String appFeed = 'https://app.asta-bochum.de/wp-json/wp/v2/posts';
const String rubNewsfeed = 'https://news.rub.de/newsfeed'; // there is no non-german

const String mensaData = 'https://api-app.asta-bochum.de/get_meal';

const String osrmBackend = 'https://osrm.app.asta-bochum.de';

const String rideTicketing =
    'https://auth.ride-ticketing.de/auth/realms/ride/protocol/openid-connect/logout?redirect_uri=https%3A%2F%2Fabo.ride-ticketing.de%2Fapp%2Fprofile%3FpartnerId%3D61b1cbf4604e623aef325ef0e4226cea';

// See: https://codewithandrea.com/articles/flutter-api-keys-dart-define-env-files/
final String mensaApiKey = Env.mensaApiKey;
final String firebaseAndroidApiKey = Env.firebaseAndroidApiKey;
final String firebaseIosApiKey = Env.firebaseIosApiKey;
final String appwriteCreateUserKey = Env.appwriteCreateUserKey;
final String sentryDsn = Env.sentryDsn;
