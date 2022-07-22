import 'dart:convert';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/utils/apis/moodle_api.dart';
import 'package:http/http.dart' as http;

class MoodleDatasource {
  final http.Client client;

  MoodleDatasource({required this.client});

  /// Request user courses as json document from moodle instance.
  /// Throws a server excpetion if respond code is not 200.
  Future<List<dynamic>> getUsersCoursesAsJson(
    String token,
    int userid,
  ) async {
    final request = http.MultipartRequest(
      MoodleAPIConstants.methodPOST,
      Uri.parse(
        MoodleAPIConstants.baseUrl + MoodleAPIOperations.getUsersCoursesAsJson,
      ),
    );
    request.fields.addAll({
      MoodleAPIConstants.tokenQuery: token,
      MoodleAPIConstants.usridQuery: userid.toString()
    });

    final stream = await client.send(request);
    final response = await http.Response.fromStream(stream);

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return json.decode(response.body);
    }
  }

  /// Request site info as JSON from moodle instance.
  /// Throws a server excpetion if respond code is not 200.
  Future<Map<String, dynamic>> getSiteInfoAsJson(String token) async {
    final response = await client.post(
      Uri.parse(
        MoodleAPIConstants.baseUrl + MoodleAPIOperations.getSiteInfoAsJSON,
      ),
      body: {MoodleAPIConstants.tokenQuery: token},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return json.decode(response.body) as Map<String, dynamic>;
    }
  }
}
