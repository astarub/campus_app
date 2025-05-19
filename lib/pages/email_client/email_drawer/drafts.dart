import 'package:flutter/material.dart';
import 'package:campus_app/pages/email_client/email_view.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/models/email.dart';

class DraftsPage extends StatelessWidget {
  final List<Email> allEmails;

  const DraftsPage({super.key, required this.allEmails});

  @override
  Widget build(BuildContext context) {
    final draftEmails = allEmails.where((e) => e.folder == EmailFolder.drafts).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Drafts')),
      body: draftEmails.isEmpty
          ? const Center(child: Text('No drafts available.'))
          : ListView.separated(
              itemCount: draftEmails.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) => EmailTile(
                email: draftEmails[index],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmailView(email: draftEmails[index]),
                  ),
                ),
              ),
            ),
    );
  }
}
