import 'package:flutter/material.dart';
import 'package:campus_app/pages/email_client/models/email.dart';

/// Manages selection state and batch actions for emails (e.g. archive, delete, mark as read).
class EmailSelectionController extends ChangeNotifier {
  final Set<Email> _selectedEmails = {};

  // Optional async handlers for batch actions
  final Future<void> Function(Set<Email>)? onDelete;
  final Future<void> Function(Set<Email>)? onArchive;
  final Future<void> Function(Email)? onEmailUpdated;

  EmailSelectionController({
    this.onDelete,
    this.onArchive,
    this.onEmailUpdated,
  });

  // ==== Public Accessors ====

  /// Currently selected emails (read-only)
  Set<Email> get selectedEmails => Set.unmodifiable(_selectedEmails);

  /// Returns true if any email is selected
  bool get isSelecting => _selectedEmails.isNotEmpty;

  /// Checks if a specific email is selected
  bool isSelected(Email email) => _selectedEmails.contains(email);

  /// Number of selected emails
  int get selectionCount => _selectedEmails.length;

  // ==== Selection Management ====

  /// Selects or deselects an email
  void toggleSelection(Email email) {
    _selectedEmails.contains(email) ? _selectedEmails.remove(email) : _selectedEmails.add(email);
    notifyListeners();
  }

  /// Selects all given emails
  void selectAll(Iterable<Email> emails) {
    _selectedEmails.addAll(emails);
    notifyListeners();
  }

  /// Clears all selected emails
  void clearSelection() {
    _selectedEmails.clear();
    notifyListeners();
  }

  // ==== Async Update Operations ====

  /// Marks all selected emails as read
  Future<void> markAsReadSelected() async {
    for (final email in _selectedEmails) {
      final updatedEmail = email.copyWith(isUnread: false);
      await onEmailUpdated?.call(updatedEmail);
    }
    notifyListeners();
  }

  /// Marks all selected emails as unread
  Future<void> markAsUnreadSelected() async {
    for (final email in _selectedEmails) {
      final updatedEmail = email.copyWith(isUnread: true);
      await onEmailUpdated?.call(updatedEmail);
    }
    notifyListeners();
  }

  /// Toggles read/unread state for all selected emails
  Future<void> toggleReadState() async {
    final allUnread = _selectedEmails.every((e) => e.isUnread);
    for (final email in _selectedEmails) {
      await onEmailUpdated?.call(email.copyWith(isUnread: !allUnread));
    }
    notifyListeners();
  }

  /// Applies a custom async operation to each selected email
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
