import 'package:flutter/material.dart';
import 'package:campus_app/pages/courses/course_details_page.dart';

class CoursesPage extends StatelessWidget {
  final String moduleName;
  final List<Map<String, dynamic>> allCourses;

  const CoursesPage({
    super.key,
    required this.moduleName,
    required this.allCourses,
  });

  @override
  Widget build(BuildContext context) {
    // Alle Kurse des Moduls
    final moduleCourses = allCourses.where((c) => c['module'] == moduleName).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: CourseSearchDelegate(
                courses: moduleCourses,
                onCourseTap: (course) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseDetailsPage(course: course),
                    ),
                  );
                },
              ),
            );
          },
        ),
        title: Text(moduleName),
        centerTitle: true,
      ),

      /// LISTE ALLER KURSE IM MODUL
      body: ListView.builder(
        itemCount: moduleCourses.length,
        itemBuilder: (context, index) {
          final c = moduleCourses[index];

          return ListTile(
            title: Text(c['title']),
            subtitle: Text("Dozent: ${c['lecturers']}"),
            trailing: Text(c['type'] ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseDetailsPage(course: c),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// 🔍 CourseSearchDelegate – Suche über alle Kurse eines Moduls
/// ---------------------------------------------------------------------------
class CourseSearchDelegate extends SearchDelegate<dynamic> {
  final List<Map<String, dynamic>> courses;
  final void Function(Map<String, dynamic>)? onCourseTap;

  CourseSearchDelegate({
    required this.courses,
    this.onCourseTap,
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
    final lower = query.toLowerCase();

    final results = courses.where((c) {
      return c['title'].toLowerCase().contains(lower) || c['lecturers'].toString().toLowerCase().contains(lower);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("Keine Kurse gefunden"));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final c = results[index];

        return ListTile(
          title: Text(c['title']),
          subtitle: Text(c['lecturers'].toString()),
          onTap: () {
            close(context, c);
            if (onCourseTap != null) onCourseTap!(c);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
