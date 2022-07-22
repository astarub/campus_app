import 'dart:convert';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

abstract class CalendarRemoteDatasource {
  /// Request event feed from asta-bochum.de/termine/feed.
  /// Throws a server excpetion if respond code is not 200.
  Future<XmlDocument> getAStAEventfeedAsXML();

  /// Request events from tribe api.
  /// Throws a server excpetion if respond code is not 200.
  Future<List<dynamic>> getAStAEventsAsJsonArray();
}

class CalendarRemoteDatasourceImpl implements CalendarRemoteDatasource {
  final http.Client client;

  CalendarRemoteDatasourceImpl({required this.client});

  @override
  Future<XmlDocument> getAStAEventfeedAsXML() {
    // TODO: implement getAStAEventfeedAsXML
    throw UnimplementedError();
  }

  @override
  Future<List<dynamic>> getAStAEventsAsJsonArray() async {
    final response = await client.get(
      Uri.parse(astaEvents),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      final responseBody = json.decode(response.body) as Map<String, dynamic>;

      if (responseBody['events'] == null) {
        throw EmptyResponseException();
      }

      return responseBody['events'] as List<dynamic>;
    }
  }
}
