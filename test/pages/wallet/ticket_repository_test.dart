import 'package:campus_app/pages/wallet/ticket/ticket_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([TicketDataSource])
void main() {
  //late TicketDataSource mockTicketDatasource;

  setUp(() {
    //mockTicketDatasource = MockTicketDatasource();
  });

  group('[getRemoteNewsfeed]', () {
    test('Should return news list on successfully web request', () async {});
  });
}
