import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';

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
  bool _showCcBcc = false;
  final List<String> _attachments = [];

  @override
  void initState() {
    super.initState();
    if (widget.draft != null) {
      _toController.text = widget.draft!.recipients.join(', ');
      _subjectController.text = widget.draft!.subject;
      _bodyController.text = widget.draft!.htmlBody ?? widget.draft!.body;
      _attachments.addAll(widget.draft!.attachments);
    } else if (widget.replyTo != null) {
      _toController.text = widget.replyTo!.senderEmail;
      _subjectController.text = 'Re: ${widget.replyTo!.subject}';
      _bodyController.text = '\n\n----------\n${widget.replyTo!.htmlBody ?? widget.replyTo!.body}';
    } else if (widget.forwardFrom != null) {
      _subjectController.text = 'Fwd: ${widget.forwardFrom!.subject}';
      _bodyController.text = '\n\n----------\n${widget.forwardFrom!.htmlBody ?? widget.forwardFrom!.body}';
    }
  }

  @override
  void dispose() {
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

  void _saveDraft(EmailService emailService) {
    if (!_hasContent()) {
      if (widget.draft != null) {
        emailService.removeDraft(widget.draft!.id);
      }
      return;
    }

    final newDraft = Email(
      id: widget.draft?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      sender: 'Me',
      senderEmail: 'me@example.com',
      recipients: _toController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      subject: _subjectController.text,
      body: _bodyController.text,
      date: DateTime.now(),
      attachments: List.from(_attachments),
      folder: EmailFolder.drafts,
    );
    emailService.saveOrUpdateDraft(newDraft);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft saved'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final emailService = Provider.of<EmailService>(context, listen: false);

    // Remove the old draft if we're editing one
    if (widget.draft != null) {
      emailService.removeDraft(widget.draft!.id);
    }

    try {
      await emailService.sendEmail(
        to: _toController.text.trim(),
        subject: _subjectController.text.trim(),
        body: _bodyController.text,
        // Pass cc/bcc as String? (the service will split internally)
        cc: _ccController.text.trim().isEmpty
            ? null
            : _ccController.text.trim(), // <<< changed: String? instead of List<String>?
        bcc: _bccController.text.trim().isEmpty ? null : _bccController.text.trim(), // <<< changed here as well
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email sent'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send email: $e')),
      );
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
        _saveDraft(emailService);
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
              icon: const Icon(Icons.attach_file),
              onPressed: _attachFile,
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendEmail,
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
