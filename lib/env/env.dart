import 'package:envied/envied.dart';

part 'env.g.dart';

// CONTAINS WRONG CREDENTIALS
// ACCESS TO OUR INFRASTRUCTURE IS RESTRICTED!!!!!!

/// This class holds all secret environment variables.
///
/// To genereate the [env.g.dart] file with new variables, create a
/// [.env] file in the root folder and put each variable with `KEY=VALUE` in it.
/// Then execute the command `flutter pub run build_runner build --delete-conflicting-outputs`
@Envied(path: '.env')
abstract class Env {
  // Can be called to access the obfuscated mensa API key
  @EnviedField(varName: 'MENSA_API_KEY', obfuscate: true)
  static final String mensaApiKey = _Env.mensaApiKey;

  @EnviedField(varName: 'FIREBASE_ANDROID_API_KEY', obfuscate: true)
  static final String firebaseAndroidApiKey = _Env.firebaseAndroidApiKey;

  @EnviedField(varName: 'FIREBASE_IOS_API_KEY', obfuscate: true)
  static final String firebaseIosApiKey = _Env.firebaseIosApiKey;

  @EnviedField(varName: 'APPWRITE_CREATE_USER_AUTH_KEY', obfuscate: true)
  static final String appwriteCreateUserKey = _Env.appwriteCreateUserKey;

  @EnviedField(varName: 'SENTRY_DSN', obfuscate: true)
  static final String sentryDsn = _Env.sentryDsn;
}
