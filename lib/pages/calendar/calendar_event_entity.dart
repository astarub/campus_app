import 'package:campus_app/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CalendarEventEntity {
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final CachedNetworkImage? image;
  final String url;
  final double costs;
  final String venue;
  final List<String> organizers;

  const CalendarEventEntity({
    required this.id,
    required this.title,
    this.description = '',
    required this.startDate,
    this.endDate = null,
    this.image = null,
    this.url = '',
    required this.costs,
    this.venue = '',
    this.organizers = const [],
  });
}
