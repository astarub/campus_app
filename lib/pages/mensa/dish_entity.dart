import 'package:hive/hive.dart';

import 'package:campus_app/utils/pages/mensa_utils.dart';

part 'dish_entity.g.dart';

@HiveType(typeId: 5)
class DishEntity {
  /// Date: from 0 to 4 (Monday to Friday)
  @HiveField(0)
  final int date;

  /// Category
  @HiveField(1)
  final String category;

  /// Dish title
  @HiveField(2)
  final String title;

  /// Price
  @HiveField(3)
  final String price;

  /// Info
  @HiveField(4)
  final List<String> infos;

  /// Allergenes
  @HiveField(5)
  final List<String> allergenes;

  /// Additives
  @HiveField(6)
  final List<String> additives; //zusatzstoffe

  const DishEntity({
    required this.date,
    required this.category,
    required this.title,
    required this.price,
    this.infos = const [],
    this.allergenes = const [],
    this.additives = const [],
  });

  /// Return a NewsEntity based on a single XML element given by the web server
  factory DishEntity.fromJSON({
    required int date,
    required String category,
    required Map<String, dynamic> json,
    required MensaUtils utils,
  }) {
    late final List<String> uppercase = [];
    late final List<String> lowercase = [];
    late final List<String> numbers = [];

    final title = json['title'];
    final price = json['price'] ?? 'pauschal';

    final allInfo = (json['allergies']! as String).replaceAll('(', '').replaceAll(')', '').split(',');

    uppercase.addAll(allInfo.where((element) => utils.isUppercase(element) && !utils.isNumeric(element)));
    lowercase.addAll(allInfo.where((element) => !utils.isUppercase(element)));
    numbers.addAll(allInfo.where(utils.isNumeric));

    return DishEntity(
      date: date,
      category: category,
      title: title,
      price: price,
      infos: uppercase,
      allergenes: lowercase,
      additives: numbers,
    );
  }

  @override
  String toString() {
    return '$date: $title ($category), $price, $infos, $allergenes, $additives';
  }
}
