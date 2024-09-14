import 'package:hive/hive.dart';

part 'venue_entity.g.dart';

@HiveType(typeId: 2)
class Venue {
  /// The unique id of the venue
  @HiveField(0)
  final int id;

  /// The url to REST API of specific venue
  @HiveField(1)
  final String url;

  /// The location name
  @HiveField(2)
  final String name;

  /// The url identifier after base url:
  /// https://asta-bochum.de/veranstaltungsort/${slug}
  @HiveField(3)
  final String slug;

  /// The locations street name and number
  @HiveField(4)
  final String? address;

  /// The locations city
  @HiveField(5)
  final String? city;

  /// The locations country
  @HiveField(6)
  final String? country;

  /// The locations province
  @HiveField(7)
  final String? province;

  /// The locations zip code
  @HiveField(8)
  final String? zip;

  /// The locations phone number
  @HiveField(9)
  final String? phone;

  const Venue({
    required this.id,
    required this.url,
    required this.name,
    required this.slug,
    this.address,
    this.city,
    this.country,
    this.province,
    this.zip,
    this.phone,
  });

  /// Return a Venue object based on given JSON
  factory Venue.fromJson(Map<String, dynamic> json) {
    final address = json.containsKey('address') ? json['address'] : null;
    final city = json.containsKey('city') ? json['city'] : null;
    final country = json.containsKey('country') ? json['country'] : null;
    final province = json.containsKey('province') ? json['province'] : null;
    final zip = json.containsKey('zip') ? json['zip'] : null;
    final phone = json.containsKey('phone') ? json['phone'] : null;

    return Venue(
      id: json['id'],
      name: json['venue'],
      url: json['url'],
      slug: json['slug'],
      address: address,
      city: city,
      country: country,
      province: province,
      zip: zip,
      phone: phone,
    );
  }

  factory Venue.fromInternalJson({required Map<String, dynamic> json}) {
    if (json['id'] == -1) {
      return Venue.emptyPlaceholder();
    }

    return Venue(
      id: json['id'],
      url: json['url'],
      name: json['name'],
      slug: json['slug'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      province: json['province'],
      zip: json['zip'],
      phone: json['phone'],
    );
  }

  /// Return an empty Venue object
  factory Venue.emptyPlaceholder() {
    return const Venue(
      id: -1,
      name: '',
      url: '',
      slug: '',
    );
  }

  @override
  String toString() {
    String venueString = name;

    venueString = address == null ? venueString : '$venueString: $address';
    venueString = zip == null ? venueString : '$venueString, $zip';
    venueString = city == null ? venueString : '$venueString, $city';

    return venueString;
  }
}
