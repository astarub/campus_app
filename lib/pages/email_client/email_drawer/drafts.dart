import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/email_pages/compose_email_screen.dart';

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
    final drafts = emailService.allEmails.where((e) => e.folder == EmailFolder.drafts).toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort drafts by newest first

    return Scaffold(
      appBar: _buildAppBar(selectionController, drafts, emailService), // Show toolbar with actions
      body: drafts.isEmpty
          ? _buildEmptyState() // Show message if no drafts
          : ListView.separated(
              itemCount: drafts.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
              itemBuilder: (_, index) {
                final draft = drafts[index];
                return EmailTile(
                  email: draft,
                  isSelected: selectionController.isSelected(draft),
                  onTap: () => _handleEmailTap(draft, selectionController), // Tap to edit
                  onLongPress: () => _handleEmailLongPress(draft, selectionController), // Long press to select
                );
              },
            ),
    );
  }

  // Builds AppBar depending on whether selection mode is active
  PreferredSizeWidget _buildAppBar(selectionController, List<Email> drafts, EmailService emailService) {
    if (selectionController.isSelecting) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => selectionController.clearSelection(), // Exit selection mode
        ),
        title: Text('${selectionController.selectionCount} selected'),
        actions: [
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: () => selectionController.selectAll(drafts), // Select all drafts
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => _showDeleteConfirmation(selectionController, emailService), // Confirm before deletion
          ),
        ],
      );
    }

    // Default AppBar when not selecting
    return AppBar(
      title: const Text('Drafts'),
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
  void _handleEmailTap(Email draft, selectionController) {
    if (selectionController.isSelecting) {
      selectionController.toggleSelection(draft); // Toggle selected state
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ComposeEmailScreen(draft: draft), // Navigate to compose screen with the draft
        ),
      );
    }
  }

  // Handles long press to enter selection mode
  void _handleEmailLongPress(Email draft, selectionController) {
    if (!selectionController.isSelecting) {
      selectionController.toggleSelection(draft); // Start selecting
    }
  }

  // Show confirmation dialog before permanently deleting selected drafts
  void _showDeleteConfirmation(selectionController, EmailService emailService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Drafts'),
        content: Text(
          'Are you sure you want to permanently delete ${selectionController.selectionCount} draft(s)?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel deletion
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              emailService.deleteEmailsPermanently(selectionController.selectedEmails); // Delete selected drafts
              Navigator.pop(context); // Close dialog
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
