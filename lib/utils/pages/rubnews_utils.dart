import 'package:campus_app/pages/rubnews/rubnews_news_entity.dart';
import 'package:campus_app/pages/rubnews/widgets/news_widget.dart';
import 'package:campus_app/utils/pages/presentation_functions.dart';
import 'package:flutter/widgets.dart';

class RubnewsUtils extends Utils {
  /// parse news entities to widget list
  List<Widget> getNewsWidgetList(List<RubnewsNewsEntity> news) {
    final List<Widget> widgets = [];

    for (final RubnewsNewsEntity e in news) {
      widgets.add(RubnewsNews(news: e));
      widgets.add(const SizedBox(height: 20));
    }

    return widgets;
  }
}
