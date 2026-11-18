import 'package:flutter/material.dart';

import 'package:campus_app/pages/email_client/models/user_email_folder.dart';

// This file contains helper functions used across two different files, they are saved seperately to avoid redundancy

// determine direct children (next depth level) using mailboxname (path)
bool isDirectChild(String child, String parent) {
  return child.startsWith('$parent/') && child.substring(parent.length + 1).split('/').length == 1;
}

// map Icons to system folders, custom folders get generic folder icon
IconData folderIcon(UserEmailFolder folder) {
  switch (folder) {
    case UserEmailFolder.inbox:
      return Icons.inbox;
    case UserEmailFolder.drafts:
      return Icons.drafts;
    case UserEmailFolder.sent:
      return Icons.send;
    case UserEmailFolder.spam:
      return Icons.local_fire_department;
    case UserEmailFolder.trash:
      return Icons.delete;
    default:
      return Icons.folder;
  }
}

// assigns an order to the folder, so that the system folders are at the top of the list, above the custom foldersr
int folderSortOrder(UserEmailFolder folder) {
  switch (folder) {
    case UserEmailFolder.inbox:
      return 0;
    case UserEmailFolder.drafts:
      return 1;
    case UserEmailFolder.sent:
      return 2;
    case UserEmailFolder.spam:
      return 3;
    case UserEmailFolder.trash:
      return 4;
    default:
      return 100;
  }
}
