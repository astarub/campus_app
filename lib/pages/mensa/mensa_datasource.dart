





import 'package:dio/dio.dart';

class MensaDataSource{



  final Dio client;

  MensaDataSource({required this.client});


  Future<Map<String,dynamic>> getMensaData(int angebot) async {

    final headers = {
      'Authorization': 'Bearer mensa_secret_api_key_1337'
    };

    final response = await client.get("https://80.240.25.142/get_meal/$angebot",  options: Options(headers: headers));


    return response.data;
  }

}