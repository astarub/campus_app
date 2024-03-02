import 'dart:io' show Platform;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:snapping_sheet_2/snapping_sheet.dart';

import 'package:campus_app/core/failures.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/backend/backend_repository.dart';
import 'package:campus_app/core/backend/entities/publisher_entity.dart';
import 'package:campus_app/pages/feed/news/news_entity.dart';
import 'package:campus_app/pages/feed/news/news_usecases.dart';
import 'package:campus_app/pages/feed/widgets/feed_item.dart';
import 'package:campus_app/pages/feed/widgets/feed_filter_popup.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/utils/pages/feed_utils.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/campus_segmented_control.dart';
import 'package:campus_app/utils/widgets/campus_search_bar.dart';
import 'package:campus_app/utils/widgets/scroll_to_top_button.dart';

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

class FeedPageState extends State<FeedPage> with WidgetsBindingObserver, AutomaticKeepAliveClientMixin<FeedPage> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  late final ScrollController _scrollController;
  double scrollControllerLastOffset = 0;
  double headerOpacity = 1;
  double newsWidgetOpacity = 1;

  List<NewsEntity> news = [];
  List<Failure> failures = [];
  List<Widget> parsedNewsWidgets = [];
  List<Widget> searchNewsWidgets = [];

  final NewsUsecases _newsUsecases = sl<NewsUsecases>();
  final FeedUtils _feedUtils = sl<FeedUtils>();
  final BackendRepository backendRepository = sl<BackendRepository>();

  late final SnappingSheetController popupController;

  String searchWord = '';
  bool showSearchBar = false;

  /// Function that call usecase and parse widgets into the corresponding
  /// lists of events, news and failures.
  Future<void> updateStateWithFeed({bool withAnimation = false}) async {
    if (withAnimation) setState(() => newsWidgetOpacity = 0);

    try {
      await backendRepository.loadPublishers(Provider.of<SettingsHandler>(context, listen: false));
      // ignore: empty_catches
    } catch (e) {}

    final newsData = await _newsUsecases.updateFeedAndFailures();

    try {
      setState(() {
        news = newsData['news'] != null ? newsData['news']! as List<NewsEntity> : [];
        parsedNewsWidgets = parseUpdateToWidgets();
      });
    } catch (e) {
      debugPrint('Error: $e');
    }

    // Apply search to newly parsed feed items
    onSearch(searchWord);

    debugPrint('Feed aktualisiert.');
  }

  /// Parse the updated news data into widgets and mix them with events if needed
  List<Widget> parseUpdateToWidgets() {
    setState(() => newsWidgetOpacity = 1);

    return _feedUtils.fromEntitiesToWidgetList(
      news: news,
    );
  }

  void saveChangedFilters(List<Publisher> newFilters) {
    final Settings newSettings =
        Provider.of<SettingsHandler>(context, listen: false).currentSettings.copyWith(feedFilter: newFilters);

    debugPrint('Saving new feed filters: ${newSettings.feedFilter.map((e) => e.name).toList()}');
    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;
  }

  void saveFeedExplore(int selected) {
    bool explore = false;
    if (selected == 1) explore = true;

    final Settings newSettings =
        Provider.of<SettingsHandler>(context, listen: false).currentSettings.copyWith(newsExplore: explore);

    debugPrint('Saving newsExplore: ${newSettings.newsExplore}');
    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;

    // Mix in widget when changed to the explore section and vice versa
    setState(() {
      parsedNewsWidgets = parseUpdateToWidgets();
      onSearch(searchWord);
    });
  }

  /// Filters the feed based on the search input of the user
  void onSearch(String search) {
    final List<Widget> filteredWidgets = [];

    for (final Widget e in parsedNewsWidgets) {
      if (e is FeedItem) {
        if (e.title.toUpperCase().contains(search.toUpperCase())) {
          filteredWidgets.add(e);
        }
      } else {
        filteredWidgets.add(e);
      }
    }

    setState(() {
      searchNewsWidgets = filteredWidgets;
      searchWord = search;
    });
  }

  @override
  void initState() {
    super.initState();

    // Add observer in order to listen to `didChangeAppLifecycleState`
    WidgetsBinding.instance.addObserver(this);

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset > (scrollControllerLastOffset + 80) && _scrollController.offset > 0) {
          scrollControllerLastOffset = _scrollController.offset;
          if (headerOpacity != 0) setState(() => headerOpacity = 0);
        } else if (_scrollController.offset < (scrollControllerLastOffset - 250)) {
          scrollControllerLastOffset = _scrollController.offset;
          if (headerOpacity != 1) setState(() => headerOpacity = 1);
        } else if (_scrollController.offset < 80) {
          scrollControllerLastOffset = 0;
          if (headerOpacity != 1) setState(() => headerOpacity = 1);
        }
      });

    popupController = SnappingSheetController();

    // initial data request
    final newsData = _newsUsecases.getCachedFeedAndFailures();
    news = newsData['news']! as List<NewsEntity>; // empty when no data was cached before
    failures = newsData['failures']! as List<Failure>; // CachFailure when no data was cached before

    // Request an update for the feed and show the refresh indicator
    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      refreshIndicatorKey.currentState?.show();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Refresh feed data when app gets back into foreground
    if (state == AppLifecycleState.resumed) {
      updateStateWithFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Filter the feed items based on the selected filters
    final filters = Provider.of<SettingsHandler>(context, listen: false).currentSettings.feedFilter;
    final explore = Provider.of<SettingsHandler>(context, listen: false).currentSettings.newsExplore;

    final List<Widget> filteredFeedItems = !explore
        ? _feedUtils.filterFeedWidgets(
            filters,
            searchWord != '' ? searchNewsWidgets : parsedNewsWidgets,
          )
        : (searchWord != '' ? searchNewsWidgets : parsedNewsWidgets);

    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
      floatingActionButton: ScrollToTopButton(scrollController: _scrollController),
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
                    key: refreshIndicatorKey,
                    displacement: 75,
                    backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                    color: Provider.of<ThemesNotifier>(context).currentThemeData.primaryColor,
                    strokeWidth: 3,
                    onRefresh: () => updateStateWithFeed(withAnimation: true),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredFeedItems.length,
                      itemBuilder: (context, index) => AnimatedOpacity(
                        opacity: newsWidgetOpacity,
                        duration: Duration(milliseconds: 100 + (index * 200)),
                        child: filteredFeedItems[index],
                      ),
                    ),
                  ),
                ),
                // Header
                Container(
                  padding: EdgeInsets.only(
                    top: Platform.isAndroid ? 10 : 0,
                    bottom: 20,
                  ),
                  color: headerOpacity == 1
                      ? Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background
                      : Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Headline
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Feed',
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                        ),
                      ),
                      // FeedPicker & filter
                      AnimatedOpacity(
                        opacity: headerOpacity,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: showSearchBar
                              ? CampusSearchBar(
                                  onChange: onSearch,
                                  onBack: () {
                                    setState(() {
                                      searchNewsWidgets = parsedNewsWidgets;
                                      showSearchBar = false;
                                      searchWord = '';
                                    });
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 8.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Search button
                                      CampusIconButton(
                                        iconPath: 'assets/img/icons/search.svg',
                                        onTap: () {
                                          setState(() {
                                            showSearchBar = true;
                                          });
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
                                              Provider.of<SettingsHandler>(context).currentSettings.newsExplore == false
                                                  ? 0
                                                  : 1,
                                        ),
                                      ),
                                      // Filter button
                                      CampusIconButton(
                                        iconPath: 'assets/img/icons/filter.svg',
                                        onTap: () {
                                          widget.mainNavigatorKey.currentState?.push(
                                            PageRouteBuilder(
                                              opaque: false,
                                              pageBuilder: (context, _, __) => FeedFilterPopup(
                                                selectedFilters: List.from(
                                                  Provider.of<SettingsHandler>(
                                                    context,
                                                  ).currentSettings.feedFilter,
                                                ),
                                                onClose: saveChangedFilters,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
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

  // Keep state alive
  @override
  bool get wantKeepAlive => true;
}
