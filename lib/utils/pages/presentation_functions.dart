import 'package:campus_app/core/failures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class Utils {
  /// return failure message based on the failure type
  String mapFailureToMessage(Failure failure, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    switch (failure.runtimeType) {
      case ServerFailure:
        return localizations.serverFailureMessage;

      case GeneralFailure:
        return localizations.generalFailureMessage;

      default:
        return localizations.errorMessage;
    }
  }
}
