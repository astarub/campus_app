import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/styled_html.dart';

class ImprintPage extends StatelessWidget {
  const ImprintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
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
                        'Impressum',
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
                    <h4>Inhaltlich Verantwortliche gemäß § 10 Absatz 3 MDStV:</h4>
  
                    Studierendenschaft der Ruhr-Universität Bochum<br>
                    Allgemeiner Studierendenausschuss<br>
                    SH 0/11<br>
                    Universitätsstr. 150<br>
                    44780 Bochum<br>
                    <br>
                    Inhaltlich Verantwortlich:<br>
                    Hanife Demir (Vorsitzende)<br>
                    <br>
                    Vertretungsberechtigter Vorstand:<br>
                    Ron Agethen<br>
                    Eren Yavuz<br>
                    Elisabeth Tilbürger<br>
                    Henry Herrmann<br>
                    Ali Sait Kücük<br>
                    <br>
                    Telefon: <a href="tel:+492343222416">+49 234 3222416</a><br>
                    E-Mail: <a href="mailto:info@asta-bochum.de">info@asta-bochum.de</a><br>
                    Internet: <a href="https://www.asta-bochum.de">https://www.asta-bochum.de</a><br>
                    <br>
                    Die Studierendenschaft ist eine Teilkörperschaft öffentlichen Rechts.
                    <br>
                    <h4>Inhalte</h4><br>
                    Die Inhalte unserer Seiten wurden mit größter Sorgfalt erstellt. Für die Richtigkeit, Vollständigkeit und Aktualität der Inhalte können wir jedoch keine Gewähr übernehmen. 
                    Als Diensteanbieter sind wir gemäß § 7 Abs.1 TMG für eigene Inhalte auf diesen Seiten nach den allgemeinen Gesetzen verantwortlich. 
                    Nach §§ 8 bis 10 TMG sind wir als Diensteanbieter jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen. 
                    Verpflichtungen zur Entfernung oder Sperrung der Nutzung von Informationen nach den allgemeinen Gesetzen bleiben hiervon unberührt.<br>Eine diesbezügliche Haftung ist jedoch erst ab dem Zeitpunkt der Kenntnis einer konkreten Rechtsverletzung möglich. 
                    Bei Bekanntwerden von entsprechenden Rechtsverletzungen werden wir diese Inhalte umgehend entfernen.
                    <h4>Haftungshinweis</h4>
                    Unser Angebot enthält Links zu externen Webseiten Dritter, auf deren Inhalte wir keinen Einfluss haben. 
                    Deshalb können wir für diese fremden Inhalte auch keine Gewähr übernehmen. 
                    Für die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber der Seiten verantwortlich. 
                    Die verlinkten Seiten wurden zum Zeitpunkt der Verlinkung auf mögliche Rechtsverstöße überprüft. 
                    Rechtswidrige Inhalte waren zum Zeitpunkt der Verlinkung nicht erkennbar. 
                    Eine permanente inhaltliche Kontrolle der verlinkten Seiten ist jedoch ohne konkrete Anhaltspunkte einer Rechtsverletzung nicht zumutbar. 
                    Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Links umgehend entfernen.
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
