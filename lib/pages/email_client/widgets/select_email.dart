import 'package:flutter/material.dart';
import 'package:campus_app/pages/email_client/models/email.dart';

class EmailSelectionController extends ChangeNotifier {
  final Set<Email> _selectedEmails = {};
  final Future<void> Function(Set<Email>)? onDelete;
  final Future<void> Function(Set<Email>)? onArchive;
  final void Function(Email updatedEmail)? onEmailUpdated;

  EmailSelectionController({this.onDelete, this.onArchive, this.onEmailUpdated});

  // Public API
  Set<Email> get selectedEmails => Set.unmodifiable(_selectedEmails);
  bool get isSelecting => _selectedEmails.isNotEmpty;
  bool isSelected(Email email) => _selectedEmails.contains(email);
  int get selectionCount => _selectedEmails.length;

  // Selection management
  void toggleSelection(Email email) {
    _selectedEmails.contains(email) ? _selectedEmails.remove(email) : _selectedEmails.add(email);
    notifyListeners();
  }

  void toggleSelections(Iterable<Email> emails) {
    for (final email in emails) {
      toggleSelection(email);
    }
  }

  void selectAll(Iterable<Email> emails) {
    _selectedEmails.addAll(emails);
    notifyListeners();
  }

  void selectSingle(Email email) {
    _selectedEmails
      ..clear()
      ..add(email);
    notifyListeners();
  }

  void clearSelection() {
    _selectedEmails.clear();
    notifyListeners();
  }

  // Email state modifications
  Future<void> markAsReadSelected() async {
    for (final email in _selectedEmails) {
      final updatedEmail = email.copyWith(isUnread: false);
      onEmailUpdated?.call(updatedEmail); // Notify parent
    }
    notifyListeners();
  }

  Future<void> markAsUnreadSelected() async {
    for (final email in _selectedEmails) {
      final updatedEmail = email.copyWith(isUnread: true);
      onEmailUpdated?.call(updatedEmail);
    }
    notifyListeners();
  }

  void toggleReadState() {
    final allUnread = _selectedEmails.every((e) => e.isUnread);
    for (final email in _selectedEmails) {
      onEmailUpdated?.call(email.copyWith(isUnread: !allUnread));
    }
    notifyListeners();
  }
}
