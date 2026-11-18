import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/pages/email_client/models/user_email_folder.dart';
import 'package:campus_app/pages/email_client/widgets/email_search.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/widgets/email_page_navigation.dart';
import 'package:campus_app/pages/email_client/email_pages/email_view.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/widgets/select_email.dart';

class FolderEmailsPage extends StatefulWidget {
  final String mailboxName;
  final String title;

  const FolderEmailsPage({
    super.key,
    required this.mailboxName,
    required this.title,
  });

  @override
  State<FolderEmailsPage> createState() => _FolderEmailsPageState();
}

class _FolderEmailsPageState extends State<FolderEmailsPage> {
  // Handles long press to enter selection mode
  void _handleEmailLongPress(Email email, EmailSelectionController selectionController) {
    if (!selectionController.isSelecting) {
      selectionController.toggleSelection(email); // Start selecting
    }
  }

  // verify with the User before permanently deleting Emails
  void _showPermanentDeleteConfirmation(EmailSelectionController selectionController, EmailService emailService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emails permanent löschen'),
        content: Text(
          'Möchtest du ${selectionController.selectionCount} Email(s) permanent löschen?\n\n Dies kann nicht rückgänging gemacht werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel deletion
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              emailService.moveEmailsToMailbox(
                selectionController.selectedEmails.toList(),
                UserEmailFolder.trash.mailboxName,
              ); // Delete selected drafts
              Navigator.pop(context); // Close dialog
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emailService = context.watch<EmailService>();

    final emails = emailService.getEmailsForMailbox(widget.mailboxName);

    final selectionController = emailService.selectionController;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<EmailService>().openFolder(UserEmailFolder.inbox);
        }
      },
      child: Scaffold(
        appBar: !selectionController.isSelecting
            ? AppBar(
                title: Text(widget.title),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => EmailSearch(
                          folder: UserEmailFolder(mailboxName: widget.mailboxName, displayName: widget.title),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: selectionController.clearSelection, // Exit selection mode
                ),
                title: Text('${selectionController.selectionCount} ausgewählt'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.select_all),
                    onPressed: () => selectionController.selectAll(emails), // Select all drafts
                  ),
                  if (widget.mailboxName != UserEmailFolder.trash.mailboxName)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => emailService.moveEmailsToMailbox(
                        selectionController.selectedEmails.toList(),
                        UserEmailFolder.trash.mailboxName,
                      ), // Confirm before deletion
                    )
                  else ...[
                    IconButton(
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () => _showPermanentDeleteConfirmation(selectionController, emailService),
                    ),
                  ],
                ],
              ),
        body: emails.isEmpty
            ? const Center(child: Text('No emails'))
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: emails.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 0,
                        thickness: 0.5,
                        indent: 45,
                        endIndent: 10,
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                      ),
                      itemBuilder: (context, index) {
                        final email = emails[index];
                        return EmailTile(
                          email: email,
                          isSelected: selectionController.isSelected(email),
                          onTap: () async {
                            if (!selectionController.isSelecting) {
                              if (context.mounted) {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EmailView(
                                      email: email,
                                      folder: email.folder,
                                      onDelete: (email, mailboxName) {
                                        emailService.moveEmailsToFolder([email], UserEmailFolder.trash);
                                      },
                                    ),
                                  ),
                                );
                              }
                            } else {
                              selectionController.toggleSelection(email);
                            }
                          },
                          onLongPress: () => _handleEmailLongPress(email, selectionController),
                        );
                      },
                    ),
                  ),
                  EmailPageNavigation(
                    currentPage: emailService.currentPage,
                    totalPages: emailService.totalPages,
                    isLoading: emailService.arePagesLoading,
                    onPrevious: () => emailService.goToPage(
                      UserEmailFolder(mailboxName: widget.mailboxName, displayName: widget.title),
                      emailService.currentPage - 1,
                    ),
                    onNext: () => emailService.goToPage(
                      UserEmailFolder(mailboxName: widget.mailboxName, displayName: widget.title),
                      emailService.currentPage + 1,
                    ),
                    onFirst: () => emailService.goToPage(
                      UserEmailFolder(mailboxName: widget.mailboxName, displayName: widget.title),
                      1,
                    ),
                    onLast: () => emailService.goToPage(
                      UserEmailFolder(mailboxName: widget.mailboxName, displayName: widget.title),
                      emailService.totalPages,
                    ),
                  ),
                  SizedBox(
                    // dynamically adjust the page navbar height to sit above the main navbar
                    height: MediaQuery.paddingOf(context).bottom + 10,
                  ),
                ],
              ),
      ),
    );
  }
}
