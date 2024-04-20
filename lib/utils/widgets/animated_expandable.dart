import 'package:flutter/material.dart';

/// This widget allows to collapse and expand a list of widgets
class AnimatedExpandable extends StatefulWidget {
  /// The children that are hidden when the widget is collapsed
  final List<Widget> children;

  /// Whether the widget should be expanded on first build or not
  final bool expandedAtStart;

  /// The duration that is used for the animation
  final Duration animationDuration;

  /// The curve that is used for the animation
  final Curve animationCurve;

  const AnimatedExpandable({
    Key? key,
    required this.children,
    this.expandedAtStart = false,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.fastOutSlowIn,
  }) : super(key: key);

  @override
  AnimatedExpandableState createState() => AnimatedExpandableState();
}

class AnimatedExpandableState extends State<AnimatedExpandable> with SingleTickerProviderStateMixin {
  // Animation properties for showing & hiding the childrens
  late final AnimationController _expandController;
  late final Animation<double> _animation;
  late bool _isExpanded;

  /// Can be used to open or close the expandable widget from outside
  void toggleExpand() {
    setState(() => _isExpanded = !_isExpanded);
    _animateExpand();
  }

  void _animateExpand() {
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();

    // Initializing the controller used for the expand animation
    _expandController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Defining the expand animation
    final Animation<double> curvedAnimation = CurvedAnimation(
      parent: _expandController,
      curve: widget.animationCurve,
    );
    
    // ignore: prefer_int_literals
    _animation = Tween(begin: 0.0, end: 1.0).animate(curvedAnimation);

    // Applying initial state of sectionExpanded value
    _isExpanded = widget.expandedAtStart;
    _animateExpand();
  }

  @override
  void didUpdateWidget(AnimatedExpandable oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When updating expanded value from outside by setState
    _animateExpand();
  }

  @override
  void dispose() {
    _expandController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      //axisAlignment: 1, // looks like moving to top instead of collapsing
      sizeFactor: _animation,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: widget.children.length,
        itemBuilder: (context, index) {
          return widget.children[index];
        },
      ),
    );
  }
}
