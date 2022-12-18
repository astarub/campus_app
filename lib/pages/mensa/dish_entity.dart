import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:xml/xml.dart';

part 'dish_entity.g.dart';

@immutable
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

  /// Return a NewsEntity based on a single Json element given by the web server
  factory DishEntity.fromJSON({
    required int date,
    required String category,
    required Map<String, dynamic> json,
  }) {
    late final List<String> uppercase = [];
    late final List<String> lowercase = [];
    late final List<String> numbers = [];

    final title = json['title'];
    final price = json['price'] ?? 'pauschal';

    final allInfo = (json['allergies']! as String).replaceAll('(', '').replaceAll(')', '').split(',');

    uppercase.addAll(allInfo.where((element) => _isUppercase(element) && !_isNumeric(element)));
    lowercase.addAll(allInfo.where((element) => !_isUppercase(element)));
    numbers.addAll(allInfo.where(_isNumeric));

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

  /// Return a NewsEntity based on a single XML element given by the web server
  factory DishEntity.fromXML({
    required int date,
    required String category,
    required XmlElement xml,
  }) {
    final List<String> adds = [];
    final List<String> infos = [];
    final List<String> allergenes = [];

    final title = xml.getAttribute('Name')!;

    final price = xml
        .getElement('ComponentDetails')!
        .getElement('ProductInfo')!
        .getElement('Product')!
        .getAttribute('ProductPrice')!;

    // Foodlabels
    final foodLabelGroups =
        xml.getElement('ComponentDetails')!.getElement('FoodLabelInfo')!.findAllElements('FoodLabelGroup');
    Future.forEach(foodLabelGroups.map((_) => _), (XmlElement group) {
      // Additives
      if (group.getAttribute('name')! == 'Zusatzstoff') {
        final labels = group.getElement('Additives')!.findAllElements('FoodLabel');
        adds.addAll(_parseLabelsToList(labels));
      }
      // Allergenes
      else if (group.getAttribute('name')! == 'Allergene') {
        final labels = group.getElement('Allergens')!.findAllElements('FoodLabel');
        allergenes.addAll(_parseLabelsToList(labels));
      }
      // Infos
      else if (group.getAttribute('name')! == 'Information') {
        final labels = group.getElement('Information')!.findAllElements('FoodLabel');
        infos.addAll(_parseLabelsToList(labels));
      }
    });

    return DishEntity(
      date: date,
      category: category,
      title: title,
      price: price,
      infos: infos,
      allergenes: allergenes,
      additives: adds,
    );
  }

  @override
  String toString() => '$date: $title ($category), $price, $infos, $allergenes, $additives';

  @override
  bool operator ==(Object other) {
    if (other is! DishEntity || hashCode != other.hashCode) return false;
    return true;
  }

  @override
  int get hashCode => Object.hash(date, category, title, price, infos, allergenes, additives);

  /// Test if a given String is uppercase
  static bool _isUppercase(String str) => str == str.toUpperCase();

  /// Test if a given string represents a number
  static bool _isNumeric(String s) => double.tryParse(s) != null;

  /// Resolve given names from XML
  static List<String> _parseLabelsToList(Iterable<XmlElement> xml) {
    final list = <String>[];

    for (final label in xml) {
      final n = label.getAttribute('name');

      // Infos
      if (n == 'mit Alkohol') {
        list.add('A');
      } else if (n == 'mit Fisch') {
        list.add('F');
      } else if (n == 'mit Geflügel') {
        list.add('G');
      } else if (n == 'Halal') {
        list.add('H');
      } else if (n == 'mit Lamm') {
        list.add('L');
      } else if (n == 'mit Rind') {
        list.add('R');
      } else if (n == 'mit Schwein') {
        list.add('S');
      } else if (n == 'vegetarisch') {
        list.add('V');
      } else if (n == 'vegan') {
        list.add('VG');
      } else if (n == 'mit Wild') {
        list.add('W');
      }

      // Allergenes
      else if (n == 'Gluten') {
        list.add('a');
      } else if (n == 'Weizen') {
        list.add('a1');
      } else if (n == 'Roggen') {
        list.add('a2');
      } else if (n == 'Gerste') {
        list.add('a3');
      } else if (n == 'Hafer') {
        list.add('a4');
      } else if (n == 'Dinkel') {
        list.add('a5');
      } else if (n == 'Kamut') {
        list.add('a6');
      } else if (n == 'Krebstiere') {
        list.add('b');
      } else if (n == 'Eier') {
        list.add('c');
      } else if (n == 'Fisch') {
        list.add('d');
      } else if (n == 'Erdnüsse') {
        list.add('e');
      } else if (n == 'Sojabohnen') {
        list.add('f');
      } else if (n == 'Milch') {
        list.add('g');
      } else if (n == 'Schalenfrüchte') {
        list.add('h');
      } else if (n == 'Mandel') {
        list.add('h1');
      } else if (n == 'Haselnuss') {
        list.add('h2');
      } else if (n == 'Walnuss') {
        list.add('h3');
      } else if (n == 'Cashewnuss') {
        list.add('h4');
      } else if (n == 'Pecanuss') {
        list.add('h5');
      } else if (n == 'Paranuss') {
        list.add('h6');
      } else if (n == 'Pistazie') {
        list.add('h7');
      } else if (n == 'Macadamia/Quennslandnuss') {
        list.add('h8');
      } else if (n == 'Sellerie') {
        list.add('i');
      } else if (n == 'Senf') {
        list.add('j');
      } else if (n == 'Sesamsamen') {
        list.add('k');
      } else if (n == 'Schwefeldioxid') {
        list.add('l');
      } else if (n == 'Lupinen') {
        list.add('m');
      } else if (n == 'Weichtiere') {
        list.add('n');
      }

      // Additives
      else if (n == 'mit Farbstoff') {
        list.add('1');
      } else if (n == 'mit Konservierungsstoff') {
        list.add('2');
      } else if (n == 'mit Antioxidationsmittel') {
        list.add('3');
      } else if (n == 'mit Geschmacksverstärker') {
        list.add('4');
      } else if (n == 'geschwefelt') {
        list.add('5');
      } else if (n == 'geschwärzt') {
        list.add('6');
      } else if (n == 'gewachst') {
        list.add('7');
      } else if (n == 'mit Phosphat') {
        list.add('8');
      } else if (n == 'mit Süßungsmittel(n)') {
        list.add('9');
      } else if (n == 'enthält eine Phenylalaninquelle') {
        list.add('10');
      } else if (n == 'kann bei übermäßigem Verzehr abführend wirken') {
        list.add('11');
      } else if (n == 'koffeinhaltig') {
        list.add('12');
      } else if (n == 'chininhaltig') {
        list.add('13');
      }
    }

    return list;
  }
}
