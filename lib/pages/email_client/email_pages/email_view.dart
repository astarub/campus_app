import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/email_pages/compose_email_screen.dart';

// Displays a full view of an email, including sender info, subject, body, and actions (reply, delete, restore)
class EmailView extends StatefulWidget {
  final Email email; // The email being viewed
  final void Function(Email)? onDelete; // Optional callback for deletion
  final void Function(Email)? onRestore; // Optional callback for restoring from trash
  final bool isInTrash; // Whether the email is currently in the trash folder

  const EmailView({
    super.key,
    required this.email,
    this.onDelete,
    this.onRestore,
    this.isInTrash = false,
  });

  @override
  State<EmailView> createState() => _EmailViewState();
}

// The Email View handles loading their own bodies over init
class _EmailViewState extends State<EmailView> {
  Email? _fullEmail;
  bool _isLoadingEmailBody = true;
  bool _fetchFail = false;
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _loadEmailBody();
  }

  Future<void> _loadEmailBody() async {
    try {
      final emailService = Provider.of<EmailService>(context, listen: false);
      final fullE = await emailService.fetchFullEmail(widget.email.uid);
      if (mounted) {
        setState(() {
          _fullEmail = fullE;
          _isLoadingEmailBody = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingEmailBody = false;
          _fetchFail = true;
        });
      }
    }
  }

  // Opens the compose screen with the current email as a reply
  void _handleReply(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComposeEmailScreen(replyTo: widget.email),
      ),
    );
  }

  // Shows confirmation dialog before permanently deleting the email
  void _confirmPermanentDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Permanently Delete'),
        content: const Text('This action is permanent. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // Cancel action
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              if (widget.onDelete != null) {
                widget.onDelete?.call(widget.email); // Perform delete
              }
              Navigator.pop(context); // Close email view
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email permanently deleted')),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  // Handles restoring a trashed email
  void _handleRestore(BuildContext context) {
    if (widget.onRestore != null) {
      widget.onRestore!(widget.email);
      Navigator.pop(context); // Close email view
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email restored from trash')),
      );
    }
  }

  double _webViewHeight = 400;

  // adjust the HTML for a phone screen, the default is framed for desktop screens and unsuitable for mobile screens
  String _prepareHTMLForMobile(String html, BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = darkMode ? '#121212' : '#ffffff';
    final textColor = darkMode ? '#e0e0e0' : '#000000';

    const viewport = '<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">';

    final baseStyle = '''
      <style>
        body {
          margin: 0 !important;
          padding: 0 !important;
          width: 100% !important;
          max-width: 100% !important;
          font-size: 16px !important;
          background-color: $bgColor !important;
          color: $textColor;
          -webkit-text-size-adjust: 100%;
          word-wrap: break-word;
          overflow-wrap: break-word;
        }
        table, td, img {
          max-width: 100% !important;
          height: auto !important;
        }
        * {
          max-width: 100% !important;
          box-sizing: border-box !important;
        }
        a {
          color: #4a9eff;
        }
      </style>
    ''';

    if (html.contains('<html')) {
      return html.replaceFirst(
        RegExp('<html[^>]*>'),
        '<html><head>$viewport$baseStyle</head>',
      );
    }

    return '''
      <html>
        <head>$viewport$baseStyle</head>
        <body>$html</body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeText = '${widget.email.date.hour}:${widget.email.date.minute.toString().padLeft(2, '0')}'; // Format time
    final displayEmail = _fullEmail ?? widget.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RubMail'),
        actions: [
          if (!widget.isInTrash)
            IconButton(
              icon: const Icon(Icons.reply),
              onPressed: () => _handleReply(context), // Quick reply
              tooltip: 'Reply',
            ),
          if (!widget.isInTrash && widget.onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                widget.onDelete!(widget.email); // Soft delete (to trash)
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email moved to trash')),
                );
              },
              tooltip: 'Delete',
            ),
          if (widget.isInTrash)
            IconButton(
              icon: const Icon(Icons.restore_from_trash),
              onPressed: () => _handleRestore(context), // Restore from trash
              tooltip: 'Restore',
            ),
          if (widget.isInTrash)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => _confirmPermanentDelete(context), // Permanent delete
              tooltip: 'Permanently Delete',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with sender info and timestamp
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.email.sender,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: widget.email.isUnread ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (widget.email.senderEmail.isNotEmpty)
                        Text(
                          widget.email.senderEmail,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  timeText, // Display formatted time
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Subject line
            Text(
              widget.email.subject,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // while the email is being fetched display a loading spinner and display html bodies using an InAppWebView that can properly handle email HTML
            if (_isLoadingEmailBody)
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_fetchFail)
              Text(
                'Could not load email body.',
                style: theme.textTheme.bodySmall,
              )
            else if (displayEmail.htmlBody != null && displayEmail.htmlBody!.isNotEmpty)
              SizedBox(
                height: _webViewHeight,
                child: InAppWebView(
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                  initialData: InAppWebViewInitialData(
                    data: _prepareHTMLForMobile(displayEmail.htmlBody!, context),
                    encoding: 'utf-8',
                  ),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: false,
                    blockNetworkImage: true,
                    disableContextMenu: true,
                    disableVerticalScroll: true,
                    useWideViewPort: false,
                    loadWithOverviewMode: false,
                    supportZoom: false,
                  ),
                  onLoadStop: (controller, url) async {
                    final height = await controller.getContentHeight();
                    if (height != null && mounted) {
                      final newHeight = height.toDouble();
                      // only change if height has changed significantly and is a valid height
                      if (newHeight > 10 && (newHeight - _webViewHeight).abs() > 1) {
                        setState(() {
                          _webViewHeight = newHeight;
                        });
                      }
                    }
                  },
                ),
              )
            else if (displayEmail.body.isNotEmpty)
              Text(
                displayEmail.body,
                style: theme.textTheme.bodyLarge,
              )
            else
              Text(
                'No content',
                style: theme.textTheme.bodySmall,
              ),

            // Attachments section
            if (widget.email.attachments.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Attachments (${widget.email.attachments.length})',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.email.attachments.length,
                  itemBuilder: (context, index) => Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.insert_drive_file, size: 30, color: theme.iconTheme.color),
                        const SizedBox(height: 4),
                        Text(
                          'File ${index + 1}', // Display file number
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: !widget.isInTrash
          ? FloatingActionButton(
              onPressed: () => _handleReply(context), // FAB for quick reply
              tooltip: 'Reply',
              child: const Icon(Icons.reply),
            )
          : null,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
