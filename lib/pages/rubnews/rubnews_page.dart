import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/utils/pages/rubnews_utils.dart';
import 'package:campus_app/pages/rubnews/widgets/feed_item.dart';
import 'package:campus_app/pages/rubnews/widgets/feed_picker.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
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
  late ScrollController _scrollController;
  double _scrollControllerLastOffset = 0;
  double _headerOpacity = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset > (_scrollControllerLastOffset + 100) && _scrollController.offset > 0) {
          if (_headerOpacity != 0) setState(() => _headerOpacity = 0);
          _scrollControllerLastOffset = _scrollController.offset;
        } else if (_scrollController.offset < _scrollControllerLastOffset) {
          if (_headerOpacity != 1) setState(() => _headerOpacity = 1);
          _scrollControllerLastOffset = _scrollController.offset;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: Center(
        child: AnimatedExit(
          key: widget.pageExitAnimationKey,
          child: AnimatedEntry(
            key: widget.pageEntryAnimationKey,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // News feed
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // Spacing
                      const SizedBox(height: 80),
                      // Actual feed items
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
                // Header
                Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  color: _headerOpacity == 1 ? Colors.white : Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Headline
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          'Feed',
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                        ),
                      ),
                      // FeedPicker & filter
                      AnimatedOpacity(
                        opacity: _headerOpacity,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CampusIconButton(
                              iconPath: 'assets/img/icons/search.svg',
                              onTap: () {},
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: FeedPicker(),
                            ),
                            CampusIconButton(
                              iconPath: 'assets/img/icons/filter.svg',
                              onTap: () {},
                            ),
                          ],
                        ),
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
