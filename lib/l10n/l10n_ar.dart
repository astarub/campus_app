// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get helloWorld => 'مرحباً بالعالم!';

  @override
  String get serverFailureMessage => 'تعذر تحميل بيانات الخادم.';

  @override
  String get generalFailureMessage => 'حدث خطأ.';

  @override
  String get errorMessage => 'خطأ.';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع...';

  @override
  String get invalid2FATokenFailureMessage => 'رمز المصادقة (TOTP) غير صحيح. حاول مرة أخرى!';

  @override
  String get invalidLoginIDAndPasswordFailureMessage => 'بيانات الاعتماد غير صحيحة!';

  @override
  String get welcome => 'أهلاً وسهلاً!';

  @override
  String get login_prompt => 'يرجى تسجيل الدخول باستخدام معرف RUB وكلمة المرور الخاصة بك.';

  @override
  String get rubid => 'معرف تسجيل الدخول لحساب RUB الخاص بك';

  @override
  String get password => 'كلمة المرور';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get empty_input_field => 'يرجى إدخال بيانات الاعتماد الخاصة بك!';

  @override
  String get login_error => 'إدخال غير صالح!';

  @override
  String get login_success => 'تم تسجيل الدخول بنجاح!';

  @override
  String get login_already => 'تم تسجيل الدخول مسبقاً.';

  @override
  String get enter_totp => 'يرجى إدخال رمز المصادقة لمرة واحدة (TOTP).';

  @override
  String get walletTitle => 'المحفظة';

  @override
  String get addSemesterTicket => 'أضف تذكرة الفصل الدراسي الخاصة بك';

  @override
  String get rubEmergencyButton => 'مركز طوارئ RUB';

  @override
  String get rubEmergencyNote => 'متوفر 24/7 لجميع حالات الطوارئ';

  @override
  String get germanySemesterTicket => 'تذكرة الفصل الدراسي في ألمانيا';

  @override
  String get mensaBalanceTitle => 'رصيد الكافيتيريا';

  @override
  String get balanceLabel => 'الرصيد';

  @override
  String get euroSymbol => '€';

  @override
  String get lastTransactionLabel => 'آخر خصم';

  @override
  String get scanCardTitle => 'امسح بطاقتك';

  @override
  String get scanCardText => 'ضع بطاقة الطالب بالقرب من هاتفك لمسحها.';

  @override
  String get nfcDisabledTitle => 'NFC غير مفعل';

  @override
  String get nfcDisabledText => 'يجب تفعيل NFC لقراءة رصيد الكافيتيريا (AKAFÖ).';

  @override
  String get lastSavedBalance => 'آخر رصيد محفوظ';

  @override
  String get lastSavedTransaction => 'آخر خصم ممسوح';

  @override
  String get navFeed => 'الخلاصات';

  @override
  String get navEvents => 'الفعاليات';

  @override
  String get navMensa => 'المقصف';

  @override
  String get navWallet => 'المحفظة';

  @override
  String get navMore => 'المزيد';
}
