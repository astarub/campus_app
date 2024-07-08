import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> translateText(String text, String sourceLang, String targetLang) async {
  final response = await http.post(
    Uri.parse('https://translate.app.asta-bochum.de/translate'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'q': text,
      'source': sourceLang,
      'target': targetLang,
      'format': 'text',
    }),
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse['translatedText'];
  } else {
    throw Exception('Failed to translate text');
  }
}
