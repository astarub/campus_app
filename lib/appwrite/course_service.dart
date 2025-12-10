import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'appwrite_client.dart';

class CourseService {
  final Databases db = Databases(AppwriteClient.getClient());
  final String databaseId = "courses";

  // alle Fakultäts-Collection-IDs
  final List<String> facultyCollections = [
    "68ff4371002b37d0785c",
    "69024b840015bdc729d8",
    "6907ab8900018027e6e0",
    "6907df0b000832908ded",
    "690908e2000b559395bb",
    "690938f100160232c270",
    "6909392b001c4f530c4a",
    "69093939003a6bb8c995",
    "690939530003f03086f2",
    "690939aa0031228ba3e2",
    "69093b05001a55bb235f",
    "69093b23001315a99b29",
    "69093b5e000863a43a2c",
    "69093b8b003b8a9295d4",
    "69093bb200383849e0ad",
    "69093bcb0003eff326d7",
    "69093be4000d2adc74c9",
    "691b83300017df2f3c8e",
    "69093bfd002faa70dae0",
    "69093c15001f6a1b1db5",
    "69093c340021e62e4273",
  ];

  Future<List<Map<String, dynamic>>> getAllCourses() async {
    List<Map<String, dynamic>> all = [];

    for (final colId in facultyCollections) {
      final docs = await db.listDocuments(
        databaseId: databaseId,
        collectionId: colId,
        queries: [
          Query.limit(5000),
        ],
      );

      for (final d in docs.documents) {
        all.add(d.data);
      }
    }

    return all;
  }
}
