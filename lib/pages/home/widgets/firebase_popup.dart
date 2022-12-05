import 'package:flutter/material.dart';

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
      leadingTitle: 'Datenschutz',
      title: 'Google Services',
      content: '''
        Um dir Benachrichtigungen über spontane Events und Termine rund um die Uni schicken zu können,
        verwenden wir derzeit Firebase, einen Service von Google.
        
        Solltest du dies nicht wollen, respektieren wir das.
        Im Januar werden wir dafür eine Google-freie Alternative einführen. ''',
      acceptButtonText: 'Ja, kein Problem',
      declineButtonText: 'Nein, möchte ich nicht.',
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
