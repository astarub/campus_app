import 'dart:io' show Platform;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import 'package:campus_app/core/failures.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/pages/calendar/calendar_usecases.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/feed/rubnews/news_entity.dart';
import 'package:campus_app/pages/feed/rubnews/rubnews_usecases.dart';
import 'package:campus_app/pages/feed/widgets/filter_popup.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/utils/pages/feed_utils.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/campus_segmented_control.dart';

class FeedPage extends StatefulWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const FeedPage({
    Key? key,
    required this.mainNavigatorKey,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

  @override
  State<FeedPage> createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  late final ScrollController _scrollController;
  double _scrollControllerLastOffset = 0;
  double _headerOpacity = 1;

  late List<NewsEntity> _rubnews = [];
  late List<Event> _events = [];
  late List<Failure> _failures = [];

  late final SnappingSheetController _popupController;

  final RubnewsUsecases _rubnewsUsecases = sl<RubnewsUsecases>();
  final CalendarUsecases _calendarUsecase = sl<CalendarUsecases>();
  final FeedUtils _feedUtils = sl<FeedUtils>();

  void saveChangedFilters(List<String> newFilters) {
    final Settings newSettings =
        Provider.of<SettingsHandler>(context, listen: false).currentSettings.copyWith(feedFilter: newFilters);

    debugPrint('Saving new feed filter: ${newSettings.feedFilter}');
    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;
  }

  void saveFeedExplore(int selected) {
    bool explore = false;
    if (selected == 1) explore = true;

    final Settings newSettings =
        Provider.of<SettingsHandler>(context, listen: false).currentSettings.copyWith(newsExplore: explore);

    debugPrint('Saving newsExplore: ${newSettings.newsExplore}');
    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;
  }

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
    final newsData = _rubnewsUsecases.getCachedFeedAndFailures();
    _rubnews = newsData['news']! as List<NewsEntity>; // empty when no data was cached before
    _failures = newsData['failures']! as List<Failure>; // CachFailure when no data was cached before

    final eventData = _calendarUsecase.getCachedEventsAndFailures();
    _events = eventData['events']! as List<Event>; // empty when no data was cached before
    _failures.addAll(eventData['failures']! as List<Failure>); // CachFailure when no data was cached before

    // Rrequest an update for the feed
    updateStateWithFeed();
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
                  margin: EdgeInsets.only(top: Platform.isAndroid ? 70 : 60),
                  child: RefreshIndicator(
                    displacement: 55,
                    backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                    color: Provider.of<ThemesNotifier>(context).currentThemeData.primaryColor,
                    strokeWidth: 3,
                    onRefresh: updateStateWithFeed,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      children: _feedUtils.fromEntitiesToWidgetList(
                        news: _rubnews,
                        events: _events,
                        mixInto: Provider.of<SettingsHandler>(context).currentSettings.feedFilter.contains('Events') ||
                            Provider.of<SettingsHandler>(context).currentSettings.newsExplore,
                      ),
                    ),
                  ),
                ),
                // Header
                Container(
                  padding: EdgeInsets.only(top: Platform.isAndroid ? 10 : 0, bottom: 20),
                  color: _headerOpacity == 1
                      ? Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor
                      : Colors.transparent,
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
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(bottom: 80, left: 20, right: 20),
                                    content: Text('Hier gibts noch nichts zu suchen :D'),
                                  ),
                                );
                              },
                            ),
                            // FeedPicker
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: CampusSegmentedControl(
                                leftTitle: 'Feed',
                                rightTitle: 'Explore',
                                onChanged: saveFeedExplore,
                                selected:
                                    Provider.of<SettingsHandler>(context, listen: false).currentSettings.newsExplore ==
                                            false
                                        ? 0
                                        : 1,
                              ),
                            ),
                            // Filter button
                            CampusIconButton(
                              iconPath: 'assets/img/icons/filter.svg',
                              onTap: () {
                                widget.mainNavigatorKey.currentState?.push(PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (context, _, __) => FeedFilterPopup(
                                    selectedFilters: Provider.of<SettingsHandler>(context).currentSettings.feedFilter,
                                    onClose: saveChangedFilters,
                                  ),
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

  /// Function that call usecase and parse widgets into the corresponding
  /// lists of events, news and failures.
  Future<void> updateStateWithFeed() async {
    final newsData = await _rubnewsUsecases.updateFeedAndFailures();
    final eventData = await _calendarUsecase.updateEventsAndFailures();

    setState(() {
      _rubnews = newsData['news']! as List<NewsEntity>;
      _events = eventData['events']! as List<Event>;
      _failures = (newsData['failures']! as List<Failure>)..addAll(eventData['failures']! as List<Failure>);
    });
  }
}
