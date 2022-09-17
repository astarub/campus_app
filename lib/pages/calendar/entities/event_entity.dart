import 'package:campus_app/pages/calendar/entities/category_entity.dart';
import 'package:campus_app/pages/calendar/entities/organizer_entity.dart';
import 'package:campus_app/pages/calendar/entities/venue_entity.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'event_entity.g.dart';

@HiveType(typeId: 1)
class Event {
  /// The unique id of the event
  @HiveField(0)
  final int id;

  /// The url to REST API of specific event
  @HiveField(1)
  final String url;

  /// The event title
  @HiveField(2)
  final String title;

  /// The event description / content of event
  @HiveField(3)
  final String description;

  /// The url identifier after base url:
  /// https://asta-bochum.de/termin/${slug}
  @HiveField(4)
  final String slug;

  /// Indicates that the event has an image or not
  @HiveField(5)
  final bool hasImage;

  /// Url that points to the image of the event
  @HiveField(6)
  final String? imageUrl;

  /// The date and time when the event starts
  @HiveField(7)
  final DateTime startDate;

  /// The date and time when the event ends
  @HiveField(8)
  final DateTime endDate;

  /// Indicate that the event goes the full day
  @HiveField(9)
  final bool allDay;

  /// The costs of the event as JSON.
  /// e.g. cost = { 'currency': '€', 'value': '20.5' }
  @HiveField(10)
  final Map<String, String>? cost;

  /// An external website if the event has one.
  /// Otherwise it is an empty string.
  @HiveField(11)
  final String? website;

  /// List of categories and tag of the event.
  @HiveField(12)
  final List<Category> categories;

  /// The location of the event.
  @HiveField(13)
  final Venue venue;

  /// List of organiziers of the event.
  @HiveField(14)
  final List<Organizer> organizers;

  const Event({
    required this.id,
    required this.url,
    required this.title,
    required this.description,
    required this.slug,
    required this.hasImage,
    this.imageUrl,
    required this.startDate,
    required this.endDate,
    this.allDay = false,
    this.cost,
    this.website,
    this.categories = const <Category>[],
    required this.venue,
    this.organizers = const <Organizer>[],
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    final List<Category> categories = [];
    final List<Organizer> organizers = [];

    // cost := null if no costs specified for event
    final Map<String, String>? cost = json['cost'] == ''
        ? null
        : {
            'currency': (json['cost_details'] as Map<String, dynamic>)['currency_symbol'] as String,
            'value': ((json['cost_details'] as Map<String, dynamic>)['values'] as List<String>)[0],
          };

    // if json['image'] of type bool then has the event no image
    final bool hasImage = json['image'] is! bool;

    // read categories from JSON
    for (final category in json['categories'] as List<dynamic>) {
      categories.add(Category.fromJson(json: category));
    }

    // read tags from JSON
    for (final tag in json['tags'] as List<dynamic>) {
      categories.add(Category.fromJson(json: tag, isCategory: false));
    }

    // read organizers from JSON
    for (final organizer in json['organizer'] as List<dynamic>) {
      organizers.add(Organizer.fromJson(organizer));
    }

    return Event(
      id: json['id'],
      url: json['rest_url'],
      title: json['title'],
      description: json['description'],
      slug: json['slug'],
      hasImage: hasImage,
      imageUrl: hasImage ? (json['image'] as Map<String, dynamic>)['url'] : null,
      startDate: DateFormat('yyyy-MM-dd hh:mm:ss Z', 'en_US').parse(
        "${json['start_date']} ${json['timezone']}",
      ),
      endDate: DateFormat('yyyy-MM-dd hh:mm:ss Z', 'en_US').parse(
        "${json['end_date']} ${json['timezone']}",
      ),
      allDay: json['all_day'],
      cost: cost,
      website: json['website'],
      categories: categories,
      venue: Venue.fromJson(json['venue'] as Map<String, dynamic>),
      organizers: organizers,
    );
  }
}
