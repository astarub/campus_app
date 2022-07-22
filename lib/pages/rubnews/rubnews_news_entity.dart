import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_app/utils/constants.dart';
import 'package:flutter/material.dart';

class RubnewsNewsEntity {
  final String content;
  final String title;
  final String link;
  final String description;
  //final DateTime pubDate;
  final CachedNetworkImage image;

  RubnewsNewsEntity({
    required this.content,
    required this.title,
    required this.link,
    required this.description,
    //required this.pubDate,
    required this.image,
  });

  factory RubnewsNewsEntity.empty() {
    return RubnewsNewsEntity(
      content: '',
      title: '',
      link: '',
      description: '',
      //pubDate: DateTime(0),
      image: CachedNetworkImage(
        placeholder: (context, url) => const CircularProgressIndicator(),
        imageUrl: astaFavicon,
      ),
    );
  }
}
