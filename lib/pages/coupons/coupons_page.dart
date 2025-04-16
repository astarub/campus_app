import 'dart:io' show Platform;
import 'package:campus_app/pages/coupons/coupon_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';

class CouponsPage extends StatefulWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;

  const CouponsPage({super.key, required this.mainNavigatorKey});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  final ScrollController _scrollController = ScrollController();
  bool showSearchBar = false;
  String searchWord = '';

  List<String> categories = [
    'Alle',
    'Technik',
    'Mode',
    'Reisen',
    'Essen',
    'Sonstiges',
    'Faiv'
  ];
  String selectedCategory = 'Alle';

  List<Map<String, dynamic>> deals = [
  {
    'title': 'Handy Rabatt',
    'oldPrice': 555.40,
    'newPrice': 499.00,
    'discount': '10%',
    'image': 'assets/img/iphone_coupon.jpg',
    'category': 'Technik',
    'source': 'Markt',
    'url': 'https://example.com/deal1',
    'qrCodeData': 'https://example.com/deal1', // Beispiel: URL, die in QR-Code kodiert wird
  },
  {
    'title': 'Hose und Hemd zu Sonderpreis',
    'oldPrice': 50,
    'newPrice': null,
    'discount': '23%',
    'image': 'assets/img/mode_coupon.jpg',
    'category': 'Mode',
    'source': 'Kleidungsladen',
    'url': 'https://example.com/deal2',
    'qrCodeData': null, // kein QR-Code vorhanden
  },
    {
      'title': 'Gratis Pfankuchen zum Frühstück',
      'oldPrice': null, // No old price
      'newPrice': null, // No new price
      'discount': null, // No discount
      'image': 'assets/img/food_coupon.jpg',
      'category': 'Essen',
      'source': 'Café XY',
      'url': 'https://example.com/deal3',
      'qrCodeData': null, // kein QR-Code vorhanden
    },
    {
      'title': 'Kostenlose Reise nach Spanien Gewinnen',
      'oldPrice': null,
      'newPrice': null,
      'discount': null,
      'image': 'assets/img/reisen_coupon.jpg',
      'category': 'Reisen',
      'source': 'Reisebüro',
      'url': 'https://www.epicgames.com',
      'qrCodeData': null, // kein QR-Code vorhanden
    },
  ];

  List<Map<String, dynamic>> favorites = [];

  List<Map<String, dynamic>> get filteredDeals {
    if (selectedCategory == 'Faiv') {
      return favorites;
    }

    List<Map<String, dynamic>> filtered = deals;
    if (selectedCategory != 'Alle') {
      filtered =
          filtered.where((d) => d['category'] == selectedCategory).toList();
    }

    if (searchWord.isNotEmpty) {
      filtered = filtered
          .where((d) => d['title']
              .toString()
              .toUpperCase()
              .contains(searchWord.toUpperCase()))
          .toList();
    }

    return filtered;
  }

  void toggleFavorite(Map<String, dynamic> deal) {
    setState(() {
      if (favorites.contains(deal)) {
        favorites.remove(deal);
      } else {
        favorites.add(deal);
      }
    });
  }

  void onSearch(String query) {
    setState(() {
      searchWord = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context)
          .currentThemeData
          .colorScheme
          .surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: Platform.isAndroid ? 10 : 0,
                bottom: 20,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    CampusIconButton(
                      iconPath: 'assets/img/icons/arrow-left.svg',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Align(
                      child: Text(
                        'Coupons & Rabatte',
                        style: Provider.of<ThemesNotifier>(context)
                            .currentThemeData
                            .textTheme
                            .displayMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: showSearchBar
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: onSearch,
                              decoration: InputDecoration(
                                hintText: 'Suche nach Angeboten...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Provider.of<ThemesNotifier>(context)
                                        .currentThemeData
                                        .dividerColor,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      searchWord = '';
                                      showSearchBar = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CampusIconButton(
                            iconPath: 'assets/img/icons/search.svg',
                            onTap: () {
                              setState(() {
                                showSearchBar = true;
                              });
                            },
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final cat = categories[index];
                                  final isSelected = cat == selectedCategory;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = cat;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Provider.of<ThemesNotifier>(
                                                    context)
                                                .currentThemeData
                                                .primaryColor
                                            : Provider.of<ThemesNotifier>(
                                                    context)
                                                .currentThemeData
                                                .colorScheme
                                                .surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        cat,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Provider.of<ThemesNotifier>(
                                                      context)
                                                  .currentThemeData
                                                  .colorScheme
                                                  .onPrimary
                                              : Provider.of<ThemesNotifier>(
                                                      context)
                                                  .currentThemeData
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: filteredDeals.length,
                itemBuilder: (context, index) {
                  final deal = filteredDeals[index];
                  return _buildDealCard(context, deal);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealCard(BuildContext context, Map<String, dynamic> deal) {
  final theme = Provider.of<ThemesNotifier>(context).currentThemeData;
  final isFavorite = favorites.contains(deal);

  return Card(
    elevation: 2,
    margin: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: deal['image'] != null
                  ? Image.asset(
                      deal['image'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Container(
                      color: theme.colorScheme.surfaceContainerHighest),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.blue : theme.colorScheme.onSurface,
                ),
                onPressed: () => toggleFavorite(deal),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            deal['title'] ?? '',
            style: theme.textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (deal['newPrice'] != null) ...[
                    if (deal['oldPrice'] != null)
                      Text(
                        '${deal['oldPrice']}€',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Text(
                      '${deal['newPrice']}€',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ] else
                    Text(
                      deal['source'] ?? 'Unbekannte Quelle',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Here we navigate to the detail page,
                  // passing our `deal` as an argument
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CouponDetailPage(deal: deal),
                    ),
                  );
                },
                child: const Text('Zum Angebot'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}
}
