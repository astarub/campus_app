import 'package:campus_app/pages/rubnews/news_entity.dart';
import 'package:campus_app/pages/rubnews/widgets/feed_item.dart';
import 'package:campus_app/utils/pages/presentation_functions.dart';
import 'package:flutter/widgets.dart';

class RubnewsUtils extends Utils {
  /// parse news entities to widget list
  List<Widget> getNewsWidgetList(List<NewsEntity> news) {
    final List<Widget> widgets = [];

    for (final NewsEntity e in news) {
      //widgets.add(RubnewsNews(news: e));
      widgets.add(const SizedBox(height: 20));
    }

    return widgets;
  }
}
