import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color splashColor;
  final Color highlightColor;
  final BorderRadius borderRadius;
  final VoidCallback tapHandler;
  final Widget child;

  const CustomButton({
    Key? key,
    this.splashColor = const Color.fromRGBO(0, 0, 0, 0.03),
    this.highlightColor = const Color.fromRGBO(0, 0, 0, 0.05),
    this.borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10)),
    required this.tapHandler,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: tapHandler,
        splashColor: splashColor,
        highlightColor: highlightColor,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}
