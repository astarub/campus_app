import 'package:campus_app/core/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class NavigationErrorBubble extends StatelessWidget {
  final String? message;
  final double top;

  const NavigationErrorBubble({
    super.key,
    required this.message,
    this.top = 108,
  });

  @override
  Widget build(BuildContext context) {
    final currentThemeData =
        Provider.of<ThemesNotifier>(context).currentThemeData;
    final bool isLightTheme =
        Provider.of<ThemesNotifier>(context, listen: false).currentTheme ==
            AppThemes.light;
    final Color backgroundColor = Color.alphaBlend(
      isLightTheme
          ? const Color.fromARGB(100, 207, 0, 0)
          : const Color.fromARGB(100, 255, 72, 72),
      currentThemeData.colorScheme.surface,
    );
    final Color foregroundColor = isLightTheme
        ? const Color.fromRGBO(207, 0, 0, 1)
        : const Color.fromRGBO(255, 72, 72, 1);

    return Positioned(
      top: top,
      left: 20,
      right: 20,
      child: IgnorePointer(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.88,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final slideAnimation = Tween<Offset>(
                  begin: const Offset(0, -0.35),
                  end: Offset.zero,
                ).animate(animation);
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: child,
                  ),
                );
              },
              child: message == null
                  ? const SizedBox.shrink(
                      key: ValueKey('no-navigation-error'),
                    )
                  : Container(
                      key: ValueKey(message),
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
                            'assets/img/icons/error.svg',
                            colorFilter: ColorFilter.mode(
                              foregroundColor,
                              BlendMode.srcIn,
                            ),
                            width: 18,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              message!,
                              textAlign: TextAlign.center,
                              style: (currentThemeData.textTheme.labelSmall ??
                                      const TextStyle())
                                  .copyWith(
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
    );
  }
}
