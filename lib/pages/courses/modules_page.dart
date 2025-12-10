import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'courses_page.dart';
import 'package:campus_app/pages/courses/course_details_page.dart';

class ModulesPage extends StatefulWidget {
  final String facultyId;
  final String facultyName;

  const ModulesPage({
    super.key,
    required this.facultyId,
    required this.facultyName,
  });

  @override
  State<ModulesPage> createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  final Client client = Client()
    ..setEndpoint('https://api-dev-app.asta-bochum.de/v1')
    ..setProject('campus_app');

  late final Databases db = Databases(client);

  List<Map<String, dynamic>> courses = [];
  List<String> modules = [];

  @override
  void initState() {
    super.initState();
    loadModules();
  }

  Future<void> loadModules() async {
    final docs = await db.listDocuments(
      databaseId: 'courses',
      collectionId: widget.facultyId,
      queries: [Query.limit(5000)],
    );

    courses = docs.documents.map((d) => d.data).toList();

    final moduleSet = <String>{};

    for (var c in courses) {
      final raw = c['module'];
      if (raw == null) continue;

      final module = raw.toString().trim();
      if (module.isNotEmpty) {
        moduleSet.add(module);
      }
    }

    setState(() => modules = moduleSet.toList()..sort());
  }

  void _openModule(String moduleName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoursesPage(
          moduleName: moduleName,
          allCourses: courses, // ✅ HIER: allCourses, nicht moduleCourses
        ),
      ),
    );
  }

  void _openCourseDetails(Map<String, dynamic> course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailsPage(course: course),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.facultyName),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: ModuleAndCourseSearchDelegate(
                modules: modules,
                courses: courses,
                onModuleTap: _openModule,
                onCourseTap: _openCourseDetails,
              ),
            );
          },
        ),
      ),
      body: modules.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: modules.length,
              itemBuilder: (context, index) {
                final module = modules[index];

                return ListTile(
                  title: Text(module),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _openModule(module),
                );
              },
            ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// 🔎 Suche in Modulen *und* Kursen innerhalb dieser Fakultät
/// ---------------------------------------------------------------------------
class ModuleAndCourseSearchDelegate extends SearchDelegate {
  final List<String> modules;
  final List<Map<String, dynamic>> courses;

  final void Function(String moduleName) onModuleTap;
  final void Function(Map<String, dynamic> course) onCourseTap;

  ModuleAndCourseSearchDelegate({
    required this.modules,
    required this.courses,
    required this.onModuleTap,
    required this.onCourseTap,
  });

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    final q = query.toLowerCase().trim();

    // Module, die zum Query passen
    final foundModules = modules.where((m) => m.toLowerCase().contains(q)).toList();

    // Kurse, die zum Query passen (Titel, ID, Modul, Dozent)
    final foundCourses = courses.where((c) {
      final title = (c['title'] ?? '').toString().toLowerCase();
      final id = (c['course_id'] ?? '').toString().toLowerCase();
      final module = (c['module'] ?? '').toString().toLowerCase();
      final lecturers = (c['lecturers'] ?? '').toString().toLowerCase();

      return title.contains(q) || id.contains(q) || module.contains(q) || lecturers.contains(q);
    }).toList();

    final tiles = <Widget>[];

    // Zuerst passende Module
    for (final module in foundModules) {
      tiles.add(
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

    // Dann passende Kurse
    for (final c in foundCourses) {
      tiles.add(
        ListTile(
          leading: const Icon(Icons.book),
          title: Text(c['title'] ?? ''),
          subtitle: Text('ID: ${c['course_id'] ?? '-'} • Modul: ${c['module'] ?? '-'}'),
          onTap: () {
            close(context, null);
            onCourseTap(c);
          },
        ),
      );
    }

    if (tiles.isEmpty) {
      return const Center(child: Text('Keine Ergebnisse'));
    }

    return ListView(children: tiles);
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}
