import 'package:flutter/widgets.dart';

import 'package:hive/hive.dart';

import 'package:campus_app/pages/calendar/entities/category_entity.dart';
import 'package:campus_app/pages/calendar/entities/organizer_entity.dart';
import 'package:campus_app/pages/calendar/entities/venue_entity.dart';

part 'event_entity.g.dart';

@immutable
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

  /// Id of the author of the event
  @HiveField(15)
  final String author;

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
    this.author = '',
  });

  factory Event.fromInternalJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      description: json['description'],
      slug: json['slug'],
      hasImage: json['hasImage'],
      imageUrl: json['imageUrl'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      allDay: json['allDay'],
      cost: json['costs'],
      website: json['website'],
      categories: json['categories'],
      venue: json['venue'],
      organizers: json['organizers'],
      author: json['author'],
    );
  }

  Map<String, dynamic> toInternalJson() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'description': description,
      'slug': slug,
      'hasImage': hasImage,
      'imageUrl': imageUrl,
      'startDate': startDate,
      'endDate': endDate,
      'allDay': allDay,
      'cost': cost,
      'website': website,
      'categories': categories,
      'venue': venue,
      'organizers': organizers,
      'author': author,
    };
  }

  factory Event.fromAppwriteJson({required Map<String, dynamic> json}) {
    return Event(
      id: json['id'],
      url: json['url'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      slug: json['slug'] ?? '',
      hasImage: json['hasImage'] ?? false,
      imageUrl: json['imageUrl'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      allDay: json['allDay'] ?? false,
      cost: json['cost'],
      website: json['website'],
      categories: List<Map<String, dynamic>>.from(
        json['categories'],
      ).map((e) => Category.fromInternalJson(json: e)).toList(),
      venue: Venue.fromInternalJson(json: json['venue']),
      organizers: List<Map<String, dynamic>>.from(
        json['organizers'],
      ).map((e) => Organizer.fromInternalJson(json: e)).toList(),
      author: json['author'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Event && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
