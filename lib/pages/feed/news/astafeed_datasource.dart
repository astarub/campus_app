import 'package:dio/dio.dart';

import 'package:campus_app/core/exceptions.dart';

import 'package:campus_app/utils/constants.dart';

class AstaFeedDatasource {
  /// Dio client to perform network operations
  final Dio client;

  AstaFeedDatasource({
    required this.client,
  });

  /// Request posts from asta-bochum.de
  /// Throws a server exception if respond code is not 200.
  Future<List<dynamic>> getAStAFeedAsJson() async {
    final response = await client.get(astaFeed);

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return response.data;
    }
  }

  /// Request posts from asta-bochum.de
  /// Throws a server exception if respond code is not 200.
  Future<List<dynamic>> getAppFeedAsJson() async {
    final response = await client.get(appFeed);

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return response.data;
    }
  }
}
