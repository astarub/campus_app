import 'dart:io';

import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/mensa/mensa_datasource.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import '../rubnews/rubnews_datasource_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MensaDataSource mensaDataSource;
  late Dio client;

  setUp(() async {
    client = Dio();

    (client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    mensaDataSource = MensaDataSource(client: client);
  });

  bool isUppercase(String str) {
    return str == str.toUpperCase();
  }

  group("[getMensaData]", () {
    test("testing data", () async {
      //print(await mensaDataSource.getMensaData(1));

      final sample = {
        "title": 'Hähnchenschnitzel "Hawaii" mit Pommes und Salat',
        "price": '4,90 €  / 5,90 €',
        "allergies": '(G,a,a1,g,1)'
      };

      final varr = DishEntity.fromJSON(DateTime(0), "Aktion", sample);

      print(
          "${varr.price}, ${varr.title}, ${varr.category}, ${varr.allergenes}, ${varr.infos}, ${varr.date}, ${varr.additives}");
    });
  });
}
