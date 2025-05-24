import 'package:campus_app/pages/email_client/models/email.dart';

class EmailService {
  final List<Email> _allEmails;

  EmailService(this._allEmails);

  List<Email> filterEmails(String query, EmailFolder folder) {
    if (query.isEmpty) {
      return _allEmails.where((e) => e.folder == folder).toList();
    }
    return _allEmails
        .where((email) =>
            email.folder == folder &&
            (email.sender.toLowerCase().contains(query.toLowerCase()) ||
                email.subject.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  Future<void> archiveSelected(Set<Email> emails) async {
    for (final email in emails) {
      final index = _allEmails.indexWhere((e) => e.id == email.id);
      if (index != -1) {
        _allEmails[index] = email.copyWith(folder: EmailFolder.archives);
      }
    }
  }

  Future<void> deleteSelected(Set<Email> emails) async {
    for (final email in emails) {
      final index = _allEmails.indexWhere((e) => e.id == email.id);
      if (index != -1) {
        _allEmails[index] = email.copyWith(folder: EmailFolder.trash);
      }
    }
  }

  void updateEmail(Email updatedEmail) {
    final index = _allEmails.indexWhere((e) => e.id == updatedEmail.id);
    if (index != -1) {
      _allEmails[index] = updatedEmail;
    }
  }
}
