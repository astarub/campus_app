import 'package:flutter/material.dart';

import 'package:campus_app/l10n/l10n.dart';
import 'package:campus_app/utils/widgets/decision_popup.dart';

/// This widget shows a popup to let the user decide wether or not he wants
/// to use the Google services (Firebase) to receive notifications.
class FirebasePopup extends StatelessWidget {
  /// The function that is called when the popup is closed by the user.
  ///
  /// Returns `true` when the user accepts to use Firebase, and returns `false` if not.
  final void Function({bool permissionGranted}) onClose;

  const FirebasePopup({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecisionPopup(
      leadingTitle: 'Datenschutz',
      title: 'Google Services',
      content: MediaQuery.of(context).size.shortestSide < 600
          ? AppLocalizations.of(context)!.firebaseDecisionPopup
          : AppLocalizations.of(context)!.firebaseDecisionPopupSlim,
      acceptButtonText: AppLocalizations.of(context)!.firebaseDecisionAccept,
      declineButtonText: AppLocalizations.of(context)!.firebaseDecisionDecline,
      height: 450,
      onAccept: () {
        onClose(permissionGranted: true);
        Navigator.pop(context);
      },
      onDecline: () {
        onClose(permissionGranted: false);
        Navigator.pop(context);
      },
    );
  }
}
