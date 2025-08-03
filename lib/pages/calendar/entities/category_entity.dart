import 'package:hive/hive.dart';

part 'category_entity.g.dart';

@HiveType(typeId: 57)
class Category {
  /// The unique id of the category or tag
  @HiveField(0)
  final int id;

  /// The url to REST API of specific category or tag
  @HiveField(1)
  final String url;

  /// The category or tag name
  @HiveField(2)
  final String name;

  /// The category or tag description
  @HiveField(3)
  final String description;

  /// Is the given Entity a API category or a API tag, because
  /// there are different REST API paths for category and tags.
  @HiveField(4)
  final bool isCategory;

  const Category({
    required this.id,
    required this.url,
    required this.name,
    required this.description,
    required this.isCategory,
  });

  factory Category.fromJson({
    required Map<String, dynamic> json,
    bool isCategory = true,
  }) {
    return Category(
      id: json['id'],
      url: (json['urls'] as Map<String, dynamic>)['self']! as String,
      name: json['name'],
      description: json['description'],
      isCategory: isCategory,
    );
  }

  @override
  String toString() => name;
}
