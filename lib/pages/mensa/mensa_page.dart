import 'dart:async';
import 'dart:io' show Platform;

import 'package:campus_app/core/failures.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/mensa/mensa_usecases.dart';
import 'package:campus_app/pages/mensa/widgets/allergenes_popup.dart';
import 'package:campus_app/pages/mensa/widgets/day_selection.dart';
import 'package:campus_app/pages/mensa/widgets/expandable_restaurant.dart';
import 'package:campus_app/pages/mensa/widgets/preferences_popup.dart';
import 'package:campus_app/utils/pages/mensa_utils.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/utils/widgets/scroll_to_top_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MensaPage extends StatefulWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const MensaPage({
    super.key,
    required this.mainNavigatorKey,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  });

  @override
  State<MensaPage> createState() => MensaPageState();
}

class MensaPageState extends State<MensaPage> with WidgetsBindingObserver, AutomaticKeepAliveClientMixin<MensaPage> {
  final ScrollController scrollController = ScrollController();

  late Settings settings;

  final MensaUsecases mensaUsecases = sl<MensaUsecases>();
  final MensaUtils mensaUtils = sl<MensaUtils>();

  late List<DishEntity> mensaDishes = [];
  late List<DishEntity> roteBeeteDishes = [];
  late List<DishEntity> qwestDishes = [];
  late List<DishEntity> henkelmannDishes = [];
  late List<DishEntity> unikidsDishes = [];
  late List<DishEntity> whsMensaDishes = [];
  late List<DishEntity> bocholtDishes = [];
  late List<DishEntity> recklinghausenDishes = [];
  late List<Failure> failures = [];

  // Weekday to show as selected
  int selectedDay = -1;

  // Weekday that is selected
  // Initialize with current date or next monday on weekends
  DateTime selectedDate = DateTime.now();

  StreamController<DateTime> streamController = StreamController<DateTime>.broadcast();

  // Keep state alive
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final restaurantConfig = !kDebugMode
        ? Provider.of<SettingsHandler>(context).currentSettings.mensaRestaurantConfig!
        : mensaUtils.restaurantConfig;

    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
      floatingActionButton: ScrollToTopButton(scrollController: scrollController),
      body: Center(
        child: AnimatedExit(
          key: widget.pageExitAnimationKey,
          child: AnimatedEntry(
            key: widget.pageEntryAnimationKey,
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.only(top: Platform.isAndroid ? 10 : 0, bottom: 30),
                  color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
                  child: Column(
                    children: [
                      // Title
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          'Mensa',
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                        ),
                      ),
                      // Day selection
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: MensaDaySelection(
                          onChanged: (int day, DateTime date) {
                            setState(() {
                              selectedDay = day;
                              selectedDate = date;
                            });
                            streamController.add(date);
                          },
                        ),
                      ),
                      // Hint
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.info_outline_rounded, size: 15),
                                Text(
                                  ' Abweichungen möglich! Bitte beachte die Aushänge vor Ort.',
                                  style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                                  textScaler: const TextScaler.linear(0.8),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: CampusButton.light(
                                      text: 'Präferenzen',
                                      width: null,
                                      onTap: () {
                                        widget.mainNavigatorKey.currentState?.push(
                                          PageRouteBuilder(
                                            opaque: false,
                                            pageBuilder: (context, _, __) => PreferencesPopup(
                                              preferences: Provider.of<SettingsHandler>(context)
                                                  .currentSettings
                                                  .mensaPreferences,
                                              onClose: saveChangedPreferences,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: CampusButton.light(
                                      text: 'Allergene',
                                      width: null,
                                      onTap: () {
                                        widget.mainNavigatorKey.currentState?.push(
                                          PageRouteBuilder(
                                            opaque: false,
                                            pageBuilder: (context, _, __) => AllergenesPopup(
                                              allergenes:
                                                  Provider.of<SettingsHandler>(context).currentSettings.mensaAllergenes,
                                              onClose: saveChangedAllergenes,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Place expandables
                Expanded(
                  child: RefreshIndicator(
                    displacement: 10,
                    backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                    color: Provider.of<ThemesNotifier>(context).currentThemeData.primaryColor,
                    strokeWidth: 3,
                    onRefresh: () async {
                      await loadData();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      controller: scrollController,
                      itemCount: restaurantConfig.length,
                      itemBuilder: (context, index) {
                        final dishes = getDishesFromIndex(index);
                        return ExpandableRestaurant(
                          // index = place in list
                          name: restaurantConfig[index]['name'],
                          imagePath: restaurantConfig[index]['imagePath'],
                          selectedDate: selectedDate,
                          stream: streamController.stream,
                          meals: index == 0
                              ? mensaUtils.buildKulturCafeRestaurant(
                                  onPreferenceTap: singlePreferenceSelected,
                                  mensaAllergenes: Provider.of<SettingsHandler>(context, listen: false)
                                      .currentSettings
                                      .mensaAllergenes,
                                  mensaPreferences: Provider.of<SettingsHandler>(context, listen: false)
                                      .currentSettings
                                      .mensaPreferences,
                                )
                              : mensaUtils.fromDishListToMealCategoryList(
                                  entities: dishes,
                                  day: selectedDay,
                                  onPreferenceTap: singlePreferenceSelected,
                                  mensaAllergenes: Provider.of<SettingsHandler>(context, listen: false)
                                      .currentSettings
                                      .mensaAllergenes,
                                  mensaPreferences: Provider.of<SettingsHandler>(context, listen: false)
                                      .currentSettings
                                      .mensaPreferences,
                                ),
                          openingHours: Map<String, String>.from(restaurantConfig[index]['openingHours']),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Refresh mensa data when app gets back into foreground
    if (state == AppLifecycleState.resumed) {
      loadData();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    settings = Provider.of<SettingsHandler>(context).currentSettings;
  }

  /// Return correct list of dishes (RUB Mensa, QWest, etc.) based on
  /// the index inside the restaurant config. The index should the same
  /// as the repository.
  List<DishEntity> getDishesFromIndex(int index) {
    switch (index) {
      // case 0:
      //   return kulturcafeDishes
      case 1:
        return mensaDishes; // mensa + henkelmann
      case 2:
        return roteBeeteDishes;
      case 3:
        return qwestDishes;
      case 4:
        return unikidsDishes;
      case 5:
        return whsMensaDishes;
      case 6:
        return bocholtDishes;
      case 7:
        return recklinghausenDishes;
      default:
        return <DishEntity>[];
    }
  }

  @override
  void initState() {
    super.initState();
    final DateTime today = DateTime.now();

    // Choose selected date to load data: today or next monday on weekend
    selectedDate = today.weekday > 5 ? today.add(Duration(days: 8 - today.weekday)) : today;

    // Add observer in order to listen to `didChangeAppLifecycleState`
    WidgetsBinding.instance.addObserver(this);
    loadData();
  }

  /// This function initiates the loading of the mensa data (and caching)
  Future<void> loadData() async {
    final Future<Map<String, List<dynamic>>> updatedDishes = mensaUsecases.updateDishesAndFailures();

    try {
      await updatedDishes.then(
        (data) => setState(() {
          mensaDishes = data['mensa'] != null ? data['mensa']! as List<DishEntity> : [];
          roteBeeteDishes = data['roteBeete'] != null ? data['roteBeete']! as List<DishEntity> : [];
          qwestDishes = data['qwest'] != null ? data['qwest']! as List<DishEntity> : [];
          henkelmannDishes = data['henkelmann'] != null ? data['henkelmann']! as List<DishEntity> : [];
          unikidsDishes = data['unikids'] != null ? data['unikids']! as List<DishEntity> : [];
          whsMensaDishes = data['whs_mensa'] != null ? data['whs_mensa']! as List<DishEntity> : [];
          bocholtDishes = data['bocholt'] != null ? data['bocholt']! as List<DishEntity> : [];
          recklinghausenDishes = data['recklinghausen'] != null ? data['recklinghausen']! as List<DishEntity> : [];
          failures = data['failures'] != null ? data['failures']! as List<Failure> : [];
        }),
      );
    } catch (e) {
      debugPrint('Error: $e');
    }

    debugPrint('Mensa Daten aktualisiert.');
  }

  /// This function saves the new selected preferences with the [SettingsHandler]
  void saveChangedAllergenes(List<String> newAllergenes) {
    final Settings newSettings =
        Provider.of<SettingsHandler>(context, listen: false).currentSettings.copyWith(mensaAllergenes: newAllergenes);

    debugPrint('Saving new mensa allergenes: ${newSettings.mensaAllergenes}');
    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;
  }

  /// This function saves the new selected preferences with the [SettingsHandler]
  void saveChangedPreferences(List<String> newPreferences) {
    final Settings newSettings =
        Provider.of<SettingsHandler>(context, listen: false).currentSettings.copyWith(mensaPreferences: newPreferences);

    debugPrint('Saving new mensa preferences: ${newSettings.mensaPreferences}');
    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;
  }

  /// This function is called whenever one of the 3 preferences "vegetarian", "vegan"
  /// or "halal" is selected. It automatically adds or removes the preference from the list.
  void singlePreferenceSelected(String selectedPreference) {
    final List<String> newPreferences = settings.mensaPreferences;

    if (settings.mensaPreferences.contains(selectedPreference)) {
      newPreferences.remove(selectedPreference);
    } else {
      newPreferences.add(selectedPreference);
    }

    saveChangedPreferences(newPreferences);
  }
}
