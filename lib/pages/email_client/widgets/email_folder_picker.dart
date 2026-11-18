import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/models/user_email_folder.dart';
import 'package:campus_app/pages/email_client/utils/folder_utils.dart';
import 'package:campus_app/utils/widgets/bubble_message.dart';
import 'package:campus_app/utils/widgets/bubble_service.dart';

/// Dynamic Folder Picker for the Email Pull Up Sheet
class EmailFolderPicker extends StatefulWidget {
  final Email email;
  final EmailService emailService;
  final VoidCallback? onActionComplete;

  const EmailFolderPicker({
    super.key,
    required this.email,
    required this.emailService,
    this.onActionComplete,
  });

  @override
  State<EmailFolderPicker> createState() => _EmailFolderPickerState();
}

class _EmailFolderPickerState extends State<EmailFolderPicker> {
  final Set<String> _expandedFolders = {}; // set of expanded folders
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final emailService = context.watch<EmailService>();

    // get list of folders all at depth level 1
    final topLevel = emailService.userFolders.where((f) => f.depth == 1).toList()
      ..sort((a, b) => folderSortOrder(a).compareTo(folderSortOrder(b)));

    // helper function to use the global bubble notifications
    void showUpdateMessages(String message, {BubbleType type = BubbleType.info}) {
      BubbleService().show(
        context,
        message: message,
        type: type,
        top: 20,
      );
    }

    // same Tile building logic as in email drawer
    // (recursive) dynamic folder creation, depending on if a folder has children
    Widget buildFolderTile(
      BuildContext context,
      UserEmailFolder folder,
      EmailService emailService,
    ) {
      // list of a folders next depth level children
      final children = emailService.userFolders.where((f) => isDirectChild(f.mailboxName, folder.mailboxName)).toList();

      final isExpanded = _expandedFolders.contains(folder.mailboxName);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(
              folderIcon(folder),
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(folder.displayName),
            trailing: folder.hasChildren
                ? IconButton(
                    icon: AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 400),
                      child: const Icon(Icons.expand_more),
                    ),
                    onPressed: () => setState(() {
                      if (isExpanded) {
                        _expandedFolders.remove(folder.mailboxName);
                      } else {
                        _expandedFolders.add(folder.mailboxName);
                      }
                    }),
                  )
                : null,
            onTap: () async {
              final service = widget.emailService;
              Navigator.pop(context);
              await service.moveEmailToMailbox(widget.email, folder.mailboxName);

              widget.onActionComplete?.call();
            },
          ),

          // subfolder animation
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: folder.hasChildren && isExpanded
                ? Column(
                    children: children.map((child) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: buildFolderTile(context, child, emailService),
                      );
                    }).toList(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      );
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text(
              'Ordner wählen',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              controller: _scrollController,
              radius: const Radius.circular(16),
              child: ListView(
                children: [
                  ...topLevel.map((folder) => buildFolderTile(context, folder, emailService)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
