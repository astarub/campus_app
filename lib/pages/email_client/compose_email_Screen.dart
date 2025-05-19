import 'package:flutter/material.dart';
import 'package:campus_app/pages/email_client/models/email.dart';

class ComposeEmailScreen extends StatefulWidget {
  final Email? replyTo;
  final Email? forwardFrom;

  const ComposeEmailScreen({
    super.key,
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
  List<String> _attachments = [];

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if replying or forwarding
    if (widget.replyTo != null) {
      _toController.text = widget.replyTo!.senderEmail;
      _subjectController.text = 'Re: ${widget.replyTo!.subject}';
      _bodyController.text = '\n\n----------\n${widget.replyTo!.body}';
    } else if (widget.forwardFrom != null) {
      _subjectController.text = 'Fwd: ${widget.forwardFrom!.subject}';
      _bodyController.text = '\n\n----------\n${widget.forwardFrom!.body}';
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

  void _sendEmail() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email sent')),
      );
      Navigator.pop(context);
    }
  }

  void _attachFile() async {
    // TODO: Implement file attachment
    setState(() {
      _attachments.add('file_${_attachments.length + 1}.pdf');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.replyTo != null ? 'Reply' : 'Compose'),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // To Field
              TextFormField(
                controller: _toController,
                decoration: const InputDecoration(
                  labelText: 'To',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter recipient';
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
                  child: Text(_showCcBcc ? 'Hide CC/BCC' : 'Add CC/BCC'),
                ),
              ),

              // CC Field (conditional)
              if (_showCcBcc) ...[
                TextFormField(
                  controller: _ccController,
                  decoration: const InputDecoration(
                    labelText: 'CC',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // BCC Field (conditional)
              if (_showCcBcc) ...[
                TextFormField(
                  controller: _bccController,
                  decoration: const InputDecoration(
                    labelText: 'BCC',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Subject Field
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
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
    );
  }
}