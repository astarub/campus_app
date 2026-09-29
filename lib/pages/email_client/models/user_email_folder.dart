import 'package:flutter/material.dart';

// Represents a mailbox/folder returned by the mail server.
@immutable
class UserEmailFolder {
  final String mailboxName; // Real server mailbox name (IMAP path)
  final String displayName; // Friendly name shown in the UI

  const UserEmailFolder({
    required this.mailboxName,
    required this.displayName,
  });

  // set known server folders
  static const inbox = UserEmailFolder(mailboxName: 'INBOX', displayName: 'Inbox');
  static const sent = UserEmailFolder(mailboxName: 'Sent', displayName: 'Sent');
  static const drafts = UserEmailFolder(mailboxName: 'Drafts', displayName: 'Drafts');
  static const trash = UserEmailFolder(mailboxName: 'Trash', displayName: 'Trash');
  static const spam = UserEmailFolder(mailboxName: 'UCE-TMP', displayName: 'Junk');

  @override
  bool operator ==(Object other) => other is UserEmailFolder && other.mailboxName == mailboxName;

  @override
  int get hashCode => mailboxName.hashCode;

  @override
  String toString() => displayName;
}
