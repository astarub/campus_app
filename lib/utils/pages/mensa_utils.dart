import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/mensa/widgets/meal_category.dart';
import 'package:campus_app/utils/pages/presentation_functions.dart';

class MensaUtils extends Utils {
  bool isUppercase(String str) {
    return str == str.toUpperCase();
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
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
    final List<DishEntity> entities = [
      // Belegte Brötchen
      const DishEntity(date: 0, title: 'Käse, Butter, Salat, Gurke und Tomate', category: 'Belegte Brötchen', price: '2,20€', infos: ['V']),
      const DishEntity(date: 0, title: 'Salami, Butter, Salat, Gurke und Tomate', category: 'Belegte Brötchen', price: '2,20€', infos: ['G']),
      const DishEntity(date: 0, title: 'gekochtem Schinken, Butter, Salat, Gurke und Tomate', category: 'Belegte Brötchen', price: '2,20€', infos: ['S']),
      const DishEntity(date: 0, title: 'rohem Schinken, Butter, Salat, Gurke und Tomate', category: 'Belegte Brötchen', price: '2,20€', infos: ['S']),
      const DishEntity(date: 0, title: 'Putenbrust, Butter, Salat, Gurke und Tomate', category: 'Belegte Brötchen', price: '2,20€', infos: ['G']),
      const DishEntity(date: 0, title: 'Tofu, Salat, Gurke und Tomate', category: 'Belegte Brötchen', price: '2,20€', infos: ['VG']),
      const DishEntity(date: 0, title: 'veganem Brotaufstrich, Salat, Gurke und Tomate', category: 'Belegte Brötchen', price: '2,20€', infos: ['VG']),
      // Belegte Baguettes
      const DishEntity(date: 0, title: 'Käse (Gouda), Salat, Tomate, Gurke, Ei, Remulade und Butter', category: 'Belegte Baguettes', price: '3,80€', infos: ['V']),
      const DishEntity(date: 0, title: 'Brie, Salat, Tomate, Gurke, Ei, Remulade und Butter', category: 'Belegte Baguettes', price: '3,80€', infos: ['V']),
      const DishEntity(date: 0, title: 'Hirtenkäse, Salat, Tomate, Gurke, Ei, Remulade und Butter', category: 'Belegte Baguettes', price: '3,80€', infos: ['V']),
      const DishEntity(date: 0, title: 'Salami, Salat, Tomate, Gurke, Ei, Remulade und Butter', category: 'Belegte Baguettes', price: '3,80€', infos: ['G']),
      const DishEntity(date: 0, title: 'gekochtem Schinken, Salat, Tomate, Gurke, Ei, Remulade und Butter', category: 'Belegte Baguettes', price: '3,80€', infos: ['S']),
      const DishEntity(date: 0, title: 'rohem Schinken, Salat, Tomate, Gurke, Ei, Remulade und Butter', category: 'Belegte Baguettes', price: '3,80€', infos: ['S']),
      const DishEntity(date: 0, title: 'Putenbrust, Salat, Tomate, Gurke, Ei, Remulade und Butter', category: 'Belegte Baguettes', price: '3,80€', infos: ['G']),
      const DishEntity(date: 0, title: 'Tofu, Salat, Tomate, Gurke, Ei', category: 'Belegte Baguettes', price: '3,80€', infos: ['VG']),
      const DishEntity(date: 0, title: 'veganem Brotaufstrich, Salat, Tomate, Gurke', category: 'Belegte Baguettes', price: '3,80€', infos: ['VG']),
      // Überbackene Baguettes
      const DishEntity(date: 0, title: 'Tomaten und Mozzarella', category: 'Überbackene Baguettes', price: '4,40€', infos: ['V']),
      const DishEntity(date: 0, title: 'Schinken und Mozzarella', category: 'Überbackene Baguettes', price: '4,40€', infos: ['S']),
      const DishEntity(date: 0, title: 'Salami und Mozzarella', category: 'Überbackene Baguettes', price: '4,40€', infos: ['G']),
      const DishEntity(date: 0, title: 'Thunfisch und Mozzarella', category: 'Überbackene Baguettes', price: '4,40€', infos: ['F']),
      const DishEntity(date: 0, title: 'Ofenfrische Laugenbrezel', category: 'Überbackene Baguettes', price: '1,20€', infos: ['V']),
      const DishEntity(date: 0, title: 'Sesamring', category: 'Überbackene Baguettes', price: '1,20€' , infos: ['V']),
      // Sandwich-Toasties
      const DishEntity(date: 0, title: 'Tomate, Ei, Käse und Remoulade', category: 'Sandwich-Toasties', price: '3,80€', infos: ['V']),
      const DishEntity(date: 0, title: 'Salami, Tomate, Käse und Remoulade', category: 'Sandwich-Toasties', price: '3,80€', infos: ['G']),
      const DishEntity(date: 0, title: 'gekochten Schinken, Tomate, Käse und Remoulade', category: 'Sandwich-Toasties', price: '3,80€', infos: ['S']),
      const DishEntity(date: 0, title: 'gekochten Schinken, Ananas, Käse und Remoulade', category: 'Sandwich-Toasties', price: '3,80€', infos: ['S']),
      const DishEntity(date: 0, title: 'rohen Schinken, Ananas, Käse und Remoulade', category: 'Sandwich-Toasties', price: '3,80€', infos: ['S']),
      const DishEntity(date: 0, title: 'Putenbrust, Tomate, Käse und Remoulade', category: 'Sandwich-Toasties', price: '3,80€', infos: ['G']),
      const DishEntity(date: 0, title: 'Putenbrust, Orange, Käse und Remoulade', category: 'Sandwich-Toasties', price: '3,80€', infos: ['G']),
      const DishEntity(date: 0, title: 'Hirtenkäse, Zwiebeln, Käse und Remoulade', category: 'Sandwich-Toasties', price: '3,80€', infos: ['V']),
      // Suppen
      const DishEntity(date: 0, title: 'Fruchtige Tomatensuppe mit Sahne und geschälten Tomaten', category: 'Suppen', price: '3,80€', infos: ['V']),
      const DishEntity(date: 0, title: 'Ravensberger Champignon-Cremesuppe 	mit Sahne', category: 'Suppen', price: '3,80€', infos: ['V']),
      const DishEntity(date: 0, title: 'Holländische Lauch-Cremesuppe 	mit Sauerrahm', category: 'Suppen', price: '3,80€', infos: ['V']),
      const DishEntity(date: 0, title: 'Ungarische Gulaschsuppe mit Rindfleisch und Paprika', category: 'Suppen', price: '3,80€', infos: ['R']),
      const DishEntity(date: 0, title: 'Zwiebelsuppe mit Brot und Käse überbacken', category: 'Suppen', price: '3,80€', infos: ['V']),
      // Salate
      const DishEntity(date: 0, title: 'Kleiner gemischter Salat: Blattsalat, Tomaten, Gurken', category: 'Salate', price: '4,00€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Griechischer Salat: Blattsalat, Tomaten, Gurken, Paprika, Oliven, Zwiebeln, Hirtenkäse', category: 'Salate', price: '5,80€', infos: ['V']),
      const DishEntity(date: 0, title: 'Italienischer Salat: Blattsalat, Tomaten, Gurken, Mais, Oliven Perpperoni, Gouda', category: 'Salate', price: '5,80€', infos: ['V']),
      const DishEntity(date: 0, title: 'Extras: Mais, Pepperoni oder Oliven', category: 'Salate', price: '1,00€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Extras: Ei, Schafskäse oder Gouda', category: 'Salate', price: '1,00€', infos: ['V']),
      const DishEntity(date: 0, title: 'Extras: Hähnchenbruststreifen', category: 'Salate', price: '1,00€', infos: ['G']),
      const DishEntity(date: 0, title: 'Extras: Schinken', category: 'Salate', price: '1,00€', infos: ['S']),
      // Kleine Snacks
      const DishEntity(date: 0, title: 'Portion schwarze Oliven', category: 'Kleine Snacks (mit Brot)', price: '3,40€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Portion grüne Oliven', category: 'Kleine Snacks (mit Brot)', price: '3,40€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Portion Pepperonis', category: 'Kleine Snacks (mit Brot)', price: '3,40€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Portion Hirtenkäse', category: 'Kleine Snacks (mit Brot)', price: '3,40€', infos: ['V']),
      // Kuchen
      const DishEntity(date: 0, title: 'Regelmäßig wechselnde Kuchenauswahl ohne Sahne', category: 'Kuchen', price: '2,20€'),
      const DishEntity(date: 0, title: 'Regelmäßig wechselnde Kuchenauswahl mit Sahne', category: 'Kuchen', price: '3,20€'),
      // Frische Waffeln
      const DishEntity(date: 0, title: 'Portion Waffeln mit Puderzucker', category: 'Frische Waffeln', price: '1,80€', infos: ['V']),
      const DishEntity(date: 0, title: 'Portion Waffeln mit Puderzucker und Sahne, Erdbeermarmelade, Honig oder Nutella', category: 'Frische Waffeln', price: '2,60€', infos: ['V']),
      const DishEntity(date: 0, title: 'Portion Waffeln mit Puderzucker und Heißen Kirschen oder einer Kugel Eis', category: 'Frische Waffeln', price: '2,80€', infos: ['V']),
      // Eis
      const DishEntity(date: 0, title: 'Schokolade, Vanille, Erdbeere oder Haselnuss', category: 'Eis', price: '1,00€', infos: ['V']),
      const DishEntity(date: 0, title: 'Eiskaffee', category: 'Eis', price: '3,40€', infos: ['V']),
      const DishEntity(date: 0, title: 'Eisschokolade', category: 'Eis', price: '3,40€', infos: ['V']),
      // Kaffee
      const DishEntity(date: 0, title: 'Latte Macchiato', category: 'Kaffee', price: '3,40€', infos: ['V']),
      const DishEntity(date: 0, title: 'Becher Kaffee', category: 'Kaffee', price: '1,40€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Gepresster Kaffee', category: 'Kaffee', price: '2,20€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Gepresster Milchkaffee', category: 'Kaffee', price: '2,20€ / 3,60€', infos: ['V']),
      const DishEntity(date: 0, title: 'Carokaffee', category: 'Kaffee', price: '1,40€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Caromilchkaffee', category: 'Kaffee', price: '2,20€ / 3,60€', infos: ['V']),
      const DishEntity(date: 0, title: 'Cappuccino', category: 'Kaffee', price: '2,20€', infos: ['V']),
      const DishEntity(date: 0, title: 'Espresso', category: 'Kaffee', price: '1,60€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Doppelter Espresso', category: 'Kaffee', price: '3,00€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Kl. Tässchen Macchiato Espresso', category: 'Kaffee', price: '1,60€', infos: ['V']),
      const DishEntity(date: 0, title: 'Moccacino (Kakao mit gepressten Kaffee)', category: 'Kaffee', price: '2,20€ / 3,60€', infos: ['V']),
      const DishEntity(date: 0, title: 'Café con hielo (gepr. Kaffee mit Milch und Eiswürfeln, Nur im Sommer!)', category: 'Kaffee', price: '3,40€', infos: ['V']),
      const DishEntity(date: 0, title: 'Frappé (Nur im Sommer!)', category: 'Kaffee', price: '3,40€', infos: ['V']),
      // Tee
      const DishEntity(date: 0, title: 'Orientalischer Tee (schwarz), Engl. Breakfast, Assam, Earl Grey, Darjeeling, Vanille, Kamille, Pfefferminz, Grüner oder Früchte', category: 'Tee', price: '2,20€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Chai-Latte mit Flavour', category: 'Tee', price: '2,20€', infos: ['V']),
      // Heisses
      const DishEntity(date: 0, title: 'Glas Kakao', category: 'Heisses', price: '2,20€', infos: ['V']),
      const DishEntity(date: 0, title: 'Glas Kakao mit Sahne', category: 'Heisses', price: '3,20€', infos: ['V']),
      const DishEntity(date: 0, title: 'Heisse Milch', category: 'Heisses', price: '2,20€', infos: ['V']),
      const DishEntity(date: 0, title: 'Heisse Milch mit Honig', category: 'Heisses', price: '3,00€', infos: ['V']),
      const DishEntity(date: 0, title: 'Heisse Zitrone', category: 'Heisses', price: '2,20€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Glühwein (Nur im Winter!)', category: 'Heisses', price: '2,60€', infos: ['V']),
      const DishEntity(date: 0, title: 'Grog (Rum mit heissem Wasser, Nur im Winter!)', category: 'Heisses', price: '2,60€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Tee mit Rum (Nur im Winter!)', category: 'Heisses', price: '4,60€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Russische Schokolade (Nur im Winter!)', category: 'Heisses', price: '4,60€', infos: ['V']),
      const DishEntity(date: 0, title: 'Irish Coffee (Nur im Winter!)', category: 'Heisses', price: '4,60€', infos: ['V']),
      // Alkoholfreies
      const DishEntity(date: 0, title: 'Coca Cola, Coca Cola light, Fanta, Sprite oder Spezi', category: 'Alkoholfreies', price: '1,60€ / 3,00€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Ginger Ale, Bitter Lemon, Tonic Water', category: 'Alkoholfreies', price: '1,80€ / 3,40€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Bionade (Litschi, Ingwer-Orange, Holunder) - 0,33L', category: 'Alkoholfreies', price: '2,70€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Club Mate - 0,33L', category: 'Alkoholfreies', price: '2,70€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Red Bull - 0,25L', category: 'Alkoholfreies', price: '3,20€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Eistee - 0,30L', category: 'Alkoholfreies', price: '2,20€', infos: ['VG']),
      // Säfte
      const DishEntity(date: 0, title: 'Apfelsaft, Apfelschorle, Orangensaft, Orangenschorle, Kirsch-Nektar, Bananen-Nektar, Pfirisch-Nektar, KiBa/BaKi, Maracuja-Nektar, Andere Saftschorle oder Tomatensaft', category: 'Säfte', price: '1,80€ / 3,40', infos: ['VG']),
      // Wein & Sekt
      const DishEntity(date: 0, title: 'Rotwein (Hausmarke, troken) - 0,10L', category: 'Wein & Sekt', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Weisswein (Hausmarke, troken) - 0,10L', category: 'Wein & Sekt', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Weinschorle (Hausmarke, troken) - 0,10L', category: 'Wein & Sekt', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Wein (Flasche) - 0,75L', category: 'Wein & Sekt', price: '15€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Sekt (Hausmarke, troken) - 0,10L', category: 'Wein & Sekt', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Sekt (Flasche) - 0,75L', category: 'Wein & Sekt', price: '15€', infos: ['VG']),
      // Biere
      const DishEntity(date: 0, title: "Brinkhoff's No 1", category: 'Biere', price: '2,70€ / 3,20€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Schlösser Alt', category: 'Biere', price: '2,70€ / 3,20€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Radler', category: 'Biere', price: '2,70€ / 3,20€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Alster', category: 'Biere', price: '2,70€ / 3,20€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Krefelder', category: 'Biere', price: '2,70€ / 3,20€', infos: ['VG']),
      // Flaschenbiere
      const DishEntity(date: 0, title: 'Franziskaner (Hefe-Weizen hell, dunkel oder Alkoholfrei) - 0,50L', category: 'Flaschenbiere', price: '2,30€', infos: ['VG']),
      const DishEntity(date: 0, title: "Beck's - 0,33L", category: 'Flaschenbiere', price: '2,70€', infos: ['VG']),
      const DishEntity(date: 0, title: "Beck's Gold - 0,33L", category: 'Flaschenbiere', price: '2,70€', infos: ['VG']),
      const DishEntity(date: 0, title: "Beck's Ice - 0,33L", category: 'Flaschenbiere', price: '2,70€', infos: ['VG']),
      const DishEntity(date: 0, title: "Beck's Green Lemon - 0,33L", category: 'Flaschenbiere', price: '2,70€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Jever Alkoholfrei - 0,33L', category: 'Flaschenbiere', price: '2,70€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Malzbier - 0,33L', category: 'Flaschenbiere', price: '2,70€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Berliner Weisse rot/grün - 0,33L', category: 'Flaschenbiere', price: '2,70€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Desperados - 0,33L', category: 'Flaschenbiere', price: '2,70€', infos: ['VG']),
      // Spirituosen
      const DishEntity(date: 0, title: 'Amaretto - 2cl', category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Bacardi Rum - 2cl', category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Havana Rum - 2cl', category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Baileys - 2cl', category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: "Ballantine's, Scotch - 2cl", category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Campari - 2cl', category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Gin - 2cl', category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Jägermeister - 2cl', category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Jim Beam, Bourbon - 2cl', category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Johnnie Walker - 2cl', category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Ouzo - 2cl', category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Martini Bianco - 2cl', category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Southern Comfort - 2cl', category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Tequila Silver - 2cl', category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Tequila Gold - 2cl', category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Wodka - 2cl', category: 'Spirituosen', price: '2,50€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Red Bull & Wodka - 2cl', category: 'Spirituosen', price: '3,90€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Red Bull & Jägermeister - 2cl', category: 'Spirituosen', price: '3,90€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Red Bull & Sekt - 2cl', category: 'Spirituosen', price: '3,90€', infos: ['VG']),
      const DishEntity(date: 0, title: 'Longdrinks zzgl. 1,40€', category: 'Spirituosen', price: '3,90€ / 4,30€', infos: ['VG']),
    ];

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
      for (final dish in entities.where((dish) => dish.category == category)) {
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

    return mealCategories;
  }
}
