import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/pages/.widgets/error_message.dart';
import 'package:campus_app/utils/pages/rubnews_utils.dart';
import 'package:campus_app/pages/rubnews/widgets/feed_item.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/utils/widgets/campus_textfield.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';

class RubnewsPage extends StatefulWidget {
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const RubnewsPage({
    Key? key,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

  @override
  State<RubnewsPage> createState() => RubnewsPageState();
}

class RubnewsPageState extends State<RubnewsPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController textFieldController = TextEditingController();

    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: Center(
        child: AnimatedExit(
          key: widget.pageExitAnimationKey,
          child: AnimatedEntry(
            key: widget.pageEntryAnimationKey,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  child: Text(
                    'Feed',
                    style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      FeedItem(
                        title: 'E-Sports Meet & Greet',
                        description:
                            'Wir freuen uns auf euch und wollen euch bei ein paar Partien Mario Kart, Tekken, Street fighter etc. kennenlernen.',
                        date: DateTime(2022, 6, 20, 17), // 20.06.2022, 17 Uhr
                        image: Image.asset('assets/img/AStA-Retro-Gaming.jpg'),
                        content: 'Test Content',
                      ),
                      FeedItem(
                        title: 'E-Sports Meet & Greet',
                        description:
                            'Wir freuen uns auf euch und wollen euch bei ein paar Partien Mario Kart, Tekken, Street fighter etc. kennenlernen.',
                        date: DateTime(2022, 6, 20, 17), // 20.06.2022, 17 Uhr
                        image: Image.asset('assets/img/AStA-Retro-Gaming.jpg'),
                        content: 'Test Content',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
