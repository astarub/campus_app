import 'package:flutter/material.dart';
import 'dart:async';

/// Wrap a child with this widget in order to animate the child on build.
/// Can be used in combination by setting a different offset.
///
/// If used standalone, use an offset of zero.
class AnimatedEntry extends StatefulWidget {
  /// The duration of the animated entry
  final Duration duration;

  /// The interval and curve used for the entry animation
  final Interval interval;

  /// The offset of the child when animating its position.
  /// Large value -> the widget travels a longer way
  final double offset;

  /// The time until the animation should start.
  final Duration offsetDuration;

  /// The child that should be animated.
  final Widget child;

  const AnimatedEntry({
    required Key? key,
    this.duration = const Duration(milliseconds: 750),
    this.interval = const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
    this.offset = 10,
    this.offsetDuration = const Duration(milliseconds: 100),
    required this.child,
  }) : super(key: key);

  @override
  State<AnimatedEntry> createState() => AnimatedEntryState();
}

class AnimatedEntryState extends State<AnimatedEntry> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _positionAnimation;

  /// Can be called from outside in order to manually start the entry animation (again).
  Future<bool> startEntryAnimation() async {
    _animationController.reset();
    await _animationController.forward();

    return true;
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Define the animations for fading in and the offset transformation
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.interval,
    ));
    _positionAnimation = Tween(begin: widget.offset, end: 0.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.interval,
    ));

    // Start the animation on end of the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.offsetDuration == Duration.zero) {
        _animationController.forward();
      } else {
        Timer(widget.offsetDuration, () => _animationController.forward());
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AnimatedBuilder(
        animation: _positionAnimation,
        builder: (_, __) => Transform.translate(
          offset: Offset(0, _positionAnimation.value * (-1)),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Wrap a child with this widget in order to animate it before the transition to a different page.
class AnimatedExit extends StatefulWidget {
  /// The duration of the animated exit
  final Duration duration;

  /// The curve used for the exit animation
  final Curve curve;

  /// The delay after the animation has finished for a smoother page transition
  final Duration delayAfterAnimation;

  /// The child that should be blended out.
  final Widget child;

  const AnimatedExit({
    required Key? key,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOut,
    this.delayAfterAnimation = const Duration(milliseconds: 100),
    required this.child,
  }) : super(key: key);

  @override
  State<AnimatedExit> createState() => AnimatedExitState();
}

class AnimatedExitState extends State<AnimatedExit> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  double _animationOpacity = 1;

  /// Can be called from outside in order to manually start the exit animation (again).
  Future<bool> startExitAnimation() async {
    setState(() => _animationOpacity = 0);
    await _animationController.reverse();

    // Optional delay
    if (widget.delayAfterAnimation != Duration.zero) await Future.delayed(widget.delayAfterAnimation);

    return true;
  }

  /// Must be called everytime the animation should be started again.
  void resetExitAnimation() {
    setState(() => _animationOpacity = 1);
    _animationController.reset();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 1,
      lowerBound: 0.88,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
      reverseCurve: widget.curve,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _animationOpacity,
      duration: widget.duration,
      curve: widget.curve,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
