import 'package:flutter/material.dart';

class CourseDetailsPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailsPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final List<dynamic> termine = course["termine"] ?? [];
    final String type = course["type"] ?? "";

    // -------------------------
    // TERMIN-TRENNUNG
    // -------------------------

    List<String> vorlesung = [];
    List<String> uebung = [];

    if (type == "Vorlesung") {
      vorlesung = termine.cast<String>();
    } else if (type == "Übung") {
      uebung = termine.cast<String>();
    } else if (type == "Vorlesung mit Übung") {
      for (int i = 0; i < termine.length; i++) {
        if (i.isEven) {
          vorlesung.add(termine[i]);
        } else {
          uebung.add(termine[i]);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          course["title"] ?? "Kursdetails",
          style: TextStyle(color: scheme.onSurface),
        ),
        backgroundColor: scheme.surface,
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      backgroundColor: scheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: DefaultTextStyle(
          style: TextStyle(color: scheme.onSurface),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titel
              Text(
                course["title"] ?? "",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),

              const SizedBox(height: 14),

              _info(context, "Modul", course["module"]),
              _info(context, "Kurs-ID", course["course_id"].toString()),
              _info(context, "Typ", course["type"]),
              _info(context, "Dozenten", course["lecturers"].toString()),

              const SizedBox(height: 26),

              // -----------------------
              // Vorlesungstermine
              // -----------------------
              if (vorlesung.isNotEmpty)
                Text(
                  "Vorlesungstermine",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                ),

              ...vorlesung.map((t) => _termCard(context, t)),
              const SizedBox(height: 20),

              // -----------------------
              // Übungstermine
              // -----------------------
              if (uebung.isNotEmpty)
                Text(
                  "Übungstermine",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                ),

              ...uebung.map((t) => _termCard(context, t)),

              if (uebung.isEmpty && vorlesung.isEmpty)
                Text(
                  "Keine Termine gefunden.",
                  style: TextStyle(fontSize: 16, color: scheme.onSurface),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------
  // INFO TEXT
  // -------------------------
  Widget _info(BuildContext context, String label, String value) {
    final color = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label: ",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------
  // TERMIN CARD
  // -------------------------
  Widget _termCard(BuildContext context, String text) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      color: scheme.surfaceVariant,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          text,
          style: TextStyle(color: scheme.onSurface),
        ),
      ),
    );
  }
}
