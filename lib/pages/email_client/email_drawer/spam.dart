import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/email_pages/email_view.dart';

class SpamPage extends StatelessWidget {
  const SpamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final emailService = Provider.of<EmailService>(context);
    final spamEmails = emailService.allEmails.where((email) => email.folder == EmailFolder.spam).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spam'),
      ),
      body: RefreshIndicator(
        onRefresh: () => emailService.refreshEmails(),
        child: spamEmails.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                  Center(
                    child: Text(
                      'No spam emails',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: spamEmails.length,
                itemBuilder: (context, index) {
                  final email = spamEmails[index];
                  return EmailTile(
                    email: email,
                    isSelected: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmailView(email: email),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
