import 'package:flutter/material.dart';
import 'package:campus_app/pages/email_client/email_view.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/models/email.dart';

class TrashPage extends StatefulWidget {
  final List<Email> allEmails;

  const TrashPage({super.key, required this.allEmails});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  @override
  Widget build(BuildContext context) {
    final trashEmails = widget.allEmails.where((e) => e.folder == EmailFolder.trash).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Trash')),
      body: trashEmails.isEmpty
          ? const Center(child: Text('Trash is empty.'))
          : ListView.separated(
              itemCount: trashEmails.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final email = trashEmails[index];
                return EmailTile(
                  email: email,
                  isSelected: false,
                  onLongPress: () {},
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EmailView(
                        email: email,
                        isInTrash: true,
                        onDelete: (Email emailToDelete) {
                          setState(() {
                            widget.allEmails.removeWhere((e) => e.id == emailToDelete.id);
                          });
                        },
                        onRestore: (Email emailToRestore) {
                          setState(() {
                            final index = widget.allEmails.indexWhere((e) => e.id == emailToRestore.id);
                            if (index != -1) {
                              widget.allEmails[index] = widget.allEmails[index].copyWith(folder: EmailFolder.inbox);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
