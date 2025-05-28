import 'package:flutter/foundation.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/widgets/select_email.dart';

class EmailService extends ChangeNotifier {
  final List<Email> _allEmails;
  final EmailSelectionController _selectionController = EmailSelectionController();

  // Modified constructor: Generates dummy emails internally
  EmailService() : _allEmails = List.generate(10, Email.dummy) {
    _selectionController.addListener(notifyListeners);
  }

  // Public API (unchanged)
  List<Email> get allEmails => List.unmodifiable(_allEmails);
  EmailSelectionController get selectionController => _selectionController;

  List<Email> filterEmails(String query, EmailFolder folder) {
    final filtered = _allEmails.where((e) => e.folder == folder).toList();
    if (query.isEmpty) return filtered;
    return filtered
        .where(
          (email) =>
              email.sender.toLowerCase().contains(query.toLowerCase()) ||
              email.subject.toLowerCase().contains(query.toLowerCase()),
        )
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

  //delete email permanently, possible if email is deleted and is in the trash section.
  void deleteEmailsPermanently(Iterable<Email> emails) {
    _allEmails.removeWhere((e) => emails.any((email) => email.id == e.id));
    _selectionController.clearSelection();
    notifyListeners();
  }

  // Add or update a draft with auto-delete logic
  void saveOrUpdateDraft(Email draft) {
    // Check if draft is empty and should be auto-deleted
    if (_isDraftEmpty(draft)) {
      // If it's an existing draft, remove it
      final existingIndex = _allEmails.indexWhere((e) => e.id == draft.id);
      if (existingIndex != -1) {
        _allEmails.removeAt(existingIndex);
        notifyListeners();
      }
      return; // Don't save empty drafts
    }

    final index = _allEmails.indexWhere((e) => e.id == draft.id);
    if (index != -1) {
      _allEmails[index] = draft.copyWith(folder: EmailFolder.drafts);
    } else {
      _allEmails.add(draft.copyWith(folder: EmailFolder.drafts));
    }
    notifyListeners();
  }

  // Remove a draft (used when sending email)
  void removeDraft(String draftId) {
    _allEmails.removeWhere((e) => e.id == draftId && e.folder == EmailFolder.drafts);
    notifyListeners();
  }

  // Auto-clean empty drafts - can be called periodically or on demand
  void cleanEmptyDrafts() {
    final emptyDrafts = _allEmails.where((e) => e.folder == EmailFolder.drafts && _isDraftEmpty(e)).toList();

    if (emptyDrafts.isNotEmpty) {
      deleteEmailsPermanently(emptyDrafts);
    }
  }

  // Check if a draft is considered empty
  bool _isDraftEmpty(Email draft) {
    return draft.subject.trim().isEmpty && draft.body.trim().isEmpty && draft.recipients.isEmpty;
  }

  // Get count of empty drafts (useful for UI)
  int get emptyDraftsCount {
    return _allEmails.where((e) => e.folder == EmailFolder.drafts && _isDraftEmpty(e)).length;
  }

  @override
  void dispose() {
    _selectionController.dispose();
    super.dispose();
  }
}
