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
    super.key,
    required this.text,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
          ),
          CampusSwitch(
            value: isActive,
            onToggle: onToggle,
            activeColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.secondary,
            inactiveColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                ? const Color.fromRGBO(245, 246, 250, 1)
                : const Color.fromRGBO(34, 40, 54, 1),
          ),
        ],
      ),
    );
  }
}
