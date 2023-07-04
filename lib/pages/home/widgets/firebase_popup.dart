import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:campus_app/utils/widgets/decision_popup.dart';

/// This widget shows a popup to let the user decide wether or not he wants
/// to use the Google services (Firebase) to receive notifications.
class FirebasePopup extends StatelessWidget {
  /// The function that is called when the popup is closed by the user.
  ///
  /// Returns `true` when the user accepts to use Firebase, and returns `false` if not.
  final void Function(bool) onClose;

  const FirebasePopup({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecisionPopup(
      leadingTitle: AppLocalizations.of(context)!.firebase_leadingTitle,
      title: AppLocalizations.of(context)!.firebase_title,
      content: MediaQuery.of(context).size.shortestSide < 600
          ? AppLocalizations.of(context)!.firebase_text
          : AppLocalizations.of(context)!.firebase_text600,
      acceptButtonText: AppLocalizations.of(context)!.firebase_accept,
      declineButtonText: AppLocalizations.of(context)!.firebase_decline,
      height: 450,
      onAccept: () {
        onClose(true);
        Navigator.pop(context);
      },
      onDecline: () {
        onClose(false);
        Navigator.pop(context);
      },
    );
  }
}
