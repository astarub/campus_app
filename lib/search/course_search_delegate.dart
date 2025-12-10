import 'package:flutter/material.dart';

class CourseSearchDelegate extends SearchDelegate<dynamic> {
  /// Liste aller Kurse, z. B. aus Appwrite geladen
  final List<Map<String, dynamic>> courses;

  /// Wird aufgerufen, wenn der User auf einen Kurs tippt
  final void Function(Map<String, dynamic> course)? onCourseTap;

  CourseSearchDelegate({
    required this.courses,
    this.onCourseTap,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final text = query.toLowerCase();

    final results = courses.where((c) {
      final title = (c["title"] ?? "").toString().toLowerCase();
      final module = (c["module"] ?? "").toString().toLowerCase();
      final lecturers = (c["lecturers"] ?? []).toString().toLowerCase();

      return title.contains(text) || module.contains(text) || lecturers.contains(text);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("Keine Kurse gefunden"));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, i) {
        final c = results[i];
        return ListTile(
          title: Text(c["title"]?.toString() ?? ""),
          subtitle: Text(c["module"]?.toString() ?? ""),
          onTap: () {
            // Suche schließen
            close(context, c);

            // Callback nach draußen, wenn gesetzt
            if (onCourseTap != null) {
              onCourseTap!(c);
            }
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final text = query.toLowerCase();

    final suggestions = courses.where((c) {
      final title = (c["title"] ?? "").toString().toLowerCase();
      return title.contains(text);
    }).toList();

    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, i) {
        final c = suggestions[i];
        return ListTile(
          title: Text(c["title"]?.toString() ?? ""),
          onTap: () {
            // Direkt Ergebnis für diesen Kurs anzeigen
            query = c["title"]?.toString() ?? "";
            showResults(context);
          },
        );
      },
    );
  }
}
