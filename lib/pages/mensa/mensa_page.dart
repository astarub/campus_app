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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MensaPage extends StatefulWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const MensaPage({
    Key? key,
    required this.mainNavigatorKey,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

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
  late List<Failure> failures = [];

  late int selectedDay;

  DateTime selectedDate = DateTime.now().weekday == 6
      ? DateTime.now().subtract(const Duration(days: 1))
      : DateTime.now().weekday == 7
          ? DateTime.now().subtract(const Duration(days: 2))
          : DateTime.now();

  StreamController<DateTime> streamController = StreamController<DateTime>.broadcast();

  // Keep state alive
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final restaurantConfig = Provider.of<SettingsHandler>(context).currentSettings.mensaRestaurantConfig!;

    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
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
                  padding: EdgeInsets.only(top: Platform.isAndroid ? 10 : 0, bottom: 15),
                  color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
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
                                  // TODO: Refactor instead of endless if-else
                                  entities: index == 1
                                      ? mensaDishes
                                      : index == 2
                                          ? roteBeeteDishes
                                          : index == 3
                                              ? qwestDishes
                                              : unikidsDishes,
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

  @override
  void initState() {
    super.initState();

    // Add observer in order to listen to `didChangeAppLifecycleState`
    WidgetsBinding.instance.addObserver(this);

    switch (DateTime.now().weekday) {
      case 1: // Monday
        selectedDay = 0;
        break;
      case 2: // Tuesday
        selectedDay = 1;
        break;
      case 3: // Wednesday
        selectedDay = 2;
        break;
      case 4: // Thursday
        selectedDay = 3;
        break;
      default: // Friday, Saturday or Sunday
        selectedDay = 4;
        break;
    }

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
