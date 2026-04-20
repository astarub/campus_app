import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

enum BubbleType { success, error, info, warning }

// this is the global bubble widget, can be expanded upon ( queuing, etc. )
class BubbleMessage extends StatefulWidget {
  final String? message;
  final double top;
  final BubbleType type;
  final VoidCallback? onClose;

  const BubbleMessage({
    super.key,
    required this.message,
    this.type = BubbleType.info,
    this.top = 108,
    this.onClose,
  });

  @override
  State<BubbleMessage> createState() => BubbleMessageState();
}

class BubbleMessageState extends State<BubbleMessage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  //widget handles its own entry and exit
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 260),
    );

    _slide = Tween(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  void exit() async {
    await _controller.reverse();
    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    final currentThemeData = Provider.of<ThemesNotifier>(context).currentThemeData;
    final bool isLightTheme = Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light;

    final Color backgroundColor;
    final Color foregroundColor;
    late String icon;

    switch (widget.type) {
      case BubbleType.error:
        foregroundColor = isLightTheme ? const Color.fromRGBO(207, 0, 0, 1) : const Color.fromRGBO(255, 72, 72, 1);
        backgroundColor = Color.alphaBlend(
          isLightTheme ? const Color.fromARGB(100, 207, 0, 0) : const Color.fromARGB(100, 255, 72, 72),
          currentThemeData.colorScheme.surface,
        );
        icon = 'assets/img/icons/error.svg';
        break;
      case BubbleType.success:
        foregroundColor =
            isLightTheme ? const Color.fromARGB(255, 31, 94, 79) : const Color.fromARGB(255, 90, 214, 206);
        backgroundColor = Color.alphaBlend(
          isLightTheme ? const Color.fromARGB(148, 59, 130, 130) : const Color.fromARGB(126, 85, 154, 162),
          currentThemeData.colorScheme.surface,
        );
        icon = 'assets/img/icons/success.svg';
        break;
      case BubbleType.warning:
        foregroundColor =
            isLightTheme ? const Color.fromARGB(255, 178, 113, 9) : const Color.fromARGB(255, 208, 113, 55);
        backgroundColor = Color.alphaBlend(
          isLightTheme ? const Color.fromARGB(120, 247, 152, 0) : const Color.fromARGB(161, 114, 59, 7),
          currentThemeData.colorScheme.surface,
        );
        icon = 'assets/img/icons/warning.svg';
        break;
      //the default is the info case
      default:
        foregroundColor = isLightTheme ? const Color.fromARGB(255, 46, 69, 100) : const Color.fromARGB(255, 35, 55, 80);
        backgroundColor = Color.alphaBlend(
          isLightTheme ? const Color.fromARGB(255, 187, 201, 218) : const Color.fromARGB(255, 177, 190, 206),
          currentThemeData.colorScheme.surface,
        );
        icon = 'assets/img/icons/info.svg';
        break;
    }

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: widget.top),
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Material(
              color: Colors.transparent,
              child: IgnorePointer(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.88,
                  ),
                  child: widget.message == null
                      ? const SizedBox.shrink(
                          key: ValueKey('no-navigation-error'),
                        )
                      : Container(
                          key: ValueKey(widget.message),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                icon,
                                colorFilter: ColorFilter.mode(
                                  foregroundColor,
                                  BlendMode.srcIn,
                                ),
                                width: 18,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  widget.message!,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: (currentThemeData.textTheme.labelSmall ?? const TextStyle()).copyWith(
                                    color: foregroundColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
