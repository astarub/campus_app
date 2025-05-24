import 'package:flutter/material.dart';
import 'package:campus_app/pages/email_client/email_view.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/models/email.dart';

class SentPage extends StatelessWidget {
  final List<Email> allEmails;

  const SentPage({super.key, required this.allEmails});

  @override
  Widget build(BuildContext context) {
    final sentEmails = allEmails.where((e) => e.folder == EmailFolder.sent).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Sent')),
      body: sentEmails.isEmpty
          ? const Center(child: Text('No sent emails.'))
          : ListView.separated(
              itemCount: sentEmails.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) => EmailTile(
                email: sentEmails[index],
                isSelected: false,
                onLongPress: () {},
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmailView(email: sentEmails[index]),
                  ),
                ),
              ),
            ),
    );
  }
}
