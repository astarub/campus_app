import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_app/pages/rubnews/news_entity.dart';
import 'package:campus_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class RubnewsNewsModel extends NewsEntity {
  RubnewsNewsModel({
    required String content,
    required String title,
    required String link,
    required String description,
    required DateTime date,
    required CachedNetworkImage image,
  }) : super(
          title: title,
          link: link,
          description: description,
          date: date,
          image: image,
        );

  factory RubnewsNewsModel.empty() {
    return RubnewsNewsModel(
      content: 'content',
      title: 'title',
      link: 'link',
      description: 'description',
      date: DateTime(0),
      image: CachedNetworkImage(
        placeholder: (context, url) => const CircularProgressIndicator(),
        imageUrl: astaFavicon,
      ),
    );
  }

  factory RubnewsNewsModel.fromXML(XmlElement xml, CachedNetworkImage image) {
    final content = xml.getElement('content')!.text;
    final title = xml.getElement('title')!.text;
    final link = xml.getElement('link')!.text;
    final description = xml.getElement('description')!.text;

    return RubnewsNewsModel(
      content: content,
      title: title,
      link: link,
      description: description,
      date: DateTime(0),
      image: image,
    );
  }
}
