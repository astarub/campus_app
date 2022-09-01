import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_app/utils/constants.dart';

class NewsEntity {
  final String title;
  final String description;
  final DateTime date;
  final CachedNetworkImage image;
  final String link;
  final String content;

  const NewsEntity({
    required this.title,
    this.description = '',
    required this.date,
    required this.image,
    this.link = '',
    this.content = '',
  });
}
