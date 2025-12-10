import 'package:flutter/material.dart';

class ModuleAndCourseSearchDelegate extends SearchDelegate {
  final List<String> modules;
  final List<Map<String, dynamic>> courses;

  final void Function(Map<String, dynamic>) onCourseTap;
  final void Function(String moduleName) onModuleTap;

  ModuleAndCourseSearchDelegate({
    required this.modules,
    required this.courses,
    required this.onCourseTap,
    required this.onModuleTap,
  });

  @override
  List<Widget>? buildActions(BuildContext context) =>
      [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    final q = query.toLowerCase();

    /// 🔍 Module filtern
    final foundModules = modules.where((m) => m.toLowerCase().contains(q)).toList();

    /// 🔍 Kurse filtern (Titel, Dozent, ID, Modul)
    final foundCourses = courses.where((c) {
      final title = (c["title"] ?? "").toString().toLowerCase();
      final id = (c["course_id"] ?? "").toString().toLowerCase();
      final module = (c["module"] ?? "").toString().toLowerCase();
      final lecturers = c["lecturers"].toString().toLowerCase();

      return title.contains(q) || id.contains(q) || module.contains(q) || lecturers.contains(q);
    }).toList();

    final items = <Widget>[];

    /// MODULE ERGEBNISSE
    for (final module in foundModules) {
      items.add(
        ListTile(
          leading: const Icon(Icons.folder),
          title: Text(module),
          onTap: () {
            close(context, null);
            onModuleTap(module);
          },
        ),
      );
    }

    /// KURS ERGEBNISSE
    for (final c in foundCourses) {
      items.add(
        ListTile(
          leading: const Icon(Icons.book),
          title: Text(c["title"] ?? ""),
          subtitle: Text("ID: ${c["course_id"]} • Modul: ${c["module"]}"),
          onTap: () {
            close(context, null);
            onCourseTap(c);
          },
        ),
      );
    }

    if (items.isEmpty) {
      return const Center(child: Text("Keine Ergebnisse"));
    }

    return ListView(children: items);
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}
