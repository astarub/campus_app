import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/models/user_email_folder.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/widgets/email_page_navigation.dart';
import 'package:campus_app/pages/email_client/widgets/email_search.dart';
import 'package:campus_app/pages/email_client/email_pages/compose_email_screen.dart';
import 'package:campus_app/pages/email_client/widgets/select_email.dart';

// UI screen to display and manage email drafts
class DraftsPage extends StatefulWidget {
  const DraftsPage({super.key});

  @override
  State<DraftsPage> createState() => _DraftsPageState();
}

class _DraftsPageState extends State<DraftsPage> {
  @override
  Widget build(BuildContext context) {
    final emailService = Provider.of<EmailService>(context); // Access the email service
    final selectionController = emailService.selectionController; // For managing multi-selection
    final drafts = emailService.allEmails.where((e) => e.folder == UserEmailFolder.drafts).toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort drafts by newest first

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<EmailService>().openFolder(UserEmailFolder.inbox);
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(selectionController, drafts, emailService), // Show toolbar with actions
        body: drafts.isEmpty
            ? _buildEmptyState() // Show message if no drafts
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: drafts.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 0,
                        thickness: 0.5,
                        indent: 45,
                        endIndent: 10,
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                      ),
                      itemBuilder: (_, index) {
                        final draft = drafts[index];
                        return EmailTile(
                          email: draft,
                          isSelected: selectionController.isSelected(draft),
                          onTap: () {
                            unawaited(_handleEmailTap(draft, selectionController));
                          }, // Tap to edit
                          onLongPress: () => _handleEmailLongPress(draft, selectionController), // Long press to select
                        );
                      },
                    ),
                  ),
                  EmailPageNavigation(
                    currentPage: emailService.currentPage,
                    totalPages: emailService.totalPages,
                    isLoading: emailService.arePagesLoading,
                    onPrevious: () => emailService.goToPage(UserEmailFolder.drafts, emailService.currentPage - 1),
                    onNext: () => emailService.goToPage(UserEmailFolder.drafts, emailService.currentPage + 1),
                    onFirst: () => emailService.goToPage(UserEmailFolder.drafts, 1),
                    onLast: () => emailService.goToPage(UserEmailFolder.drafts, emailService.totalPages),
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

  // Builds AppBar depending on whether selection mode is active
  PreferredSizeWidget _buildAppBar(
    EmailSelectionController selectionController,
    List<Email> drafts,
    EmailService emailService,
  ) {
    if (selectionController.isSelecting) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => selectionController.clearSelection(), // Exit selection mode
        ),
        title: Text('${selectionController.selectionCount} ausgewählt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: () => selectionController.selectAll(drafts), // Select all drafts
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(selectionController, emailService), // Confirm before deletion
          ),
        ],
      );
    }

    // Default AppBar when not selecting
    return AppBar(
      title: const Text('Drafts'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const EmailSearch(folder: UserEmailFolder.drafts),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          ),
        ),
      ],
    );
  }

  // Widget shown when there are no drafts
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.drafts_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No drafts',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Handles tapping a draft: open for editing or toggle selection
  Future<void> _handleEmailTap(Email draft, EmailSelectionController selectionController) async {
    if (selectionController.isSelecting) {
      selectionController.toggleSelection(draft); // Toggle selected state
    } else {
      // fetch the current draft body
      if (context.mounted) {
        final emailService = Provider.of<EmailService>(context, listen: false);
        final fullDraft = await emailService.fetchFullEmail(draft);
        if (!mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ComposeEmailScreen(draft: fullDraft), // Navigate to compose screen with the draft
          ),
        );
      }
    }
  }

  // Handles long press to enter selection mode
  void _handleEmailLongPress(Email draft, EmailSelectionController selectionController) {
    if (!selectionController.isSelecting) {
      selectionController.toggleSelection(draft); // Start selecting
    }
  }

  // Show confirmation dialog before moving emails to trash
  void _showDeleteConfirmation(EmailSelectionController selectionController, EmailService emailService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Entwürfe Löschen'),
        content: Text(
          'Möchtest du ${selectionController.selectionCount} Email(s) löschen?',
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
}
