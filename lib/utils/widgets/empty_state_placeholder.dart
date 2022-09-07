import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/core/themes.dart';

/// This widget displays a placeholder for empty states, for example
/// when a list is empty.
///
/// It can show an illustration above the title.
class EmptyStatePlaceholder extends StatelessWidget {
  /// The short title that is displayed below the illustration
  final String title;

  /// A description or call to action that is displayed below the title
  final String text;

  /// An optional illustration that can be displayed above the title.
  ///
  /// Can be either an Image- (.png, .jpg. etc) or Svg-file.
  final String illustrationPath;

  const EmptyStatePlaceholder({
    Key? key,
    required this.title,
    required this.text,
    this.illustrationPath = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (illustrationPath != '')
          illustrationPath.substring(illustrationPath.length - 3) == 'svg'
              ? SvgPicture.asset(illustrationPath)
              : Image.asset(illustrationPath),
        Text(
          title,
          style: Provider.of<ThemesNotifier>(context)
              .currentThemeData
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.grey),
        ),
        Text(
          text,
          style:
              Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
