import 'package:campus_app/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CalendarEventEntity {
  final int id;
  final String title;
  //final DateTime startDate;
  //final DateTime endDate;
  final String url;
  final String description;
  final CachedNetworkImage image;
  final String costs;
  final String venue;
  final List<String> organizers;

  CalendarEventEntity({
    required this.id,
    required this.title,
    required this.costs,
    required this.description,
    //required this.endDate,
    required this.image,
    required this.organizers,
    //required this.startDate,
    required this.url,
    required this.venue,
  });

  factory CalendarEventEntity.empty() {
    return CalendarEventEntity(
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
}
