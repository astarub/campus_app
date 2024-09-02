import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/l10n/l10n.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/styled_html.dart';

class ImprintPage extends StatelessWidget {
  const ImprintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            // Back button & page title
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    CampusIconButton(
                      iconPath: 'assets/img/icons/arrow-left.svg',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Align(
                      child: Text(
                        AppLocalizations.of(context)!.imprintPageLegalNotice,
                        style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: SingleChildScrollView(
                  child: StyledHTML(
                    context: context,
                    text: AppLocalizations.of(context)!.imprintPageLegalNoticeText,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
