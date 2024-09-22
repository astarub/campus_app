import 'package:flutter/material.dart';

/// This widget animates its child in and out.
///
/// The animation can be started in forward and reverse direction from
/// outside the class by refereing to the [AnimatedConditionalState] with a GlobalKey.
class AnimatedConditional extends StatefulWidget {
  /// The duration of the animation
  final Duration duration;

  /// The interval and curve used for the animation
  final Interval interval;

  /// The child that should be animated
  final Widget child;

  const AnimatedConditional({
    super.key,
    this.duration = const Duration(milliseconds: 200),
    this.interval = const Interval(0, 1, curve: Curves.ease),
    required this.child,
  });

  @override
  State<AnimatedConditional> createState() => AnimatedConditionalState();
}

class AnimatedConditionalState extends State<AnimatedConditional> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  void animateIn() {
    _animationController.reverse();
  }

  void animateOut() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, _) => Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Define the animations for fading in and the scale transformation
    // ignore: prefer_int_literals
    _fadeAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.interval,
      ),
    );

    // ignore: prefer_int_literals
    _scaleAnimation = Tween(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.interval,
      ),
    );
  }
}
