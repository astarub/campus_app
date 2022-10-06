import 'package:campus_app/utils/pages/mensa_utils.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

import '../../core/injection.dart';


@HiveType(typeId: 5)
class Dish {

  /// date
  @HiveField(0)
  final DateTime date;

  /// date
  @HiveField(1)
  final String category;

  /// Dish title
  @HiveField(2)
  final String title;

  /// price
  @HiveField(3)
  final String price;

  /// info
  @HiveField(4)
  final List<String> infos;

  @HiveField(5)
  final List<String> allergenes;

  @HiveField(6)
  final List<String> additives; //zusatzstoffe



  const Dish({
    required this.date,
    required this.category,
    required this.title,
    required this.price,
    this.infos = const[],
    this.allergenes = const[],
    this.additives = const[],
  });


  /// Return a NewsEntity based on a single XML element given by the web server
  factory Dish.fromJSON(DateTime date, String category, Map<String, String> json) 
  {
    //final utils = sl<MensaUtils>();
    final utils = MensaUtils();

    final title = json["title"]!;
    final price = json["price"]!;
    
    dynamic all_info = json["allergies"]! as String;


    List<String> uppercase = [];
    List<String> lowercase = [];
    List<String> numbers = [];

    all_info = all_info.replaceAll("(", "").replaceAll(")", "").split(",") as List;


    uppercase.addAll(all_info.where((element) => utils.isUppercase(element) && !utils.isNumeric(element)));
    lowercase.addAll(all_info.where((element) => !utils.isUppercase(element)));
    numbers.addAll(all_info.where((element) => utils.isNumeric(element)));
    
    
    return Dish(date: date, category: category, title: title, price: price, infos: uppercase, allergenes: lowercase, additives: numbers);
  }
}
