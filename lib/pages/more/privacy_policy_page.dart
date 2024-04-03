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
                    <h2>Verantwortliche Stelle im Sinne der Datenschutzgesetze, insbesondere der EU-Datenschutzgrundverordnung (DSGVO), ist:</h2><br>
                    <br>
                    AStA an der Ruhr-Universität Bochum<br>
                    Paul Hoffstiepel (Vorsitzender)<br>
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
                    <br>
                    <h2>Datenverarbeitung durch die Nutzung der Campus App</h2><br>
                    Bei der Nutzung der Campus App werden Daten erhoben und ausgetauscht, die zur Verwendung des Angebotes erforderlich sind. Dies sind:<br>
                    - IP-Adresse<br>
                    - Verwendetes Betriebssystem<br>
                    - Uhrzeit der Serveranfrage<br>
                    - Übertragene Datenmenge<br>
                    - Standortdaten<br>
                    <br>
                    Diese Daten werden bei der Nutzung der Campus App ebenfalls in Log-Dateien über den Zeitpunkt des Besuches hinaus auf einem Server, welcher durch den AStA betrieben wird und ggf. auf einem Server einer besuchten Seite gespeichert.<br>
                    Unsere App stellt Neuigkeiten verschiedener Internetseiten bereit, die nicht von der verfassten Studierendenschaft der Ruhr-Universität Bochum betrieben werden. 
                    Ein Einfluss auf die Verarbeitung der dort erhobenen Daten besteht nicht. 
                    Die oben genannten Nutzungsdaten werden dabei an folgende Anbieter übermittelt: <br>
                    - ruhr-uni-bochum.de, Universitätsstraße 150, 44801 Bochum. Datenschutzerklärung: <a href="https://www.ruhr-uni-bochum.de/de/datenschutz">https://www.ruhr-uni-bochum.de/de/datenschutz</a><br>
                    <br>
                    Bei der Installation der App werden Benutzer:innen danach gefragt, ob sie Push Notifications zu bestimmten Themen bekommen möchten. 
                    Wenn Nutzer:innen in den Bezug von Push Notifications Einwilligen werden personenbezogene Daten wie z.B. IP Adresse und die gewählten Themen an Server der Firma Google Inc. übertragen. 
                    Die Daten werden die Daten ohne angemessenes Schutzniveau im Sinne von Art 46 DSGVO an Server von Google in die USA übertragen. 
                    Siehe dazu auch „Schrems II-Urteil“  (Az.: C-311/18 vom 16.07.2020) des EuGH. 
                    Es besteht das Risiko, dass US-Sicherheitsbehörden auf die Daten zugreifen ohne dass Betroffene darüber Informiert werden und ohne dass Rechtsbehelfe eingelegt werden können. 
                    Die Übermittlung erfolgt daher nur auf der ausdrücklichen Einwilligung nach Art. 49 Abs 1 a der DSGVO.
                    <br>
                    Die Einwilligung kann jederzeit in der Campus App unter dem Menupunkt „Mehr“, im Untermenü „Einstellungen“ widerrufen werden.<br>
                    <br>
                    Weitere Informationen in den Datenschutzhinweisen zu Firebase von Google: <a href="https://firebase.google.com/support/privacy"https://firebase.google.com/support/privacy</a><br>
                    „Schrems II“ – Urteil des EuGH: <a href="https://curia.europa.eu/juris/liste.jsf?language=de&num=C-311/18">https://curia.europa.eu/juris/liste.jsf?language=de&num=C-311/18</a><br>
                    <br>
                    Die Campus App enthält Links zu Webseiten anderer Anbieter.<br>
                    Wir haben keinen Einfluss darauf, dass diese Anbieter die Datenschutzbestimmungen einhalten.<br> 
                    Eine permanente Überprüfung der Links ist ohne konkrete Hinweise auf Rechtsverstöße nicht zumutbar.<br> 
                    Bei Bekanntwerden von Rechtsverstößen werden betroffene Links unverzüglich gelöscht.<br>
                    <br>
                    Bei der Nutzung des Raumfinders der Campus App, werden die aktuellen Standortdaten des Endgerätes verabeitet und bis zum Schließen der App zwischengespeichert.<br> 
                    Eine Einwilligung wird hierfür vom Betriebssystem eingeholt und kann jederzeit durch den Nutzer widerrufen werden.<br>
                    <br>
                    Bei der Nutzung der Funktion zum Anzeigen des Semestertickets werden die RUB Logindaten (LoginID, Passwort) lokal auf dem Gerät gespeichert, dies ist zum Abrufen des Tickets unabdingbar. Eine Übermittlung der Daten erfolgt nur an den offizielen SSO Provider der RUB.
                    <br>
                    <h2>Zweck der Datenverarbeitung</h2><br>
                    Die Verarbeitung der personenbezogenen Daten der Nutzer ist für den ordnungsgemäßen Betrieb der App erforderlich.<br> 
                    Dabei ist es unerlässlich, dass beispielsweise beim Abrufen der Speisepläne durch einen Server des AStAs personenbezogene Daten erhoben werden.<br>
                    Des Weiteren werden beim Laden der Artikel im Newsfeed, Daten an die oben genannten Seiten übermittelt.<br>
                    <br>
                    <h2>Löschung bzw. Sperrung der Daten</h2><br>
                    Nach den Grundsätzen der Datenvermeidung und der Datensparsamkeit speichern wir alle Daten, die wir für die in dieser Datenschutzerklärung genannten bzw. anderen rechtlich vorgeschriebenen Gründe erhoben haben nur so lange, wie dies für den jeweiligen Zweck notwendig ist. Nach Wegfall des Zweckes bzw. nach Ablauf der Fristen werden die Daten entsprechend der gesetzlichen Vorgaben gelöscht, vernichtet oder gesperrt.<br>
                    <br>
                    Gesetzliche Grundlagen für die Aufbewahrungsfristen werden in der Abgabenordnung §§ 147 und 257 geregelt.<br>
                    <br>
                    <h2>Rechtsgrundlagen (nach Art. 13 DSGVO)</h2><br>
                    Wir speichern Ihre Daten nur lange, wie es notwendig ist. Wir verarbeiten Ihre Daten auf den folgenden Rechtsgrundlagen:<br>
                    <br>
                    Artikel 6 Absatz 1 und Artikel 7 DSGVO für die Erfüllung von Leistungen und rechtlicher Verpflichtungen.<br>
                    Artikel 28 DSGVO für die Verarbeitung von personenbezogen Daten im Auftrag.<br>
                    Nach Ablauf der Fristen werden Ihre Daten routinemäßig gelöscht.<br>
                    <br>
                    <h2>Ihre Rechte</h2><br>
                    Die Datenschutzgrundverordnung räumt Ihnen folgende Rechte ein:<br>
                    <br>
                    Verlangen einer Bestätigung über die Verarbeitung Sie betreffender personenbezogener Daten (Art. 15)<br>
                    Verlangen einer Kopie der Daten (Art. 15)<br>
                    Recht auf Korrektur unrichtiger Sie betreffender personenbezogener Daten (Art. 16)<br>
                    Recht auf Vervollständigung unvollständiger, Sie betreffender personenbezogener Daten (Art. 16)<br>
                    Recht auf Löschung Sie betreffender personenbezogener Daten („Recht auf Vergessenwerden“ Art. 17)<br>
                    Recht auf Einschränkung Sie betreffender personenbezogener Daten (Art. 18)<br>
                    Recht auf die Übertragung der Daten an einen Dritten (Art. 20)<br>
                    Beschwerde bei der oben genannten Aufsichtsbehörde (Art. 77)<br>
                    Erteilte Einwilligungen können Sie mit Wirkung für die Zukunft widerrufen (Art. 7 Abs. 3)<br>
                    Recht auf Widerspruch der Verarbeitung Sie betreffender personenbezogener Daten (Art. 21)<br>
                    Sollten Sie Fragen zu einzelnen Punkten haben oder eines Ihrer Rechte ausüben wollen, wenden Sie sich an die oben angegebene verantwortliche Stelle oder an unseren Datenschutzbeauftragten unter datenschutz@asta-bochum.de.<br>
                    <br>
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
