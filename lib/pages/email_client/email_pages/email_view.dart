import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/utils/widgets/bubble_message.dart';
import 'package:campus_app/utils/widgets/bubble_service.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/widgets/email_bottom_panel.dart';
import 'package:campus_app/pages/email_client/email_pages/compose_email_screen.dart';

// Displays a full view of an email, including sender info, subject, body, and actions (reply, delete, restore)
class EmailView extends StatefulWidget {
  final Email email; // The email being viewed
  final void Function(Email, String)? onDelete; // Optional callback for deletion
  final void Function(Email)? onRestore; // Optional callback for restoring from trash
  final EmailFolder folder;

  const EmailView({
    super.key,
    required this.email,
    this.onDelete,
    this.onRestore,
    this.folder = EmailFolder.inbox,
  });

  @override
  State<EmailView> createState() => _EmailViewState();
}

// The Email View handles loading their own bodies over init
class _EmailViewState extends State<EmailView> {
  Email? _fullEmail;
  bool _isLoadingEmailBody = true;
  bool _fetchFail = false;
  bool _imagesBlocked = true;
  bool _isInTrash = false;

  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();

    // check if an email is in trash to enable permanent deletion
    if (widget.folder == EmailFolder.trash) {
      setState(() {
        _isInTrash = true;
      });
    }
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

  // helper function to use the global bubble notifications
  void showUpdateMessages(String message, {BubbleType type = BubbleType.info}) {
    if (!mounted) return;

    BubbleService().show(
      context,
      message: message,
      type: type,
      top: 20,
      duration: const Duration(seconds: 1),
    );
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
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog

              // perform the delete directly unlike soft delete
              final emailService = Provider.of<EmailService>(context, listen: false);
              await emailService.deleteEmail(widget.email);
              if (context.mounted) {
                Navigator.pop(context);
                showUpdateMessages('Email permanent gelöscht.');
              }
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
      showUpdateMessages('Email restored from trash.');
    }
  }

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
          padding: 12px 16px 50px !important;
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

  // check if an email has images to see if we need to add the load images button
  bool _emailHasImages(String? html) {
    if (html == null || html.isEmpty) return false;

    final lower = html.toLowerCase();
    return lower.contains('<img');
  }

  // -------------------------------------------------------------------------- Widget builder functions to avoid redundant code ------------------------------------------------------------------------------ //

  Widget _buildHeader(ThemeData theme, String timeText) {
    return Row(
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
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
        ),
        Text(
          timeText, // Display formatted time
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectLine(ThemeData theme) {
    return Text(
      widget.email.subject,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPlainBody(ThemeData theme, Email displayEmail) {
    if (_isLoadingEmailBody) {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_fetchFail) {
      return Text('Could not load email body.', style: theme.textTheme.bodySmall);
    }
    if (displayEmail.body.isNotEmpty) {
      return Text(displayEmail.body, style: theme.textTheme.bodyLarge);
    }
    return Text('No content', style: theme.textTheme.bodySmall);
  }

  // Styling for a Load More Button with disclaimer message
  Widget _buildLoadMore(ThemeData theme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1.5, color: const Color(0xFF9E9E9E)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            const Padding(padding: EdgeInsetsGeometry.all(5)),
            SvgPicture.asset(
              'assets/img/icons/warning.svg',
              color: Colors.grey,
            ),
            const Padding(padding: EdgeInsetsGeometry.all(5)),
            Expanded(
              child: Text(
                'Bilder könnten Tracker enthalten!',
                style: theme.textTheme.bodySmall,
              ),
            ),
            const Padding(padding: EdgeInsetsGeometry.all(5)),
            OutlinedButton(
              style:
                  const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Color.fromRGBO(224, 224, 224, 0.5))),
              child: Text(
                'Bilder laden',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF212121),
                ),
              ),
              onPressed: () async {
                if (_webViewController == null) return;

                await _webViewController!.setSettings(
                  settings: InAppWebViewSettings(
                    blockNetworkImage: false,
                  ),
                );
                await _webViewController!.reload();
                setState(() {
                  _imagesBlocked = false;
                });
              },
            ),
            const Padding(padding: EdgeInsetsGeometry.all(5)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeText = '${widget.email.date.hour}:${widget.email.date.minute.toString().padLeft(2, '0')}'; // Format time
    final displayEmail = _fullEmail ?? widget.email;
    final hasWebView =
        !_isLoadingEmailBody && !_fetchFail && displayEmail.htmlBody != null && displayEmail.htmlBody!.isNotEmpty;

    final hasImg = _emailHasImages(displayEmail.htmlBody);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RubMail'),
        actions: [
          if (!_isInTrash)
            IconButton(
              icon: const Icon(Icons.reply),
              onPressed: () => _handleReply(context), // Quick reply
              tooltip: 'Reply',
            ),
          if (!_isInTrash && widget.onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                widget.onDelete!(widget.email, widget.email.mailboxName ?? 'INBOX'); // Soft delete (to trash)
                Navigator.pop(context);
                showUpdateMessages('Email(s) moved to trash.');
              },
              tooltip: 'Delete',
            ),
          if (_isInTrash)
            IconButton(
              icon: const Icon(Icons.restore_from_trash),
              onPressed: () => _handleRestore(context), // Restore from trash
              tooltip: 'Restore',
            ),
          if (_isInTrash)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => _confirmPermanentDelete(context), // Permanent delete
              tooltip: 'Permanently Delete',
            ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              final emailService = Provider.of<EmailService>(context, listen: false);
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => EmailBottomPanel(
                  email: widget.email,
                  emailService: emailService,
                  onActionComplete: () => setState(() {}),
                ),
              );
            },
            tooltip: 'More',
          ),
        ],
      ),
      body: Column(
        children: [
          // header section
          // no webView -> scrollable header
          if (!hasWebView)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(theme, timeText),
                    const SizedBox(height: 16),
                    _buildSubjectLine(theme),
                    const SizedBox(height: 16),
                    _buildPlainBody(theme, displayEmail),
                  ],
                ),
              ),
            )
          // fixed header for webViews to help with scrolling issues
          else ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(theme, timeText),
                  const SizedBox(height: 16),
                  _buildSubjectLine(theme),
                  const SizedBox(height: 16),
                  if (_imagesBlocked && hasImg) _buildLoadMore(theme),
                ],
              ),
            ),
            // InAppView now doesn't dynamically manage it's height but uses up leftover space
            Expanded(
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
                  useWideViewPort: false,
                  loadWithOverviewMode: false,
                  supportZoom: false,
                ),
              ),
            ),
          ],
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
      floatingActionButton: !_isInTrash
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
