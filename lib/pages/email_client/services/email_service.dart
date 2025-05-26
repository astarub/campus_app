import 'package:flutter/foundation.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/widgets/select_email.dart';

class EmailService extends ChangeNotifier {
  final List<Email> _allEmails;
  final EmailSelectionController _selectionController = EmailSelectionController();

  // Modified constructor: Generates dummy emails internally
  EmailService() : _allEmails = List.generate(10, (i) => Email.dummy(i)) {
    _selectionController.addListener(notifyListeners);
  }

  // Public API (unchanged)
  List<Email> get allEmails => List.unmodifiable(_allEmails);
  EmailSelectionController get selectionController => _selectionController;

  List<Email> filterEmails(String query, EmailFolder folder) {
    final filtered = _allEmails.where((e) => e.folder == folder).toList();
    if (query.isEmpty) return filtered;

    return filtered
        .where((email) =>
            email.sender.toLowerCase().contains(query.toLowerCase()) ||
            email.subject.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void updateEmail(Email updatedEmail) {
    final index = _allEmails.indexWhere((e) => e.id == updatedEmail.id);
    if (index != -1) {
      _allEmails[index] = updatedEmail;
      notifyListeners();
    }
  }

  void moveEmailsToFolder(Iterable<Email> emails, EmailFolder folder) {
    for (final email in emails) {
      final index = _allEmails.indexWhere((e) => e.id == email.id);
      if (index != -1) {
        _allEmails[index] = email.copyWith(folder: folder);
      }
    }
    notifyListeners();
  }

  void deleteEmailsPermanently(Iterable<Email> emails) {
    _allEmails.removeWhere((e) => emails.any((email) => email.id == e.id));
    _selectionController.clearSelection();
    notifyListeners();
  }

  @override
  void dispose() {
    _selectionController.dispose();
    super.dispose();
  }
}
