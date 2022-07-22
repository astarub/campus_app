import 'package:campus_app/pages/rubnews/rubnews_news_entity.dart';
import 'package:flutter/material.dart';

class RubnewsNews extends StatelessWidget {
  final RubnewsNewsEntity news;

  const RubnewsNews({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 350,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: 300,
              width: 350,
              child: news.image,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    child: Text(news.title),
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    child: Text(news.description),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
