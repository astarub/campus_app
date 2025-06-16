// ignore_for_file: avoid_escaping_inner_quotes

import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/mensa/widgets/meal_category.dart';

class MensaUtils {
  // name = how to display the name inside the app
  // openingHours = map of days and hours. 1-5 = Mo-Fr, 6 = Sa, 7 = So
  // imagePath = path to the asset that is displayed in the light theme
  final List<Map<String, dynamic>> restaurantConfig = [
    {
      'name': 'KulturCafé',
      'openingHours': {'1-4': '10:00-20:00', '5': '11:00-16:00', '6': '', '7': ''},
      'imagePath': 'assets/img/qwest.png',
    },
    {
      'name': 'Mensa der RUB',
      'openingHours': {'1-5': '11:00-14:30', '6': '', '7': ''},
      'imagePath': 'assets/img/mensa.png',
    },
    {
      'name': 'Rote Bete',
      'openingHours': {'1-5': '11:00-14:30', '6': '', '7': ''},
      'imagePath': 'assets/img/rotebeete.png',
    },
    {
      'name': 'Q-West',
      'openingHours': {'1-5': '11:15-22:00', '6': '', '7': ''},
      'imagePath': 'assets/img/qwest.png',
    },
    {
      'name': 'Unikids / Unizwerge',
      'openingHours': {'6': '', '7': '', '1-5': '07:30-17:30'},
      'imagePath': 'assets/img/mensa.png',
    },
    /*{
      'name': 'WHS Gelsenkirchen',
      'openingHours': {'6': '', '7': '', '1-5': '11:00-14:00'},
      'imagePath': 'assets/img/mensa.png',
    },
    {
      'name': 'WHS Bocholt',
      'openingHours': {'6': '', '7': '', '1-5': '07:30-14:30'},
      'imagePath': 'assets/img/mensa.png',
    },
    {
      'name': 'WHS Recklinghausen',
      'openingHours': {'6': '', '7': '', '1-4': '11:00-13:45', '5': '11:00-13:30'},
      'imagePath': 'assets/img/mensa.png',
    },*/
  ];

  final Map<String, String> dishInfos = {
    'Halal': 'H',
    'Geflügel': 'G',
    'Schwein': 'S',
    'Rind': 'R',
    'Lamm': 'L',
    'Wild': 'W',
    'Alkohol': 'A',
    'Vegan': 'VG',
    'Vegetarisch': 'V',
  };

  final Map<String, String> dishAdditives = {
    'Farbstoff': '1',
    'Konservierungsstoff': '2',
    'Antioxidationsmittel': '3',
    'geschwefelt': '5',
    'geschwärzt': '6',
    'Phosphat': '8',
    'Süßungsmittel': '9',
    'Phenylalaninquelle': '10',
    'Schwefeldioxid': 'E220',
    'koffeinhaltig': '12',
    'Gelatine': 'EG',
    'Geschmacksverstärker': '4',
  };

  final Map<String, String> dishAllergenes = {
    'Gluten': 'a',
    'Weizen': 'a1',
    'Roggen': 'a2',
    'Gerste': 'a3',
    'Hafer': 'a4',
    'Dinkel': 'a5',
    'Kamut': 'a6',
    'Krebstiere': 'b',
    'Eier': 'c',
    'Fisch': 'd',
    'Erdnüsse': 'e',
    'Sojabohnen': 'f',
    'Milch': 'g',
    'Spuren von Schalenfrüchte': 'u',
    'Schalenfrucht(e)': 'h',
    'Mandel': 'h1',
    'Haselnuss': 'h2',
    'Walnuss': 'h3',
    'Cashewnuss': 'h4',
    'Pecanuss': 'h5',
    'Paranuss': 'h6',
    'Pistazie': 'h7',
    'Macadamia': 'h8',
    'Sellerie': 'i',
    'Senf': 'j',
    'Sesamsamen': 'k',
    'Schwefeldioxis': 'l',
    'Lupine': 'm',
    'Weichtiere': 'n',
  };

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
          ),
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

  int dishDateToInt(DateTime dishDate) {
    late int date;

    final DateTime lastDayOfWeek = DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday));

    switch (dishDate.weekday) {
      case 1: // Monday
        if (dishDate.compareTo(lastDayOfWeek) > 0) {
          date = 5;
        } else {
          date = 0;
        }
        break;
      case 2: // Tuesday
        if (dishDate.compareTo(lastDayOfWeek) > 0) {
          date = 6;
        } else {
          date = 1;
        }
        break;
      case 3: // Wednesday
        if (dishDate.compareTo(lastDayOfWeek) > 0) {
          date = 7;
        } else {
          date = 2;
        }
        break;
      case 4: // Thursday
        if (dishDate.compareTo(lastDayOfWeek) > 0) {
          date = 8;
        } else {
          date = 3;
        }
        break;
      default: // Friday, Saturday or Sunday
        if (dishDate.compareTo(lastDayOfWeek) > 0) {
          date = 9;
        } else {
          date = 4;
        }
        break;
    }

    return date;
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
      mealCategories.add(const MealCategory(categoryName: 'Kein Speiseplan verfügbar.'));
    }

    return mealCategories;
  }

  String getAWRestaurantId(int restaurant) {
    switch (restaurant) {
      case 1:
        return 'mensa_rub';
      case 2:
        return 'rote_bete';
      case 3:
        return 'qwest';
      case 4:
        return 'henkelmann';
      case 5:
        return 'unikids';
      /*case 6:
        return 'whs_mensa';
      case 7:
        return 'bocholt';
      case 8:
        return 'recklinghausen';*/
      default:
        return 'mensa_rub';
    }
  }

  /// check if the string contains only numbers
  bool isNumeric(String str) {
    final RegExp numeric = RegExp(r'^-?[0-9]+$');
    return numeric.hasMatch(str);
  }

  bool isUppercase(String str) {
    return str == str.toUpperCase();
  }

  List<String> readListOfAdditives(List<dynamic> awList) {
    final retVal = <String>[];

    for (final additiv in awList) {
      if (additiv is String) {
        if (dishAdditives.containsValue(additiv)) retVal.add(additiv);
      }
    }

    return retVal;
  }

  List<String> readListOfAllergenes(List<dynamic> awList) {
    final retVal = <String>[];

    for (final allergene in awList) {
      if (allergene is String) {
        if (dishAllergenes.containsValue(allergene)) retVal.add(allergene);
      }
    }

    return retVal;
  }

  List<String> readListOfInfos(List<dynamic> awList) {
    final retVal = <String>[];

    for (final info in awList) {
      if (info is String) {
        if (dishInfos.containsValue(info)) retVal.add(info);
      }
    }

    return retVal;
  }
}
