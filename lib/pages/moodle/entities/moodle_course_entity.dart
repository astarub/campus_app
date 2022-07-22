import 'package:cached_network_image/cached_network_image.dart';

class MoodleCourseEntity {
  final int id;
  final String shortname;
  final String fullname;
  final int enrolledusercount;
  final bool visible;
  final String summary;
  // final String format;
  // final int category;
  // final DateTime startdate;
  // final DateTime enddate;
  // final DateTime lastaccess;
  final CachedNetworkImage? image;

  MoodleCourseEntity({
    required this.id,
    required this.enrolledusercount,
    required this.fullname,
    required this.image,
    required this.shortname,
    required this.summary,
    required this.visible,
  });
}


/// Example course as json:
// {
//     "id": 10567,
//     "shortname": "AStA &amp; StuPa RUB",
//     "fullname": "Allgemeiner Studierenden Ausschuss  &amp; Studierendenparlament der Ruhr-Universit\u00e4t Bochum",
//     "displayname": "Allgemeiner Studierenden Ausschuss  &amp; Studierendenparlament der Ruhr-Universit\u00e4t Bochum",
//     "enrolledusercount": 887,
//     "idnumber": "",
//     "visible": 1,
//     "summary": "<p>Dies ist der offizielle Moodle Kurs des Allgemeinen Studierenden Ausschusses (AStA) der Ruhr-Universit\u00e4t Bochum.</p><p>F\u00fcr den Moodle Kurs braucht ihr kein Passwort.</p><p>F\u00fcr Fragen und Ideen stehen wir euch zur Verf\u00fcgung unter:\u00a0</p>tim.barsch@asta-bochum.de<br /><br />Dieser Moodle Kurs soll auf Veranstaltungen, Wahlen, \u00c4nderungen und vieles mehr innerhalb der Ruhr-Universit\u00e4t Bochum aufmerksam machen.<br />",
//     "summaryformat": 1,
//     "format": "multitopic",
//     "showgrades": false,
//     "lang": "",
//     "enablecompletion": false,
//     "completionhascriteria": false,
//     "completionusertracked": false,
//     "category": 14,
//     "progress": null,
//     "completed": null,
//     "startdate": 1493935200,
//     "enddate": 0,
//     "marker": 5,
//     "lastaccess": 1650584538,
//     "isfavourite": false,
//     "hidden": false,
//     "overviewfiles": [
//         {
//             "filename": "AStA_Logo_Quer.png",
//             "filepath": "/",
//             "filesize": 518580,
//             "fileurl": "https://moodle.ruhr-uni-bochum.de/webservice/pluginfile.php/630723/course/overviewfiles/AStA_Logo_Quer.png",
//             "timemodified": 1614352827,
//             "mimetype": "image/png"
//         }
//     ]
// }

