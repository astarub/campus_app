import 'package:appwrite/appwrite.dart';

class AppwriteClient {
  static Client getClient() {
    return Client()
      ..setEndpoint('https://api-dev-app.asta-bochum.de/v1')
      ..setProject('campus_app');
  }
}
