import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/mensa/widgets/meal_category.dart';
import 'package:campus_app/utils/pages/presentation_functions.dart';

class MensaUtils extends Utils {
  bool isUppercase(String str) {
    return str == str.toUpperCase();
  }

  /// check if the string contains only numbers
  bool isNumeric(String str) {
    final RegExp numeric = RegExp(r'^-?[0-9]+$');
    return numeric.hasMatch(str);
  }

  /// Parse a list of DishEntity to widget list of type MealCategory.
  List<MealCategory> fromDishListToMealCategoryList({
    required List<DishEntity> entities,
    required int day,
    required void Function(String) onPreferenceTap,
    List<String> mensaPreferences = const [],
    List<String> mensaAllergenes = const [],
  }) {
    // Create a separate list to not edit the one of the SettingsHandler
    final List<String> filteredMensaPreferences = [];
    filteredMensaPreferences.addAll(mensaPreferences);

    // Also show vegan meals, when vegetarian preference is selected
    if (filteredMensaPreferences.contains('V')) {
      filteredMensaPreferences.add('VG');
    }

    final mealCategories = <MealCategory>[];

    // create a set for unique categories
    final categories = <String>{};
    for (final DishEntity dish in entities) {
      categories.add(dish.category);
    }

    for (final category in categories) {
      final meals = <MealItem>[];
      for (final dish in entities.where((dish) => dish.date == day && dish.category == category)) {
        // Do not show meal if user doesn't want this
        if (mensaAllergenes.any(dish.allergenes.contains)) continue;
        if (filteredMensaPreferences.any((e) => dish.infos.contains(e) && !['V', 'VG', 'H'].contains(e))) continue;

        if (!(['V', 'VG', 'H'].any(filteredMensaPreferences.contains) &&
                filteredMensaPreferences.any(dish.infos.contains)) &&
            filteredMensaPreferences.where((e) => e == 'V' || e == 'VG' || e == 'H').isNotEmpty) continue;

        meals.add(
          MealItem(
            name: dish.title,
            price: dish.price,
            infos: dish.infos,
            allergenes: dish.allergenes,
            onPreferenceTap: onPreferenceTap,
          ),
        );
      }
      if (meals.isEmpty) continue;
      mealCategories.add(MealCategory(categoryName: category, meals: meals));
    }

    if (mealCategories.isEmpty) {
      mealCategories.add(const MealCategory(categoryName: 'Heute leider keine Angebote.'));
    }

    return mealCategories;
  }

  /// Hardcoded KulturCafé.
  List<MealCategory> buildKulturCafeRestaurant({
    required void Function(String) onPreferenceTap,
    List<String> mensaPreferences = const [],
    List<String> mensaAllergenes = const [],
  }) {
    return <MealCategory>[
      MealCategory(
        categoryName: 'Belegte Brötchen',
        meals: [
          MealItem(name: 'Käse, Butter, Salat, Gurke und Tomate', price: '2,20€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Salami, Butter, Salat, Gurke und Tomate', price: '2,20€', onPreferenceTap: onPreferenceTap),
          MealItem(
            name: 'gekochtem Schinken, Butter, Salat, Gurke und Tomate',
            price: '2,20€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'rohem Schinken, Butter, Salat, Gurke und Tomate',
            price: '2,20€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Putenbrust, Butter, Salat, Gurke und Tomate',
            price: '2,20€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(name: 'Tofu, Salat, Gurke und Tomate', price: '2,20€', onPreferenceTap: onPreferenceTap),
          MealItem(
            name: 'veganem Brotaufstrich, Salat, Gurke und Tomate',
            price: '2,20€',
            onPreferenceTap: onPreferenceTap,
          ),
        ],
      ),
      MealCategory(
        categoryName: 'Belegte Baguettes',
        meals: [
          MealItem(
            name: 'Käse (Gouda), Salat, Tomate, Gurke, Ei, Remulade und Butter',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Brie, Salat, Tomate, Gurke, Ei, Remulade und Butter',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Hirtenkäse, Salat, Tomate, Gurke, Ei, Remulade und Butter',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Salami, Salat, Tomate, Gurke, Ei, Remulade und Butter',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'gekochtem Schinken, Salat, Tomate, Gurke, Ei, Remulade und Butter',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'rohem Schinken, Salat, Tomate, Gurke, Ei, Remulade und Butter',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Putenbrust, Salat, Tomate, Gurke, Ei, Remulade und Butter',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Tofu, Salat, Tomate, Gurke, Ei, Remulade und Butter',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'veganem Brotaufstrich, Salat, Tomate, Gurke, Ei, Remulade und Butter',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
        ],
      ),
      MealCategory(
        categoryName: 'Überbackene Baguettes',
        meals: [
          MealItem(name: 'Tomaten und Mozzarella', price: '4,40€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Schinken und Mozzarella', price: '4,40€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Salami und Mozzarella', price: '4,40€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Thunfisch und Mozzarella', price: '4,40€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Ofenfrische Laugenbrezel', price: '1,20€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Sesamring', price: '1,20€', onPreferenceTap: onPreferenceTap),
        ],
      ),
      MealCategory(
        categoryName: 'Sandwich-Toasties',
        meals: [
          MealItem(name: 'Tomate, Ei, Käse und Remoulade', price: '3,80€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Salami, Tomate, Käse und Remoulade', price: '3,80€', onPreferenceTap: onPreferenceTap),
          MealItem(
            name: 'gekochten Schinken, Tomate, Käse und Remoulade',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'gekochten Schinken, Ananas, Käse und Remoulade',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'rohen Schinken, Ananas, Käse und Remoulade',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(name: 'Putenbrust, Tomate, Käse und Remoulade', price: '3,80€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Putenbrust, Orange, Käse und Remoulade', price: '3,80€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Hirtenkäse, Zwiebeln, Käse und Remoulade', price: '3,80€', onPreferenceTap: onPreferenceTap),
        ],
      ),
      MealCategory(
        categoryName: 'Suppen',
        meals: [
          MealItem(
            name: 'Fruchtige Tomatensuppe mit Sahne und geschälten Tomaten (vegetarisch)',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Ravensberger Champignon-Cremesuppe 	mit Sahne (vegetarisch)',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Holländische Lauch-Cremesuppe 	mit Sauerrahm (vegetarisch)',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Ungarische Gulaschsuppe 	mit Rindfleisch und Paprika',
            price: '3,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(name: 'Zwiebelsuppe mit Brot und Käse überbacken', price: '3,80€', onPreferenceTap: onPreferenceTap),
        ],
      ),
      MealCategory(
        categoryName: 'Salate',
        meals: [
          MealItem(
            name: 'Kleiner gemischter Salat: Blattsalat, Tomaten, Gurken',
            price: '4,00€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Griechischer Salat: Blattsalat, Tomaten, Gurken, Paprika, Oliven, Zwiebeln, Hirtenkäse',
            price: '5,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Italienischer Salat: Blattsalat, Tomaten, Gurken, Mais, Oliven Perpperoni, Gouda',
            price: '5,80€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Extras: Mais, Ei, Pepperoni, Oliven, Hähnchenbruststreifen, Schafskäse, Gouda oder Schinken',
            price: '1,00€',
            onPreferenceTap: onPreferenceTap,
          ),
        ],
      ),
      MealCategory(
        categoryName: 'Kleine Snacks',
        meals: [
          MealItem(
            name: 'Portion schwarze Oliven (Als Beilage wird Brot gereicht.)',
            price: '3,40€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Portion grüne Oliven (Als Beilage wird Brot gereicht.)',
            price: '3,40€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Portion Pepperonis (Als Beilage wird Brot gereicht.)',
            price: '3,40€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Portion Hirtenkäse (Als Beilage wird Brot gereicht.)',
            price: '3,40€',
            onPreferenceTap: onPreferenceTap,
          ),
        ],
      ),
      MealCategory(
        categoryName: 'Kuchen',
        meals: [
          MealItem(
            name: 'Regelmäßig wechselnde Kuchenauswahl ohne Sahne',
            price: '2,20€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Regelmäßig wechselnde Kuchenauswahl mit Sahne',
            price: '3,20€',
            onPreferenceTap: onPreferenceTap,
          ),
        ],
      ),
      MealCategory(
        categoryName: 'Frische Waffeln',
        meals: [
          MealItem(name: 'Portion Waffeln mit Puderzucker', price: '1,80€', onPreferenceTap: onPreferenceTap),
          MealItem(
            name: 'Portion Waffeln mit Puderzucker und Sahne, Erdbeermarmelade, Honig oder Nutella',
            price: '2,60€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Portion Waffeln mit Puderzucker und Heißen Kirschen oder einer Kugel Eis',
            price: '2,80€',
            onPreferenceTap: onPreferenceTap,
          ),
        ],
      ),
      MealCategory(
        categoryName: 'Eis',
        meals: [
          MealItem(
            name: 'Schokolade, Vanille, Erdbeere oder Haselnuss',
            price: '1,00€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(name: 'Eiskaffee', price: '3,40€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Eisschokolade', price: '3,40€', onPreferenceTap: onPreferenceTap),
        ],
      ),
      MealCategory(
        categoryName: 'Kaffee',
        meals: [
          MealItem(name: 'Latte Macchiato', price: '3,40€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Becher Kaffee', price: '1,40€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Gepresster Kaffee', price: '2,20€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Gepresster Milchkaffee', price: '2,20€ / 3,60€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Carokaffee', price: '1,40€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Caromilchkaffee', price: '2,20€ / 3,60€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Cappuccino', price: '2,20€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Espresso', price: '1,60€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Doppelter Espresso', price: '3,00€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Kl. Tässchen Macchiato Espresso', price: '1,60€', onPreferenceTap: onPreferenceTap),
          MealItem(
            name: 'Moccacino (Kakao mit gepressten Kaffee)',
            price: '2,20€ / 3,60€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Café con hielo (gepr. Kaffee mit Milch und Eiswürfeln, Nur im Sommer!)',
            price: '3,40€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(name: 'Eistee - 0,30L', price: '2,20€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Frappé (Nur im Sommer!)', price: '3,40€', onPreferenceTap: onPreferenceTap),
        ],
      ),
      MealCategory(
        categoryName: 'Tee',
        meals: [
          MealItem(
            name:
                'Orientalischer Tee (schwarz), Engl. Breakfast, Assam, Earl Grey, Darjeeling, Vanille, Kamille, Pfefferminz, Grüner, Früchte oder Chai-Latte mit Flavour',
            price: '2,20€',
            onPreferenceTap: onPreferenceTap,
          ),
        ],
      ),
      MealCategory(
        categoryName: 'Heisses',
        meals: [
          MealItem(name: 'Glas Kakao', price: '2,20€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Glas Kakao mit Sahne', price: '3,20€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Heisse Milch', price: '2,20€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Heisse Milch mit Honig', price: '3,00€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Heisse Zitrone', price: '2,20€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Glühwein (Nur im Winter!)', price: '2,60€', onPreferenceTap: onPreferenceTap),
          MealItem(
            name: 'Grog (Rum mit heissem Wasser, Nur im Winter!)',
            price: '2,60€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(name: 'Tee mit Rum (Nur im Winter!)', price: '4,60€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Russische Schokolade (Nur im Winter!)', price: '4,60€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Irish Coffee (Nur im Winter!)', price: '4,60€', onPreferenceTap: onPreferenceTap),
        ],
      ),
      MealCategory(
        categoryName: 'Alkoholfreies',
        meals: [
          MealItem(
            name: 'Coca Cola, Coca Cola light, Fanta, Sprite oder Spezi',
            price: '1,60€ / 3,00€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Ginger Ale, Bitter Lemon, Tonic Water',
            price: '1,80€ / 3,40€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(
            name: 'Bionade (Litschi, Ingwer-Orange, Holunder) - 0,33L',
            price: '2,70€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(name: 'Club Mate - 0,33L', price: '2,70€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Red Bull - 0,25L', price: '3,20€', onPreferenceTap: onPreferenceTap),
        ],
      ),
      MealCategory(
        categoryName: 'Säfte',
        meals: [
          MealItem(
            name:
                'Apfelsaft, Apfelschorle, Orangensaft, Orangenschorle, Kirsch-Nektar, Bananen-Nektar, Pfirisch-Nektar, KiBa/BaKi, Maracuja-Nektar, Andere Saftschorle oder Tomatensaft',
            price: '1,80€ / 3,40',
            onPreferenceTap: onPreferenceTap,
          )
        ],
      ),
      MealCategory(
        categoryName: 'Wein & Sekt',
        meals: [
          MealItem(name: 'Rotwein (Hausmarke, troken) - 0,10L', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Weisswein (Hausmarke, troken) - 0,10L', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Weinschorle (Hausmarke, troken) - 0,10L', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Wein (Flasche) - 0,75L', price: '15€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Sekt (Hausmarke, troken) - 0,10L', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Sekt (Flasche) - 0,75L', price: '15€', onPreferenceTap: onPreferenceTap),
        ],
      ),
      MealCategory(
        categoryName: 'Biere',
        meals: [
          MealItem(name: 'Brinkhoff\'s No 1', price: '2,70€ / 3,20€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Schlösser Alt', price: '2,70€ / 3,20€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Radler', price: '2,70€ / 3,20€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Alster', price: '2,70€ / 3,20€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Krefelder', price: '2,70€ / 3,20€', onPreferenceTap: onPreferenceTap),
        ],
      ),
      MealCategory(
        categoryName: 'Flaschenbiere',
        meals: [
          MealItem(
            name: 'Franziskaner (Hefe-Weizen hell, dunkel oder Alkoholfrei) - 0,50L',
            price: '2,30€',
            onPreferenceTap: onPreferenceTap,
          ),
          MealItem(name: 'Beck\'s - 0,33L', price: '2,70€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Beck\'s Gold - 0,33L', price: '2,70€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Beck\'s Ice - 0,33L', price: '2,70€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Beck\'s Green Lemon - 0,33L', price: '2,70€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Jever Alkoholfrei - 0,33L', price: '2,70€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Malzbier - 0,33L', price: '2,70€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Berliner Weisse rot/grün - 0,33L', price: '2,70€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Desperados - 0,33L', price: '2,70€', onPreferenceTap: onPreferenceTap),
        ],
      ),
      MealCategory(
        categoryName: 'Spirituosen',
        meals: [
          MealItem(name: 'Amaretto - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Bacardi Rum - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Havana Rum - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Baileys - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Ballantine\'s, Scotch - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Campari - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Gin - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Jägermeister - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Jim Beam, Bourbon - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Johnnie Walker - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Ouzo - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Martini Bianco - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Ramazotti - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Southern Comfort - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Tequila Silver - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Tequila Gold - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Wodka - 2cl', price: '2,50€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Red Bull & Wodka - 2cl', price: '3,90€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Red Bull & Jägermeister - 2cl', price: '3,90€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Red Bull & Sekt - 2cl', price: '3,90€', onPreferenceTap: onPreferenceTap),
          MealItem(name: 'Longdrinks zzgl. 1,40€', price: '3,90€ / 4,30€', onPreferenceTap: onPreferenceTap),
        ],
      ),
    ];
  }
}
