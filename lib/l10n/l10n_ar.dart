// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get helloWorld => 'مرحبًا بالعالم!';

  @override
  String get serverFailureMessage => 'تعذر تحميل بيانات الخادم.';

  @override
  String get generalFailureMessage => 'حدث خطأ.';

  @override
  String get errorMessage => 'خطأ.';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع...';

  @override
  String get invalid2FATokenFailureMessage =>
      'رمز التحقق غير صحيح. يرجى المحاولة مرة أخرى!';

  @override
  String get invalidLoginIDAndPasswordFailureMessage =>
      'بيانات تسجيل الدخول غير صحيحة!';

  @override
  String get welcome => 'مرحبًا!';

  @override
  String get login_prompt =>
      'يرجى تسجيل الدخول باستخدام معرف RUB وكلمة المرور.';

  @override
  String get rubid => 'معرف تسجيل الدخول لحساب RUB الخاص بك';

  @override
  String get password => 'كلمة المرور';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get empty_input_field => 'يرجى إدخال بيانات تسجيل الدخول!';

  @override
  String get login_error => 'إدخال غير صالح!';

  @override
  String get login_success => 'تم تسجيل الدخول بنجاح!';

  @override
  String get login_already => 'أنت مسجل الدخول بالفعل.';

  @override
  String get enter_totp => 'يرجى إدخال رمز التحقق.';
}
