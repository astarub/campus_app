import 'dart:async';

import 'package:flutter/material.dart';

import 'package:campus_app/utils/widgets/bubble_message.dart';

// The bubble access point with show(), it handles disposing itself after the given duration ( in and out animation is seperate from duration )
/// A global bubble message to notify our users.
///
/// It must be called with at least context and input message. All other parameters are optional.
/// Duration note: the duration of the message is seperate from in and out animation, it won't speed up or slow down according to Duration input.
///
///Access to the Bubble has to be in the scope of a function. It's calling function show() returns a void and cannot be added into a widget tree.
class BubbleService {
  static final BubbleService instance = BubbleService.internal();
  factory BubbleService() => instance;
  BubbleService.internal();

  final GlobalKey<BubbleMessageState> _bubbleKey = GlobalKey();

  Timer? _bubbleTimer;

  OverlayEntry? _entry;

  void show(
    BuildContext context, {
    required String message,
    BubbleType type = BubbleType.info,
    Duration duration = const Duration(seconds: 2),
    double top = 108,
  }) {
    _entry?.remove();

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    _entry = OverlayEntry(
      builder: (context) => BubbleMessage(
        key: _bubbleKey,
        message: message,
        type: type,
        top: top,
        onClose: () {
          _entry?.remove();
          _entry = null;
        },
      ),
    );
    overlay.insert(_entry!);

    _bubbleTimer?.cancel();

    //ensure each bubble stays its duration with it's own timer, cancel potential lingering old timers before every use
    _bubbleTimer = Timer(duration, () {
      _bubbleKey.currentState?.exit();
    });
  }
}
