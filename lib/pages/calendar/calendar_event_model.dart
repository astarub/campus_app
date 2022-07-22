import 'package:campus_app/pages/calendar/calendar_event_entity.dart';
import 'package:campus_app/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CalendarEventModel extends CalendarEventEntity {
  CalendarEventModel({
    required int id,
    required String title,
    required String costs,
    required String description,
    //required DateTime endDate,
    required CachedNetworkImage image,
    required List<String> organizers,
    //required DateTime startDate,
    required String url,
    required String venue,
  }) : super(
          id: id,
          title: title,
          costs: costs,
          description: description,
          //endDate: endDate,
          image: image,
          organizers: organizers,
          //startDate: startDate,
          url: url,
          venue: venue,
        );

  factory CalendarEventModel.empty() {
    return CalendarEventModel(
      id: -1,
      title: '',
      url: '',
      organizers: [''],
      venue: '',
      costs: '',
      description: '',
      //startDate: DateTime(0),
      //endDate: DateTime(0),
      image: CachedNetworkImage(
        placeholder: (context, url) => const CircularProgressIndicator(),
        imageUrl: astaFavicon,
      ),
    );
  }

  // TODO: Handle empty json objects -> not all events have a image, venue etc.
  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    final List<String> organizers = [];
    CachedNetworkImage image = CachedNetworkImage(
      placeholder: (context, url) => const CircularProgressIndicator(),
      imageUrl: astaFavicon,
    );

    try {
      final imageUrl = (((json['image'] as Map<String, dynamic>)['sizes']
              as Map<String, dynamic>)['large'] as Map<String, dynamic>)['url']
          as String;

      image = CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => const CircularProgressIndicator(),
        fit: BoxFit.cover,
      );
    } catch (e) {
      // TODO: handle exception - 'No image specified'
    }

    try {
      final jsonOrganizers = json['organizer'] as List<dynamic>;

      for (final organizer in jsonOrganizers) {
        organizers
            .add((organizer as Map<String, dynamic>)['organizer'] as String);
      }
    } catch (e) {
      // TODO: handle exception - 'No organizer specified'
    }

    return CalendarEventModel(
      id: json['id'] as int,
      title: json['title'] as String,
      costs: json['cost'] as String,
      description: json['description'] as String,
      //endDate: json['id'],
      image: image,
      organizers: organizers,
      //startDate: json['id'],
      url: json['url'] as String,
      venue: (json['venue'] as Map<String, dynamic>)['venue'] as String,
    );
  }
}
