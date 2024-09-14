import 'package:hive/hive.dart';

part 'organizer_entity.g.dart';

@HiveType(typeId: 3)
class Organizer {
  /// The unique id of the event
  @HiveField(0)
  final int id;

  /// The url to REST API of specific news
  @HiveField(1)
  final String url;

  /// The organizers name
  @HiveField(2)
  final String name;

  /// The url identifier after base url:
  /// https://asta-bochum.de/veranstalter/${slug}
  @HiveField(3)
  final String slug;

  /// The organizers website phone number
  @HiveField(4)
  final String? phone;

  /// The organizers website
  @HiveField(5)
  final String? website;

  /// The organizers email
  @HiveField(6)
  final String? email;

  const Organizer({
    required this.id,
    required this.url,
    required this.name,
    required this.slug,
    this.phone,
    this.website,
    this.email,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) {
    final phone = json.containsKey('phone') ? json['phone'] : null;
    final website = json.containsKey('website') ? json['website'] : null;
    final email = json.containsKey('email') ? json['email'] : null;

    return Organizer(
      id: json['id'],
      name: json['organizer'],
      url: json['url'],
      slug: json['slug'],
      phone: phone,
      website: website,
      email: email,
    );
  }

  factory Organizer.fromInternalJson({required Map<String, dynamic> json}) {
    return Organizer(
      id: json['id'],
      url: json['url'],
      name: json['name'],
      slug: json['slug'],
      phone: json['phone'],
      website: json['website'],
      email: json['email'],
    );
  }

  @override
  String toString() => name;
}
