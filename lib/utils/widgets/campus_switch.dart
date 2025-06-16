// ignore_for_file: comment_references

import 'package:flutter/material.dart';

/// This widget shows a switch that uses the CampusApp design language
class CampusSwitch extends StatefulWidget {
  /// Determines if the switch is on or off.
  final bool value;

  /// Called when the user toggles the switch.
  ///
  /// [onToggle] should update the state of the parent [StatefulWidget]
  /// using the [setState] method, so that the parent gets rebuilt; for example:
  ///
  /// ```dart
  /// FlutterSwitch(
  ///   value: _status,
  ///   onToggle: (val) {
  ///     setState(() {
  ///        _status = val;
  ///     });
  ///   },
  /// ),
  /// ```
  final ValueChanged<bool> onToggle;

  /// Displays an on or off text.
  ///
  /// Text value can be override by the [activeText] and
  /// [inactiveText] properties.
  final bool showOnOff;

  /// The text to display when the switch is on.
  /// This parameter is only necessary when [showOnOff] property is true.
  ///
  /// To change value style, the following properties are available:
  ///
  /// - [activeTextColor] - The color to use on the text value when the switch is on.
  /// - [activeTextFontWeight] - The font weight to use on the text value when the switch is on.
  final String? activeText;

  /// The text to display when the switch is off.
  /// This parameter is only necessary when [showOnOff] property is true.
  ///
  /// To change value style, the following properties are available:
  ///
  /// - [inactiveTextColor] - The color to use on the text value when the switch is off.
  /// - [inactiveTextFontWeight] - The font weight to use on the text value when the switch is off.
  final String? inactiveText;

  /// The color to use on the switch when the switch is on.
  final Color activeColor;

  /// The color to use on the switch when the switch is off.
  final Color inactiveColor;

  /// The color to use on the text value when the switch is on.
  /// This parameter is only necessary when [showOnOff] property is true.
  final Color activeTextColor;

  /// The color to use on the text value when the switch is off.
  /// This parameter is only necessary when [showOnOff] property is true.
  final Color inactiveTextColor;

  /// The font weight to use on the text value when the switch is on.
  /// This parameter is only necessary when [showOnOff] property is true.
  final FontWeight? activeTextFontWeight;

  /// The font weight to use on the text value when the switch is off.
  /// This parameter is only necessary when [showOnOff] property is true.
  final FontWeight? inactiveTextFontWeight;

  /// The color to use on the toggle of the switch.
  ///
  /// If the [activeSwitchBorder] or [inactiveSwitchBorder] is used, this property must be null.
  final Color toggleColor;

  /// The color to use on the toggle of the switch when the given value is true.
  ///
  /// If [inactiveToggleColor] is used and this property is null. the value of
  /// [Colors.white] will be used.
  final Color? activeToggleColor;

  /// The color to use on the toggle of the switch when the given value is false.
  ///
  /// If [activeToggleColor] is used and this property is null. the value of
  /// [Colors.white] will be used.
  final Color? inactiveToggleColor;

  /// The given width of the switch.
  final double width;

  /// The given height of the switch.
  final double height;

  /// The size of the toggle of the switch.
  final double toggleSize;

  /// The font size of the values of the switch.
  /// This parameter is only necessary when [showOnOff] property is true.
  final double valueFontSize;

  /// The border radius of the switch.
  final double borderRadius;

  /// The shadow of the switch
  final BoxShadow toggleShadow;

  /// The padding of the switch.
  final double padding;

  /// The border of the switch.
  ///
  /// This property will give a uniform border to both states of the toggle.
  ///
  /// If the [activeSwitchBorder] or [inactiveSwitchBorder] is used, this property must be null.
  final BoxBorder? switchBorder;

  /// The border of the switch when the given value is true.
  final BoxBorder? activeSwitchBorder;

  /// The border of the switch when the given value is false.
  final BoxBorder? inactiveSwitchBorder;

  /// The border of the toggle.
  ///
  /// This property will give a uniform border to both states of the toggle
  ///
  /// If the [activeToggleBorder] or [inactiveToggleBorder] is used, this property must be null.
  final BoxBorder? toggleBorder;

  /// The border of the toggle when the given value is true.
  final BoxBorder? activeToggleBorder;

  /// The border of the toggle when the given value is false.
  final BoxBorder? inactiveToggleBorder;

  /// The icon inside the toggle when the given value is true.
  /// activeIcon can be an Icon Widget, an Image or Fontawesome Icons.
  final Widget? activeIcon;

  /// The icon inside the toggle when the given value is false.
  /// inactiveIcon can be an Icon Widget, an Image or Fontawesome Icons.
  final Widget? inactiveIcon;

  /// The duration in milliseconds to change the state of the switch
  final Duration duration;

  /// The animation curve that is used to change the state of the switch
  final Curve curve;

  /// Determines whether the switch is disabled.
  final bool disabled;

  const CampusSwitch({
    super.key,
    required this.value,
    required this.onToggle,
    this.activeColor = const Color.fromRGBO(255, 107, 1, 1),
    this.inactiveColor = const Color.fromRGBO(245, 246, 250, 1),
    this.activeTextColor = Colors.white70,
    this.inactiveTextColor = Colors.white70,
    this.toggleColor = Colors.white,
    this.activeToggleColor,
    this.inactiveToggleColor,
    this.width = 50.0,
    this.height = 30.0,
    this.toggleSize = 27.5,
    this.valueFontSize = 16.0,
    this.borderRadius = 20.0,
    this.padding = 2.5,
    this.toggleShadow = const BoxShadow(color: Colors.black26, blurRadius: 3),
    this.showOnOff = false,
    this.activeText,
    this.inactiveText,
    this.activeTextFontWeight,
    this.inactiveTextFontWeight,
    this.switchBorder,
    this.activeSwitchBorder,
    this.inactiveSwitchBorder,
    this.toggleBorder,
    this.activeToggleBorder,
    this.inactiveToggleBorder,
    this.activeIcon,
    this.inactiveIcon,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
    this.disabled = false,
  })  : assert(
            (switchBorder == null || activeSwitchBorder == null) &&
                (switchBorder == null || inactiveSwitchBorder == null),
            'Cannot provide switchBorder when an activeSwitchBorder or inactiveSwitchBorder was given\n'
            'To give the switch a border, use "activeSwitchBorder: border" or "inactiveSwitchBorder: border".'),
        assert(
            (toggleBorder == null || activeToggleBorder == null) &&
                (toggleBorder == null || inactiveToggleBorder == null),
            'Cannot provide toggleBorder when an activeToggleBorder or inactiveToggleBorder was given\n'
            'To give the toggle a border, use "activeToggleBorder: color" or "inactiveToggleBorder: color".');

  @override
  CampusSwitchState createState() => CampusSwitchState();
}

class CampusSwitchState extends State<CampusSwitch> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation toggleAnimation;

  Widget get _activeText {
    if (widget.showOnOff) {
      return Text(
        widget.activeText ?? 'On',
        style: TextStyle(
          color: widget.activeTextColor,
          fontWeight: _activeTextFontWeight,
          fontSize: widget.valueFontSize,
        ),
      );
    }

    return const Text('');
  }

  FontWeight get _activeTextFontWeight => widget.activeTextFontWeight ?? FontWeight.w900;

  Widget get _inactiveText {
    if (widget.showOnOff) {
      return Text(
        widget.inactiveText ?? 'Off',
        style: TextStyle(
          color: widget.inactiveTextColor,
          fontWeight: _inactiveTextFontWeight,
          fontSize: widget.valueFontSize,
        ),
        textAlign: TextAlign.right,
      );
    }

    return const Text('');
  }

  FontWeight get _inactiveTextFontWeight => widget.inactiveTextFontWeight ?? FontWeight.w900;

  @override
  Widget build(BuildContext context) {
    Color toggleColor = Colors.white;
    Color switchColor = Colors.white;
    Border? switchBorder;
    Border? toggleBorder;

    if (widget.value) {
      toggleColor = widget.activeToggleColor ?? widget.toggleColor;
      switchColor = widget.activeColor;
      switchBorder = widget.activeSwitchBorder as Border? ?? widget.switchBorder as Border?;
      toggleBorder = widget.activeToggleBorder as Border? ?? widget.toggleBorder as Border?;
    } else {
      toggleColor = widget.inactiveToggleColor ?? widget.toggleColor;
      switchColor = widget.inactiveColor;
      switchBorder = widget.inactiveSwitchBorder as Border? ?? widget.switchBorder as Border?;
      toggleBorder = widget.inactiveToggleBorder as Border? ?? widget.toggleBorder as Border?;
    }

    final double textSpace = widget.width - widget.toggleSize;

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SizedBox(
          width: widget.width,
          child: Align(
            child: GestureDetector(
              onTap: () {
                if (!widget.disabled) {
                  if (widget.value) {
                    animationController.forward();
                  } else {
                    animationController.reverse();
                  }

                  widget.onToggle(!widget.value);
                }
              },
              child: Opacity(
                opacity: widget.disabled ? 0.6 : 1,
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  padding: EdgeInsets.all(widget.padding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    color: switchColor,
                    border: switchBorder,
                  ),
                  child: Stack(
                    children: <Widget>[
                      AnimatedOpacity(
                        opacity: widget.value ? 1.0 : 0.0,
                        duration: widget.duration,
                        child: Container(
                          width: textSpace,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: Alignment.centerLeft,
                          child: _activeText,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: AnimatedOpacity(
                          opacity: !widget.value ? 1.0 : 0.0,
                          duration: widget.duration,
                          child: Container(
                            width: textSpace,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            alignment: Alignment.centerRight,
                            child: _inactiveText,
                          ),
                        ),
                      ),
                      Align(
                        alignment: toggleAnimation.value,
                        child: Container(
                          width: widget.toggleSize,
                          height: widget.toggleSize,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: toggleColor,
                            border: toggleBorder,
                            boxShadow: [widget.toggleShadow],
                          ),
                          child: FittedBox(
                            child: Stack(
                              children: [
                                Center(
                                  child: AnimatedOpacity(
                                    opacity: widget.value ? 1.0 : 0.0,
                                    duration: widget.duration,
                                    child: widget.activeIcon,
                                  ),
                                ),
                                Center(
                                  child: AnimatedOpacity(
                                    opacity: !widget.value ? 1.0 : 0.0,
                                    duration: widget.duration,
                                    child: widget.inactiveIcon,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(CampusSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value == widget.value) return;

    if (widget.value) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
      duration: widget.duration,
    );

    toggleAnimation = AlignmentTween(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(parent: animationController, curve: widget.curve));
  }
}
