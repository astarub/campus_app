import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_switch.dart';

/// This widget displays a [Text] and a [CampusSwitch] widget in a row.
class LeadingTextSwitch extends StatelessWidget {
  /// The description for the switch
  final String text;

  /// Wether the switch should be a active or not
  final bool isActive;

  /// The callback that is executed whenever the value of the switch changes
  final ValueChanged<bool> onToggle;

  const LeadingTextSwitch({
    Key? key,
    required this.text,
    required this.isActive,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
        ),
        CampusSwitch(value: isActive, onToggle: onToggle),
      ],
    );
  }
}
