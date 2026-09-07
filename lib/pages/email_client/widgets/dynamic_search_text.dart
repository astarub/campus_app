import 'dart:async';

import 'package:flutter/material.dart';

/// A simple Dynamic Typing Text that cycles through a set of Messages
///
/// This Widget has a default set of Messages that can be overwritten via input paramater 'messages:'
/// The typing Speed can also be customized with the characterTimer (amount of time until next character is typed) and messageTimer (how long each message lasts)
class DynamicSearchText extends StatefulWidget {
  final List<String>? messages;
  final Duration? characterTimer;
  final Duration? messageTimer;
  const DynamicSearchText({
    super.key,
    this.messages,
    this.characterTimer = const Duration(milliseconds: 75),
    this.messageTimer = const Duration(milliseconds: 2500),
  });

  @override
  State<DynamicSearchText> createState() => _DynamicSearchTextState();
}

class _DynamicSearchTextState extends State<DynamicSearchText> {
  static const _default = [
    'Indexing mailbox...',
    'Searching for Emails...',
    'Loading results...',
  ];

  List<String> _messages = [];
  int _messageIndex = 0;
  int _charIndex = 0;
  Timer? _charTimer;
  Timer? _messageTimer;

  @override
  void initState() {
    super.initState();
    if (widget.messages == null) {
      _messages = _default;
    }
    _startTyping();
  }

  void _startTyping() {
    _charTimer = Timer.periodic(widget.characterTimer!, (_) {
      if (!mounted) return;
      final current = _messages[_messageIndex];
      if (_charIndex < current.length) {
        setState(() {
          _charIndex++;
        });
      }
    });

    _messageTimer = Timer.periodic(widget.messageTimer!, (_) {
      if (!mounted) return;
      setState(() {
        _messageIndex = (_messageIndex + 1) % _messages.length;
        _charIndex = 0;
      });
    });
  }

  @override
  void dispose() {
    _charTimer?.cancel();
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = _messages[_messageIndex].substring(0, _charIndex);
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
    );
  }
}
