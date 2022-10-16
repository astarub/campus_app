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
    final mealCategories = <MealCategory>[];

    // create a set for unique categories
    final categories = <String>{};
    for (DishEntity dish in entities) {
      categories.add(dish.category);
    }

    for (final category in categories) {
      final meals = <MealItem>[];
      for (final dish in entities.where((dish) => dish.date == day && dish.category == category)) {
        // Do not show meal if user doesn't want this
        if (mensaAllergenes.any(dish.allergenes.contains)) continue;
        if (mensaPreferences.any((e) => dish.infos.contains(e) && !['V', 'VG', 'H'].contains(e))) continue;

        if (!(['V', 'VG', 'H'].any(mensaPreferences.contains) && mensaPreferences.any(dish.infos.contains)) &&
            mensaPreferences.where((e) => e == 'V' || e == 'VG' || e == 'H').isNotEmpty) continue;

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
