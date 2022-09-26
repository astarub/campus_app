import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import 'package:campus_app/core/failures.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/rubnews/news_entity.dart';
import 'package:campus_app/pages/rubnews/rubnews_usecases.dart';
import 'package:campus_app/pages/rubnews/widgets/filter_popup.dart';
import 'package:campus_app/utils/pages/feed_utils.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/campus_segmented_control.dart';

class RubnewsPage extends StatefulWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const RubnewsPage({
    Key? key,
    required this.mainNavigatorKey,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

  @override
  State<RubnewsPage> createState() => RubnewsPageState();
}

class RubnewsPageState extends State<RubnewsPage> {
  late final ScrollController _scrollController;
  double _scrollControllerLastOffset = 0;
  double _headerOpacity = 1;

  late List<NewsEntity> _rubnews = [];
  late List<Failure> _failures = [];

  late final SnappingSheetController _popupController;

  final RubnewsUsecases _rubnewsUsecases = sl<RubnewsUsecases>();
  final FeedUtils _feedUtils = sl<FeedUtils>();

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset > (_scrollControllerLastOffset + 80) && _scrollController.offset > 0) {
          _scrollControllerLastOffset = _scrollController.offset;
          if (_headerOpacity != 0) setState(() => _headerOpacity = 0);
        } else if (_scrollController.offset < (_scrollControllerLastOffset - 250)) {
          _scrollControllerLastOffset = _scrollController.offset;
          if (_headerOpacity != 1) setState(() => _headerOpacity = 1);
        }
      });

    _popupController = SnappingSheetController();

    // initial data request
    final initData = _rubnewsUsecases.getCachedFeedAndFailures();
    _rubnews = initData['news']! as List<NewsEntity>; // empty when no data was cached before
    _failures = initData['failures']! as List<Failure>; // CachFailure when no data was cached before

    // empty _rubnews indicate that no data was cached -> request an update
    if (_rubnews.isEmpty) {
      _rubnewsUsecases.updateFeedAndFailures().then((data) {
        setState(() {
          _rubnews = data['news']! as List<NewsEntity>;
          _failures = data['failures']! as List<Failure>;
        });
      });
    }
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
                  child: RefreshIndicator(
                    displacement: 55,
                    backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.dialogBackgroundColor,
                    color: Provider.of<ThemesNotifier>(context).currentThemeData.focusColor,
                    strokeWidth: 3,
                    onRefresh: () {
                      return _rubnewsUsecases.updateFeedAndFailures().then((data) {
                        setState(() {
                          _rubnews = data['news']! as List<NewsEntity>;
                          _failures = data['failures']! as List<Failure>;
                        });
                      });
                    },
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      children: _feedUtils.fromNewsEntityListToWidgetList(entities: _rubnews),
                    ),
                  ),
                ),
                // Header
                Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 20, left: 0, right: 0),
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
                          children: [
                            // Search button
                            CampusIconButton(
                              iconPath: 'assets/img/icons/search.svg',
                              onTap: () {},
                            ),
                            // FeedPicker
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child:
                                  CampusSegmentedControl(leftTitle: 'Feed', rightTitle: 'Explore', onChanged: (_) {}),
                            ),
                            // Filter button
                            CampusIconButton(
                              iconPath: 'assets/img/icons/filter.svg',
                              onTap: () {
                                widget.mainNavigatorKey.currentState?.push(PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (context, _, __) => const FeedFilterPopup(),
                                ));
                              },
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
