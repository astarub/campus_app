import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/mensa/mensa_usecases.dart';
import 'package:campus_app/utils/pages/mensa_utils.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/pages/mensa/widgets/day_selection.dart';
import 'package:campus_app/pages/mensa/widgets/expandable_restaurant.dart';
import 'package:campus_app/pages/mensa/widgets/preferences_popup.dart';
import 'package:campus_app/pages/mensa/widgets/allergenes_popup.dart';

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
  State<MensaPage> createState() => _MensaPageState();
}

class _MensaPageState extends State<MensaPage> with WidgetsBindingObserver, AutomaticKeepAliveClientMixin<MensaPage> {
  late Settings _settings;

  final MensaUsecases _mensaUsecases = sl<MensaUsecases>();
  final MensaUtils _mensaUtils = sl<MensaUtils>();

  late List<DishEntity> _mensaDishes = [];
  late List<DishEntity> _roteBeeteDishes = [];
  late List<DishEntity> _qwestDishes = [];
  late List<DishEntity> _henkelmannDishes = [];
  late List<Failure> _failures = [];

  late int selectedDay;

  /// This function initiates the loading of the mensa data (and caching)
  Future<void> loadData() async {
    final Future<Map<String, List<dynamic>>> updatedDishes = _mensaUsecases.updateDishesAndFailures();

    await updatedDishes.then(
      (data) => setState(() {
        _mensaDishes = data['mensa']! as List<DishEntity>;
        _roteBeeteDishes = data['roteBeete']! as List<DishEntity>;
        _qwestDishes = data['qwest']! as List<DishEntity>;
        _henkelmannDishes = data['henkelmann']! as List<DishEntity>;
        _failures = data['failures']! as List<Failure>;
      }),
    );

    debugPrint('Mensa Daten aktualisiert.');
  }

  /// This function saves the new selected preferences with the [SettingsHandler]
  void saveChangedPreferences(List<String> newPreferences) {
    final Settings newSettings =
        Provider.of<SettingsHandler>(context, listen: false).currentSettings.copyWith(mensaPreferences: newPreferences);

    debugPrint('Saving new mensa preferences: ${newSettings.mensaPreferences}');
    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;
  }

  /// This function saves the new selected preferences with the [SettingsHandler]
  void saveChangedAllergenes(List<String> newAllergenes) {
    final Settings newSettings =
        Provider.of<SettingsHandler>(context, listen: false).currentSettings.copyWith(mensaAllergenes: newAllergenes);

    debugPrint('Saving new mensa allergenes: ${newSettings.mensaAllergenes}');
    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;
  }

  /// This function is called whenever one of the 3 preferences "vegetarian", "vegan"
  /// or "halal" is selected. It automatically adds or removes the preference from the list.
  void singlePreferenceSelected(String selectedPreference) {
    List<String> newPreferences = _settings.mensaPreferences;

    if (_settings.mensaPreferences.contains(selectedPreference)) {
      newPreferences.remove(selectedPreference);
    } else {
      newPreferences.add(selectedPreference);
    }

    saveChangedPreferences(newPreferences);
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _settings = Provider.of<SettingsHandler>(context).currentSettings;
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
  Widget build(BuildContext context) {
    super.build(context);

    final restaurantConfig = Provider.of<SettingsHandler>(context).currentSettings.mensaRestaurantConfig!;

    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
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
                        child: MensaDaySelection(onChanged: (int day) => setState(() => selectedDay = day)),
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
                      itemCount: restaurantConfig.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // Filter popups
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Row(
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
                          );
                        } else {
                          // Restaurants (index-1 for calling restaurantConfig)
                          return ExpandableRestaurant(
                            name: restaurantConfig[index - 1]['name'],
                            imagePath: restaurantConfig[index - 1]['imagePath'],
                            meals: index == 1
                                ? _mensaUtils.buildKulturCafeRestaurant(
                                    onPreferenceTap: singlePreferenceSelected,
                                    mensaAllergenes: Provider.of<SettingsHandler>(context, listen: false)
                                        .currentSettings
                                        .mensaAllergenes,
                                    mensaPreferences: Provider.of<SettingsHandler>(context, listen: false)
                                        .currentSettings
                                        .mensaPreferences,
                                  )
                                : _mensaUtils.fromDishListToMealCategoryList(
                                    entities: index == 2
                                        ? _mensaDishes
                                        : index == 3
                                            ? _roteBeeteDishes
                                            : index == 4
                                                ? _qwestDishes
                                                : _henkelmannDishes,
                                    day: selectedDay,
                                    onPreferenceTap: singlePreferenceSelected,
                                    mensaAllergenes: Provider.of<SettingsHandler>(context, listen: false)
                                        .currentSettings
                                        .mensaAllergenes,
                                    mensaPreferences: Provider.of<SettingsHandler>(context, listen: false)
                                        .currentSettings
                                        .mensaPreferences,
                                  ),
                            openingHours: Map<String, String>.from(restaurantConfig[index - 1]['openingHours']),
                          );
                        }
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

  // Keep state alive
  @override
  bool get wantKeepAlive => true;
}
