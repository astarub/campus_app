import 'package:flutter/material.dart';
import 'package:campus_app/pages/email_client/models/email.dart';

class EmailSelectionController extends ChangeNotifier {
  final Set<Email> _selectedEmails = {};
  final Future<void> Function(Set<Email>)? onDelete;
  final Future<void> Function(Set<Email>)? onArchive;
  final Future<void> Function(Email)? onEmailUpdated; // Changed to Future<void>

  EmailSelectionController({
    this.onDelete,
    this.onArchive,
    this.onEmailUpdated,
  });

  // Public API (unchanged)
  Set<Email> get selectedEmails => Set.unmodifiable(_selectedEmails);
  bool get isSelecting => _selectedEmails.isNotEmpty;
  bool isSelected(Email email) => _selectedEmails.contains(email);
  int get selectionCount => _selectedEmails.length;

  // Selection management (unchanged)
  void toggleSelection(Email email) {
    _selectedEmails.contains(email) ? _selectedEmails.remove(email) : _selectedEmails.add(email);
    notifyListeners();
  }

  void selectAll(Iterable<Email> emails) {
    _selectedEmails.addAll(emails);
    notifyListeners();
  }

  void clearSelection() {
    _selectedEmails.clear();
    notifyListeners();
  }

  // Updated async methods
  Future<void> markAsReadSelected() async {
    for (final email in _selectedEmails) {
      final updatedEmail = email.copyWith(isUnread: false);
      await onEmailUpdated?.call(updatedEmail); // Added await
    }
    notifyListeners();
  }

  Future<void> markAsUnreadSelected() async {
    for (final email in _selectedEmails) {
      final updatedEmail = email.copyWith(isUnread: true);
      await onEmailUpdated?.call(updatedEmail); // Added await
    }
    notifyListeners();
  }

  Future<void> toggleReadState() async {
    // Made async
    final allUnread = _selectedEmails.every((e) => e.isUnread);
    for (final email in _selectedEmails) {
      await onEmailUpdated?.call(email.copyWith(isUnread: !allUnread)); // Added await
    }
    notifyListeners();
  }

  // New method for batch operations
  Future<void> performBatchOperation(Future<void> Function(Email) operation) async {
    for (final email in _selectedEmails) {
      await operation(email);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _selectedEmails.clear();
    super.dispose();
  }
}
