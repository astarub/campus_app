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

  // Check if the current composition is empty
  /*
  bool _isCompositionEmpty() {
    return _toController.text.trim().isEmpty &&
        _ccController.text.trim().isEmpty &&
        _bccController.text.trim().isEmpty &&
        _subjectController.text.trim().isEmpty &&
        _bodyController.text.trim().isEmpty &&
        _attachments.isEmpty;
  } */

  // Check if the composition has any meaningful content
  bool _hasContent() {
    return _toController.text.trim().isNotEmpty ||
        _subjectController.text.trim().isNotEmpty ||
        _bodyController.text.trim().isNotEmpty ||
        _attachments.isNotEmpty;
  }

  // Save or update the draft only if it has content
  void _saveDraft(EmailService emailService) {
    // Only save if there's actual content
    if (!_hasContent()) {
      // If this was an existing draft that's now empty, remove it
      if (widget.draft != null) {
        emailService.removeDraft(widget.draft!.id);
      }
      return; // Don't save empty compositions
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

  // Send email and remove draft if exists
  void _sendEmail() {
    if (_formKey.currentState!.validate()) {
      final emailService = Provider.of<EmailService>(context, listen: false);
      if (widget.draft != null) {
        emailService.removeDraft(widget.draft!.id);
      }

      // TODO: Implement actual sending logic here

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email sent')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _attachFile() async {
    // TODO: Implement file attachment
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
              tooltip: 'Attach file',
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendEmail,
              tooltip: 'Send',
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // To Field
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

                    final emails = value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);
                    for (final email in emails) {
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                        return 'Invalid email: $email';
                      }
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // CC/BCC Toggle
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => setState(() => _showCcBcc = !_showCcBcc),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(_showCcBcc ? 'Hide CC/BCC' : 'Add CC/BCC'),
                  ),
                ),

                // CC Field (conditional)
                if (_showCcBcc) ...[
                  TextFormField(
                    controller: _ccController,
                    decoration: InputDecoration(
                      labelText: 'CC',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // BCC Field (conditional)
                if (_showCcBcc) ...[
                  TextFormField(
                    controller: _bccController,
                    decoration: InputDecoration(
                      labelText: 'BCC',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Subject Field
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Attachments
                if (_attachments.isNotEmpty) ...[
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _attachments.length,
                      itemBuilder: (context, index) => Chip(
                        label: Text(_attachments[index]),
                        backgroundColor: Theme.of(context).chipTheme.backgroundColor,
                        deleteIconColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => setState(() => _attachments.removeAt(index)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Email Body
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
