import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/pages/email_client/models/user_email_folder.dart';
import 'package:campus_app/pages/email_client/widgets/email_bottom_panel.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/services/email_auth_service.dart';
import 'package:campus_app/utils/widgets/bubble_message.dart';
import 'package:campus_app/utils/widgets/bubble_service.dart';

class ComposeEmailScreen extends StatefulWidget {
  final Email? draft;
  final Email? replyTo;
  final Email? forwardFrom;

  const ComposeEmailScreen({
    super.key,
    this.draft,
    this.replyTo,
    this.forwardFrom,
  });

  @override
  State<ComposeEmailScreen> createState() => _ComposeEmailScreenState();
}

class _ComposeEmailScreenState extends State<ComposeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _toController = TextEditingController();
  final _ccController = TextEditingController();
  final _bccController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  final List<String> _attachments = [];
  bool _showCcBcc = false;

  String? _currentDraftID;
  String? _emailAddress;
  String? _emailDisplayName;
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _loadSenderEmail();
    if (widget.draft != null) {
      _currentDraftID = widget.draft!.id;
      _toController.text = widget.draft!.recipients.join(', ');
      _subjectController.text = widget.draft!.subject;
      _bodyController.text =
          widget.draft!.body.isNotEmpty ? widget.draft!.body.trim() : (widget.draft!.htmlBody ?? '').trim();
      _attachments.addAll(widget.draft!.attachments);
    } else if (widget.replyTo != null) {
      _toController.text = widget.replyTo!.senderEmail;
      _subjectController.text = 'Re: ${widget.replyTo!.subject}';
      _bodyController.text = '\n\n----------\n${widget.replyTo!.htmlBody ?? widget.replyTo!.body}';
    } else if (widget.forwardFrom != null) {
      _subjectController.text = 'Fwd: ${widget.forwardFrom!.subject}';
      _bodyController.text = '\n\n----------\n${widget.forwardFrom!.htmlBody ?? widget.forwardFrom!.body}';
    }

    // make sure the controllers only mark change when something changed
    _toController.addListener(_markChange);
    _subjectController.addListener(_markChange);
    _bodyController.addListener(_markChange);
    _ccController.addListener(_markChange);
    _bccController.addListener(_markChange);
  }

  @override
  void dispose() {
    _toController.removeListener(_markChange);
    _subjectController.removeListener(_markChange);
    _bodyController.removeListener(_markChange);
    _ccController.removeListener(_markChange);
    _bccController.removeListener(_markChange);
    _toController.dispose();
    _ccController.dispose();
    _bccController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  bool _hasContent() {
    return _toController.text.trim().isNotEmpty ||
        _subjectController.text.trim().isNotEmpty ||
        _bodyController.text.trim().isNotEmpty ||
        _attachments.isNotEmpty;
  }

  //load both the user email as well as user display name from storage
  Future<void> _loadSenderEmail() async {
    final emailAuthService = Provider.of<EmailAuthService>(context, listen: false);
    final emailAddress = await emailAuthService.getSenderEmail();
    final emailDisplayName = await emailAuthService.getDisplayName();
    if (mounted) {
      setState(() {
        _emailAddress = emailAddress;
        _emailDisplayName = emailDisplayName;
      });
    }
  }

  void _markChange() {
    if (!_hasChanged) setState(() => _hasChanged = true);
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

  void _saveDraft(EmailService emailService) {
    // if the user didn't input anything do not save the draft
    if (!_hasChanged && widget.draft == null) return;

    if (!_hasContent()) {
      if (widget.draft != null) {
        emailService.removeDraft(widget.draft!.id);
      }
      return;
    }

    // pass the ID to saveOrUpdateDraft, which replaces the draft
    _currentDraftID ??= DateTime.now().millisecondsSinceEpoch.toString();

    final existingDraft = emailService.allEmails.where((e) => e.id == _currentDraftID).firstOrNull;
    //if available overwrite the default 0 UID with the existing UID, otherwise we will always create a new email
    final currentUID = existingDraft?.uid ?? 0;

    final newDraft = Email(
      id: _currentDraftID!,
      sender: _emailDisplayName ?? 'Me',
      senderEmail: _emailAddress ?? '',
      recipients: _toController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      subject: _subjectController.text,
      body: _bodyController.text,
      date: DateTime.now(),
      attachments: List.from(_attachments),
      folder: UserEmailFolder.drafts,
      uid: currentUID,
    );
    emailService.saveOrUpdateDraft(newDraft);
    showUpdateMessages('Draft Saved!');
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final emailService = Provider.of<EmailService>(context, listen: false);

    // Remove the old draft if we're editing one
    if (widget.draft != null) {
      emailService.removeDraft(widget.draft!.id);
    }

    try {
      final emailAuthService = Provider.of<EmailAuthService>(context, listen: false);
      final senderEmail = await emailAuthService.getSenderEmail();
      await emailService.sendEmail(
        to: _toController.text.trim(),
        subject: _subjectController.text.trim(),
        body: _bodyController.text,
        senderEmail: senderEmail ?? '',
        // Pass cc/bcc as String? (the service will split internally)
        cc: _ccController.text.trim().isEmpty
            ? null
            : _ccController.text.trim(), // <<< changed: String? instead of List<String>?
        bcc: _bccController.text.trim().isEmpty ? null : _bccController.text.trim(), // <<< changed here as well
      );

      showUpdateMessages('Email sent!');
      Navigator.pop(context);
    } catch (e) {
      showUpdateMessages('Failed to send email: $e');
    }
  }

  Future<void> _attachFile() async {
    // TODO: implement real file picker
    setState(() {
      _attachments.add('file_${_attachments.length + 1}.pdf');
    });
  }

  @override
  Widget build(BuildContext context) {
    final emailService = Provider.of<EmailService>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        // only save the draft if changes were made
        if (_hasChanged) {
          _saveDraft(emailService);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.replyTo != null
                ? 'Reply'
                : widget.draft != null
                    ? 'Edit Draft'
                    : 'Compose',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Save Draft',
              onPressed: () {
                final emailService = Provider.of<EmailService>(context, listen: false);
                _saveDraft(emailService);
              },
            ),
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: _attachFile,
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendEmail,
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
                    email: widget.draft!,
                    emailService: emailService,
                    onActionComplete: () => setState(() {}),
                  ),
                );
              },
              tooltip: 'More',
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // To field
                TextFormField(
                  controller: _toController,
                  decoration: InputDecoration(
                    labelText: 'To',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter recipient';
                    }
                    final emails = value.split(',').map((e) => e.trim());
                    for (final email in emails) {
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                        return 'Invalid email: $email';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // CC/BCC toggle
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => setState(() => _showCcBcc = !_showCcBcc),
                    child: Text(_showCcBcc ? 'Hide CC/BCC' : 'Add CC/BCC'),
                  ),
                ),

                // CC field
                if (_showCcBcc) ...[
                  TextFormField(
                    controller: _ccController,
                    decoration: const InputDecoration(labelText: 'CC'),
                  ),
                  const SizedBox(height: 8),
                ],

                // BCC field
                if (_showCcBcc) ...[
                  TextFormField(
                    controller: _bccController,
                    decoration: const InputDecoration(labelText: 'BCC'),
                  ),
                  const SizedBox(height: 8),
                ],

                // Subject
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(labelText: 'Subject'),
                ),
                const SizedBox(height: 8),

                // Attachments preview
                if (_attachments.isNotEmpty) ...[
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _attachments.length,
                      itemBuilder: (_, i) => Chip(
                        label: Text(_attachments[i]),
                        onDeleted: () => setState(() => _attachments.removeAt(i)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Body
                Expanded(
                  child: TextFormField(
                    controller: _bodyController,
                    decoration: const InputDecoration(
                      hintText: 'Compose your email...',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
