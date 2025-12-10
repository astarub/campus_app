import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'modules_page.dart';
import 'package:campus_app/pages/courses/course_details_page.dart';

class FacultiesPage extends StatefulWidget {
  const FacultiesPage({super.key});

  @override
  State<FacultiesPage> createState() => _FacultiesPageState();
}

class _FacultiesPageState extends State<FacultiesPage> {
  final Client client = Client()
    ..setEndpoint('https://api-dev-app.asta-bochum.de/v1')
    ..setProject('campus_app');

  late final Databases db = Databases(client);

  final Map<String, String> faculties = {
    "I. Evangelische Theologie": "68ff4371002b37d0785c",
    "II. Katholische Theologie": "69024b840015bdc729d8",
    "III. Philosophie/Erziehungswissenschaft": "6907ab8900018027e6e0",
    "IV. Geschichtswissenschaft": "6907df0b000832908ded",
    "V. Philologie": "690908e2000b559395bb",
    "VI. Jura": "690938f100160232c270",
    "VII. Wirtschaftswissenschaft": "6909392b001c4f530c4a",
    "VIII. Sozialwissenschaft": "69093939003a6bb8c995",
    "IX. Ostasienwissenschaft": "690939530003f03086f2",
    "X. Sportwissenschaft": "690939aa0031228ba3e2",
    "XI. Psychologie": "69093b05001a55bb235f",
    "XII. Bauingenieurwesen": "69093b23001315a99b29",
    "XIII. Maschinenbau": "69093b5e000863a43a2c",
    "XIV. Elektrotechnik": "69093b8b003b8a9295d4",
    "XV. Mathematik": "69093bb200383849e0ad",
    "XVI. Physik": "69093bcb0003eff326d7",
    "XVII. Geowissenschaften": "69093be4000d2adc74c9",
    "XVIII. Chemie/Biochemie": "691b83300017df2f3c8e",
    "XIX. Biologie/Biotechnologie": "69093bfd002faa70dae0",
    "XX. Medizin": "69093c15001f6a1b1db5",
    "XXI. Informatik": "69093c340021e62e4273",
  };

  List<Map<String, dynamic>> allCourses = [];

  @override
  void initState() {
    super.initState();
    loadAllCourses();
  }

  /// 🔥 Lädt ALLE Kurse aus allen Kollektionen
  Future<void> loadAllCourses() async {
    List<Map<String, dynamic>> temp = [];

    for (final colId in faculties.values) {
      final docs = await db.listDocuments(
        databaseId: 'courses',
        collectionId: colId,
        queries: [Query.limit(5000)],
      );

      temp.addAll(docs.documents.map((d) => d.data));
    }

    setState(() => allCourses = temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fakultäten"),
        centerTitle: true,

        /// 🔍 Globale Suche
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: GlobalCourseSearchDelegate(
                allCourses: allCourses,
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
      ),

      /// 📚 Liste aller Fakultäten
      body: ListView(
        children: faculties.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ModulesPage(
                    facultyId: entry.value,
                    facultyName: entry.key,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// 🔍 Globale Suche über ALLE Kurse aller Fakultäten
/// ---------------------------------------------------------------------------

class GlobalCourseSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> allCourses;
  final void Function(Map<String, dynamic>) onCourseTap;

  GlobalCourseSearchDelegate({
    required this.allCourses,
    required this.onCourseTap,
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

    final results = allCourses.where((c) {
      final title = (c["title"] ?? "").toString().toLowerCase();
      final id = (c["course_id"] ?? "").toString().toLowerCase();
      final module = (c["module"] ?? "").toString().toLowerCase();
      final lecturers = c["lecturers"].toString().toLowerCase();

      return title.contains(q) || id.contains(q) || module.contains(q) || lecturers.contains(q);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("Keine Kurse gefunden"));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final course = results[index];

        return ListTile(
          title: Text(course["title"] ?? ""),
          subtitle: Text("ID: ${course['course_id']} • Modul: ${course['module']}"),
          onTap: () {
            close(context, course);
            onCourseTap(course);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}
