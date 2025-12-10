import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class CourseService {
  CourseService() {
    _client
      ..setEndpoint('https://api-dev-app.asta-bochum.de/v1')
      ..setProject('campus_app');
  }

  final Client _client = Client();
  Databases get _db => Databases(_client);

  static const String _databaseId = 'courses';

  static const List<String> _facultyCollectionIds = [
    "691b83300017df2f3c8e",
    "69093c340021e62e4273",
    "69093c15001a6a1b1db5",
    // usw… (REST bleibt)
  ];

  Future<List<Map<String, dynamic>>> loadAllCourses() async {
    final List<Map<String, dynamic>> all = [];

    for (final collectionId in _facultyCollectionIds) {
      final docs = await _db.listDocuments(
        databaseId: _databaseId,
        collectionId: collectionId,
        queries: [
          Query.limit(5000),
        ],
      );

      for (final doc in docs.documents) {
        all.add(doc.data);
      }
    }

    return all;
  }
}
