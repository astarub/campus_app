// ignore_for_file: prefer_int_literals

import 'dart:async';
import 'package:flutter/material.dart';

/// This widget animates its child with a fade- and position-animation in.
///
/// Adjust the `interval` with steps of 0.08 in order to achieve a
/// synced animation that looks like it depens on the previous widget.
class AnimatedOnboardingEntry extends StatefulWidget {
  /// The duration of the animated exit
  final Duration duration;

  /// The interval and curve used for the animation
  final Interval interval;

  /// The offset of the child when animating its position.
  /// Larger value -> the widget travels a longer way
  final double offset;

  // The time until the animation should start.
  final Duration offsetDuration;

  /// The child that should that should be blended out
  final Widget child;

  const AnimatedOnboardingEntry({
    Key? key,
    this.duration = const Duration(milliseconds: 850),
    this.interval = const Interval(0, 1, curve: Curves.easeOutCubic),
    this.offset = 10,
    this.offsetDuration = Duration.zero,
    required this.child,
  }) : super(key: key);

  @override
  _AnimatedOnboardingEntryState createState() => _AnimatedOnboardingEntryState();
}

class _AnimatedOnboardingEntryState extends State<AnimatedOnboardingEntry> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Define animations for fading in and offset transformation
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.interval,
    ));
    _positionAnimation = Tween(begin: widget.offset, end: 0.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.interval,
    ));

    // Start animation on end of the frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.offsetDuration == Duration.zero) {
        _animationController.forward();
      } else {
        Timer(widget.offsetDuration, _animationController.forward);
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

/// This widget animates its child with a fade-, scale- and position-animation.
/// Can be used to make the logo looks like flying into screen from above.
class AnimatedOnboardingLogo extends StatefulWidget {
  /// The time until the animation should start
  final Duration offsetDuration;

  /// The logo that should be displayed
  final Widget logo;

  const AnimatedOnboardingLogo({
    Key? key,
    this.offsetDuration = Duration.zero,
    required this.logo,
  }) : super(key: key);

  @override
  _AnimatedOnboardingLogoState createState() => _AnimatedOnboardingLogoState();
}

class _AnimatedOnboardingLogoState extends State<AnimatedOnboardingLogo> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Define animations for positioning and fading
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0, 1, curve: Curves.easeOutCubic),
    ));
    _scaleAnimation = Tween(begin: 1.9, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0, 1, curve: Curves.easeOutExpo),
    ));
    _positionAnimation = Tween(begin: 800.0, end: 0.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0, 1, curve: Curves.easeOutExpo),
    ));

    // Start animation on end of the frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.offsetDuration == Duration.zero) {
        _animationController.forward();
      } else {
        Timer(widget.offsetDuration, _animationController.forward);
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
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: _positionAnimation,
          builder: (_, __) => Transform.translate(
            offset: Offset(0, _positionAnimation.value),
            child: widget.logo,
          ),
        ),
      ),
    );
  }
}
