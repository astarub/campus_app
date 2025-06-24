import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/email_pages/compose_email_screen.dart';

class DraftsPage extends StatefulWidget {
  const DraftsPage({super.key});

  @override
  State<DraftsPage> createState() => _DraftsPageState();
}

class _DraftsPageState extends State<DraftsPage> {
  @override
  Widget build(BuildContext context) {
    final emailService = Provider.of<EmailService>(context);
    final selectionController = emailService.selectionController;
    final drafts = emailService.allEmails.where((e) => e.folder == EmailFolder.drafts).toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // newest first

    return Scaffold(
      appBar: _buildAppBar(selectionController, drafts, emailService),
      body: drafts.isEmpty
          ? _buildEmptyState()
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
                  onTap: () => _handleEmailTap(draft, selectionController),
                  onLongPress: () => _handleEmailLongPress(draft, selectionController),
                );
              },
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(selectionController, List<Email> drafts, EmailService emailService) {
    if (selectionController.isSelecting) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => selectionController.clearSelection(),
        ),
        title: Text('${selectionController.selectionCount} selected'),
        actions: [
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: () => selectionController.selectAll(drafts),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => _showDeleteConfirmation(selectionController, emailService),
          ),
        ],
      );
    }

    return AppBar(
      title: const Text('Drafts'),
    );
  }

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

  void _handleEmailTap(Email draft, selectionController) {
    if (selectionController.isSelecting) {
      selectionController.toggleSelection(draft);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ComposeEmailScreen(draft: draft),
        ),
      );
    }
  }

  void _handleEmailLongPress(Email draft, selectionController) {
    if (!selectionController.isSelecting) {
      selectionController.toggleSelection(draft);
    }
  }

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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              emailService.deleteEmailsPermanently(selectionController.selectedEmails);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  bool _isDraftEmpty(Email draft) {
    return draft.subject.trim().isEmpty && draft.body.trim().isEmpty && draft.recipients.isEmpty;
  }
}
