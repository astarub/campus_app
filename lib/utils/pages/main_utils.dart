import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class MainUtils {}

enum FGBGType { foreground, background }

/// This stream listener gives the possibility to listen to if the app is
/// currently in the foreground or in the background.
///
/// Flutter has WidgetsBindingObserver to get notified when app changes its state
/// from active to inactive states and back. But it actually includes the state
/// changes of the embedding Activity/ViewController as well.
///
/// This stream however, reports the events only at app level.
///
/// Usage example:
/// ```
/// subscription = FGBGEvents.stream.listen((event) {
///   print(event); // FGBGType.foreground or FGBGType.background
/// });
/// ```
class FGBGEvents {
  static const _channel = EventChannel('events');
  static Stream<FGBGType>? _stream;

  static Stream<FGBGType> get stream {
    return _stream ??= _channel
        .receiveBroadcastStream()
        .map((event) => event == 'foreground' ? FGBGType.foreground : FGBGType.background);
  }
}
