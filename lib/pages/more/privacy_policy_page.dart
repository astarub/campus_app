import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/styled_html.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
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
                        'Datenschutz',
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
                    text: '''
                    <h4>Verantwortliche Stelle im Sinne der Datenschutzgesetze, insbesondere der EU-Datenschutzgrundverordnung (DSGVO), ist:</h4><br>
                    <br>
                    AStA an der Ruhr-Universität Bochum<br>
                    Hanife Demir (Vorsitzende)<br>
                    <br>
                    Studierendenhaus 0/11<br>
                    Universitätsstr. 150<br>
                    44801 Bochum<br>
                    <br>
                    Telefon: <a href="tel:+492343222416">+49 234 3222416</a><br>
                    E-Mail: <a href="mailto:info@asta-bochum.de">info@asta-bochum.de</a><br>
                    <br>
                    Sie können Sie sich jederzeit mit einer Beschwerde an die zuständige Aufsichtsbehörde wenden. Diese ist:
                    <br>
                    Landesbeauftragte für Datenschutz und Informationsfreiheit Nordrhein-Westfalen<br>
                    Postfach 20 04 44<br>
                    40102 Düsseldorf<br>
                    
                    Tel.: <a href="tel:+49211384240">+49 211 384240</a><br>
                    Fax: +49 211 3842410<br>
                    E-Mail: <a href="mailto:poststelle@ldi.nrw.de">poststelle@ldi.nrw.de</a><br>
                    Internet: <a href="https://ldi.nrw.de">poststelle@ldi.nrw.de</a>https://ldi.nrw.de<br>
                    Rechtsgrundlagen (nach Art. 13 DSGVO)<br>
                    Wir speichern Ihre Daten nur lange, wie es notwendig ist. Wir verarbeiten Ihre Daten auf den folgenden Rechtsgrundlagen:<br>
                    <br>
                    Artikel 6 Absatz 1 und Artikel 7 DSGVO für die Erfüllung von Leistungen und rechtlicher Verpflichtungen.<br>
                    Artikel 28 DSGVO für die Verarbeitung von personenbezogen Daten im Auftrag.<br>
                    Nach Ablauf der Fristen werden Ihre Daten routinemäßig gelöscht.<br>
                    ''',
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
