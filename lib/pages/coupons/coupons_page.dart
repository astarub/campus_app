// ignore_for_file: deprecated_member_use, avoid_dynamic_calls, use_build_context_synchronously

import 'dart:io' show Platform;
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/pages/coupons/coupon_detail_page.dart';
import 'package:campus_app/pages/coupons/coupon_backend/coupon_user_backend_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/core/backend/backend_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:share_plus/share_plus.dart';

// Service locator for dependency injection
// Service Locator für Dependency Injection
final GetIt sl = GetIt.instance;

// Main coupons page that displays a list of available coupons/deals
// Hauptseite für Coupons, die eine Liste verfügbarer Angebote anzeigt
class CouponsPage extends StatefulWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;

  const CouponsPage({super.key, required this.mainNavigatorKey});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  // Scroll controller for list view
  // Scroll-Controller für die Listenansicht
  ScrollController _scrollController = ScrollController();

  // UI state variables
  // UI-Zustandsvariablen
  bool showSearchBar = false;
  String searchWord = '';
  bool _isLoading = true;

  // Animation control variables
  // Animationssteuerungsvariablen
  Map<String, bool> fireAnimations = {};
  Map<String, bool> snowAnimations = {};
  Map<String, bool> heartAnimations = {};

  // Error and loading states
  // Fehler- und Ladezustände
  bool _isShowingError = false;
  bool _showFab = false;
  DateTime? _lastScrollTime;
  bool _hasNetworkError = false;
  bool _hasInitialLoad = false;
  dynamic _lastError;

// Filter and sort options
  // Filter- und Sortieroptionen
  List<String> categories = ['Alle', 'Technik', 'Mode', 'Reisen', 'Essen', 'Sonstiges', 'Favorite'];
  String selectedCategory = 'Alle';
  String selectedSort = 'Meiste Upvotes';
  List<String> sortOptions = [
    'Höchster Rabatt',
    'Endet bald',
    'Meiste Upvotes',
    'Neu',
    'Meist gespeichert',
  ];

  // Data storage
  // Datenspeicher
  Map<String, dynamic> userData = {};

  List<Map<String, dynamic>> deals = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadInitialData();

    // Add scroll listener to control FAB visibility
    // Scroll-Listener hinzufügen, um Sichtbarkeit des FAB zu steuern
    _scrollController.addListener(() {
      if (_scrollController.offset > 100) {
        setState(() {
          _showFab = true;
          _lastScrollTime = DateTime.now();
        });
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (_lastScrollTime != null &&
              DateTime.now().difference(_lastScrollTime!) >= const Duration(milliseconds: 1500) &&
              mounted) {
            setState(() => _showFab = false);
          }
        });
      } else {
        setState(() => _showFab = false);
      }
    });
    _loadDealsFromAppwrite();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll listener for pull-to-refresh functionality
  // Scroll-Listener für Pull-to-Refresh-Funktionalität
  void _scrollListener() {
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!_isLoading) {
        _refreshData();
      }
    }
  }

// Loads initial data from backend
  // Lädt anfängliche Daten vom Backend
  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _hasNetworkError = false;
      _lastError = null;
    });

    try {
      await _loadDealsFromAppwrite();

      setState(() {
        _isLoading = false;
        _hasInitialLoad = true;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasInitialLoad = true;
        _hasNetworkError = true;
        _lastError = error;
      });
    }
  }

// Refreshes data from backend
  // Aktualisiert Daten vom Backend
  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _hasNetworkError = false;
      _lastError = null;
    });
    try {
      await _loadDealsFromAppwrite();

      setState(() {
        _isLoading = false;
        _hasInitialLoad = true;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasInitialLoad = true;
        _hasNetworkError = true;
        _lastError = error;
      });
    }
  }

// Shows error snackbar message
  // Zeigt Fehler-Snackbar-Nachricht an
  void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

// Loads deals data from Appwrite backend
  // Lädt Angebotsdaten vom Appwrite-Backend
  Future<void> _loadDealsFromAppwrite() async {
    final backend = sl<BackendRepository>();
    final couponUserBackend = sl<CouponUserBackendRepository>();
    final coupons = await backend.getCoupons();
    final settingsHandler = Provider.of<SettingsHandler>(context, listen: false);
    final couponUser = await couponUserBackend.getUserCoupons(settingsHandler.currentSettings.backendAccount.id);

    setState(() {
      deals = coupons
          .map(
            (coupon) => {
              r'$id': coupon.id,
              r'$createdAt': coupon.createdAt?.toIso8601String(),
              'title': coupon.title,
              'description': coupon.description,
              'oldPrice': coupon.oldPrice,
              'newPrice': coupon.newPrice,
              'discount': coupon.discount,
              'qrCode': coupon.qrCode,
              'images': coupon.images,
              'provider': coupon.provider,
              'website': coupon.website,
              'location': coupon.location,
              'category': coupon.category,
              'expiresAt': coupon.expiresAt?.toIso8601String(),
              'availableCoupons': coupon.availableCoupons,
              'voteCount': coupon.voteCount,
              'hiddenQrCode': coupon.hiddenQrCode,
              'couponUsesCounter': coupon.couponUsesCounter,
            },
          )
          .toList();

      userData = {
        'userId': couponUser.userId,
        'maxCoupons': couponUser.userMaxCoupons ?? [],
        'favorites': couponUser.favoriteCoupons ?? [],
        'likes': couponUser.likedCoupons ?? [],
        'dislikes': couponUser.dislikedCoupons ?? [],
      };
    });
  }

// Calculates fire color intensity based on vote count
  // Berechnet die Feuerfarbe basierend auf der Anzahl der Stimmen
  Color _getFireColor(int votes) {
    final intensity = (votes / 100).clamp(0.3, 1.0);
    return Color.lerp(
      Colors.orange.withOpacity(0.7),
      Colors.redAccent,
      intensity,
    )!;
  }

  // Shares coupon link using platform sharing dialog
  // Teilt Coupon-Link über Plattform-Dialog
  Future<void> shareLink(Map<String, dynamic> deal) async {
    final String link = deal['website'] ?? deal['location'];

    try {
      await Share.share(link);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Teilen fehlgeschlagen: $e')),
      );
    }
  }

// Returns sorted deals based on selected sort option
  // Gibt sortierte Angebote basierend auf der ausgewählten Sortieroption zurück
  List<Map<String, dynamic>> get sortedDeals {
    final filtered = filteredDeals;

    // Helper function to parse discount value from string
    // Hilfsfunktion zum Parsen des Rabattwerts aus einem String
    double parseDiscountValue(dynamic discount) {
      if (discount == null) return 0;

      if (discount is num) return discount.toDouble();

      if (discount is String) {
        final lowerDiscount = discount.toLowerCase();
        if (lowerDiscount.contains('geschenk') ||
            lowerDiscount.contains('kostenlos') ||
            lowerDiscount.contains('umsonst') ||
            lowerDiscount.contains('free') ||
            lowerDiscount.contains('gratis') ||
            lowerDiscount == '100%' ||
            lowerDiscount == '0%' ||
            lowerDiscount == '0€' ||
            lowerDiscount.contains('kostenfrei')) {
          return 100;
        }

        final allPercentMatches = RegExp(r'(\d{1,3})\s*%').allMatches(discount);
        if (allPercentMatches.isNotEmpty) {
          final lastMatch = allPercentMatches.last;
          return double.tryParse(lastMatch.group(1)!) ?? 0;
        }

        final firstNumberMatch = RegExp(r'(\d+)').firstMatch(discount);
        if (firstNumberMatch != null) {
          return double.tryParse(firstNumberMatch.group(1)!) ?? 0;
        }
      }

      return 0;
    }

    // Calculates discount percentage for a deal
    // Berechnet den Rabattprozentsatz für ein Angebot
    double getDealDiscount(Map<String, dynamic> deal) {
      if (deal['oldPrice'] != null && deal['newPrice'] != null) {
        return (deal['oldPrice'] - deal['newPrice']) / deal['oldPrice'] * 100;
      }
      return parseDiscountValue(deal['discount']);
    }

// Separate deals with and without discount
    // Angebote mit und ohne Rabatt trennen
    final dealsWithDiscount = filtered
        .where((deal) => deal['discount'] != null || (deal['oldPrice'] != null && deal['newPrice'] != null))
        .toList();
    final dealsWithoutDiscount = filtered
        .where((deal) => deal['discount'] == null && (deal['oldPrice'] == null || deal['newPrice'] == null))
        .toList();

// Apply sorting based on selected option
    // Sortierung basierend auf ausgewählter Option anwenden
    switch (selectedSort) {
      case 'Höchster Rabatt':
        dealsWithDiscount.sort((a, b) {
          final discountA = getDealDiscount(a);
          final discountB = getDealDiscount(b);

          return discountB.compareTo(discountA);
        });
        // Combine with deals without discount sorted by upvotes
        // Mit Angeboten ohne Rabatt kombinieren, nach Upvotes sortiert
        dealsWithoutDiscount.sort((a, b) => (b['voteCount'] ?? 0).compareTo(a['voteCount'] ?? 0));
        return [...dealsWithDiscount, ...dealsWithoutDiscount];

      case 'Endet bald':
        filtered.sort((a, b) {
          final dateA = a['expiresAt'] != null ? DateTime.tryParse(a['expiresAt']) : null;
          final dateB = b['expiresAt'] != null ? DateTime.tryParse(b['expiresAt']) : null;

          if (dateA == null && dateB == null) return 0;
          if (dateA == null) return 1;
          if (dateB == null) return -1;

          return dateA.compareTo(dateB);
        });
        return filtered;

      case 'Meiste Upvotes':
        filtered.sort((a, b) => (b['voteCount'] ?? 0).compareTo(a['voteCount'] ?? 0));
        return filtered;

      case 'Neu':
        filtered.sort((a, b) {
          final dateA = DateTime.tryParse(a[r'$createdAt'] ?? '') ?? DateTime(0);
          final dateB = DateTime.tryParse(b[r'$createdAt'] ?? '') ?? DateTime(0);
          return dateB.compareTo(dateA);
        });
        return filtered;

      case 'Meist gespeichert':
        filtered.sort((a, b) {
          final savesA = userData['favorites']?.contains(a[r'$id']) ?? false ? 1 : 0;
          final savesB = userData['favorites']?.contains(b[r'$id']) ?? false ? 1 : 0;
          return savesB.compareTo(savesA);
        });
        return filtered;

      default:
        return filtered;
    }
  }

  // Returns filtered deals based on selected category and search term
  // Gibt gefilterte Angebote basierend auf ausgewählter Kategorie und Suchbegriff zurück
  List<Map<String, dynamic>> get filteredDeals {
    if (selectedCategory == 'Favorite') {
      return deals
          .where(
            (deal) => userData['favorites']?.contains(deal[r'$id']) ?? false,
          )
          .toList();
    }

    List<Map<String, dynamic>> filtered = deals;
    if (selectedCategory != 'Alle') {
      filtered = filtered.where((d) => d['category'] == selectedCategory).toList();
    }

    if (searchWord.isNotEmpty) {
      filtered = filtered.where((d) => d['title'].toString().toUpperCase().contains(searchWord.toUpperCase())).toList();
    }

    return filtered;
  }

  // Handles search input changes
  // Verarbeitet Änderungen der Sucheingabe
  void onSearch(String query) {
    setState(() {
      searchWord = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemesNotifier>(context).currentThemeData;
    return Scaffold(
      // Floating action button to scroll to top
      // Floating Action Button zum Nach-oben-scrollen
      floatingActionButton: _showFab
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
                setState(() => _showFab = false);
              },
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.arrow_upward),
            )
          : null,
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header section with back button and title
            // Kopfzeile mit Zurück-Button und Titel
            Padding(
              padding: EdgeInsets.only(
                top: Platform.isAndroid ? 10 : 0,
                bottom: 10,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    // Back button
                    // Zurück-Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CampusIconButton(
                        iconPath: 'assets/img/icons/arrow-left.svg',
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    // Centered title
                    // Zentrierter Titel
                    Align(
                      child: Text(
                        'Coupons & Rabatte',
                        style: theme.textTheme.displayMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Search bar / Filter row
            // Suchleiste / Filter-Zeile
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: showSearchBar
                  // Search field when active
                  // Aktive Suchleiste
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: onSearch,
                              decoration: InputDecoration(
                                hintText: 'Suche nach Angeboten...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: theme.dividerColor.withOpacity(0.5),
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
                  // Filter buttons when search inactive
                  // Filter-Buttons wenn Suche inaktiv
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          // Search toggle button
                          // Such-Button
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CampusIconButton(
                              iconPath: 'assets/img/icons/search.svg',
                              onTap: () {
                                setState(() {
                                  showSearchBar = true;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Combined filter dropdowns
                          // Kombinierte Filter-Dropdowns
                          Expanded(
                            child: Row(
                              children: [
                                // Category filter
                                // Kategorie-Filter
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: theme.colorScheme.outline.withOpacity(0.2),
                                      ),
                                    ),
                                    child: DropdownButton<String>(
                                      value: selectedCategory,
                                      isExpanded: true,
                                      icon: const Icon(Icons.arrow_drop_down, size: 20),
                                      underline: Container(),
                                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            selectedCategory = newValue;
                                          });
                                        }
                                      },
                                      selectedItemBuilder: (BuildContext context) {
                                        return categories.map<Widget>((String value) {
                                          return Align(
                                            child: Text(
                                              'Kategorie: $value',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(fontSize: 13),
                                            ),
                                          );
                                        }).toList();
                                      },
                                      items: categories.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: Text(value, textAlign: TextAlign.center),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Sort Dropdown
                                // Sortier-Dropdown
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: theme.colorScheme.outline.withOpacity(0.2),
                                      ),
                                    ),
                                    child: DropdownButton<String>(
                                      value: selectedSort,
                                      isExpanded: true,
                                      icon: const Icon(Icons.arrow_drop_down, size: 20),
                                      underline: Container(),
                                      style: theme.textTheme.bodyMedium,
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            selectedSort = newValue;
                                          });
                                        }
                                      },
                                      selectedItemBuilder: (BuildContext context) {
                                        return sortOptions.map<Widget>((String value) {
                                          return Center(
                                            child: Text(
                                              value,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          );
                                        }).toList();
                                      },
                                      items: sortOptions.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: Text(value, textAlign: TextAlign.center),
                                          ),
                                        );
                                      }).toList(),
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
            const SizedBox(height: 12),
            // Main deals list with error handling
            // Hauptliste der Angebote mit Fehlerbehandlung
            Expanded(
              child: _buildMainContent(theme),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the main content based on current state
  // Baut den Hauptinhalt basierend auf dem aktuellen Zustand auf
  Widget _buildMainContent(ThemeData theme) {
    final visibleDealsCount = deals.where((deal) {
      final hasNoPrices = deal['oldPrice'] == null || deal['newPrice'] == null;
      final hasNoDiscount = deal['discount'] == null;
      final hasNoQrCodes = (deal['qrCode'] == null || deal['qrCode'].trim().isEmpty) &&
          (deal['hiddenQrCode'] == null || deal['hiddenQrCode'].trim().isEmpty);
      return !(hasNoPrices && hasNoDiscount || hasNoQrCodes);
    }).length;

    // Show loading state
    // Ladezustand anzeigen
    if (_isLoading && sortedDeals.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      );
    }
    // Check if there's a network error or if sortedDeals is empty due to error
    // Überprüfen, ob ein Netzwerkfehler vorliegt oder ob sortedDeals aufgrund eines Fehlers leer ist
    if (_hasNetworkError ||
        (!_isLoading && sortedDeals.isEmpty && _lastError != null) ||
        (!_isLoading && sortedDeals.isEmpty && !_hasInitialLoad)) {
      return _buildErrorState(theme);
    }

    if (!_isLoading &&
        _hasInitialLoad &&
        (deals.isEmpty || visibleDealsCount == 0) &&
        _lastError == null &&
        !_hasNetworkError) {
      return _buildNoCouponsState(theme);
    }

    if (!_isLoading &&
        _hasInitialLoad &&
        deals.isNotEmpty &&
        sortedDeals.isEmpty &&
        _lastError == null &&
        !_hasNetworkError) {
      return _buildNoResultsState(theme);
    }

    // Show normal content
    // Normalen Inhalt anzeigen
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (_scrollController.offset > 100) {
          setState(() {
            _showFab = true;
            _lastScrollTime = DateTime.now();
          });

          // Hide after 1.5 seconds of inactivity
          // Nach 1,5 Sekunden Inaktivität ausblenden
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (_lastScrollTime != null &&
                DateTime.now().difference(_lastScrollTime!) >= const Duration(milliseconds: 1500) &&
                mounted) {
              setState(() => _showFab = false);
            }
          });
        } else {
          setState(() => _showFab = false);
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: sortedDeals.length,
          itemBuilder: (context, index) {
            final deal = sortedDeals[index];
            return _buildDealCard(context, deal);
          },
        ),
      ),
    );
  }

  // Builds error state widget
  // Baut den Fehlerzustands-Widget auf
  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Keine Internetverbindung',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Bitte Verbindung prüfen und erneut versuchen',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              textStyle: theme.textTheme.labelMedium,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              setState(() {
                _hasNetworkError = false;
                _lastError = null;
              });
              _refreshData();
            },
            child: const Text('Erneut versuchen'),
          ),
        ],
      ),
    );
  }

// Builds empty state widget when no coupons are available
  // Baut den leeren Zustands-Widget auf, wenn keine Coupons verfügbar sind
  Widget _buildNoCouponsState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Noch keine Coupons verfügbar',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Später wieder vorbeischauen für neue Angebote!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              textStyle: theme.textTheme.labelMedium,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _refreshData,
            child: const Text('Aktualisieren'),
          ),
        ],
      ),
    );
  }

  // Builds no results state widget when filters return empty
  // Baut den "Keine Ergebnisse"-Widget auf, wenn Filter leer zurückgeben
  Widget _buildNoResultsState(ThemeData theme) {
    String message;
    String subtitle;

    // Determine the appropriate message based on current filters
    // Passende Nachricht basierend auf aktuellen Filtern bestimmen
    if (searchWord.isNotEmpty && selectedCategory != 'Alle') {
      message = 'Keine Ergebnisse gefunden';
      subtitle = 'Keine Coupons für "$searchWord" in Kategorie "$selectedCategory"';
    } else if (searchWord.isNotEmpty) {
      message = 'Keine Ergebnisse gefunden';
      subtitle = 'Keine Coupons für "$searchWord" gefunden';
    } else if (selectedCategory == 'Favorite') {
      message = 'Keine Favoriten';
      subtitle = 'Keine Coupons als Favorit markiert';
    } else {
      message = 'Keine Coupons';
      subtitle = 'Diese Kategorie ist leer ';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            searchWord.isNotEmpty
                ? Icons.search_off
                : selectedCategory == 'Favorite'
                    ? Icons.favorite_border
                    : Icons.filter_list_off,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Show different action buttons based on the situation
          // Unterschiedliche Aktionsbuttons basierend auf der Situation anzeigen
          if (searchWord.isNotEmpty || selectedCategory != 'Alle') ...[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                textStyle: theme.textTheme.labelMedium,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                setState(() {
                  searchWord = '';
                  selectedCategory = 'Alle';
                  showSearchBar = false;
                });
              },
              child: const Text('Filter zurücksetzen'),
            ),
            const SizedBox(height: 12),
          ],
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              textStyle: theme.textTheme.labelMedium,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _refreshData,
            child: const Text('Aktualisieren'),
          ),
        ],
      ),
    );
  }

// Builds individual deal card widget
  // Baut den Widget für einzelne Angebotskarten auf
  Widget _buildDealCard(BuildContext context, Map<String, dynamic> deal) {
    final theme = Provider.of<ThemesNotifier>(context).currentThemeData;
    final backend = sl<BackendRepository>();
    final couponUserBackend = sl<CouponUserBackendRepository>();
    final title = deal['title'];

    final int voteCount = deal['voteCount'] ?? 0;
    final discount = deal['discount'];
    final oldPrice = deal['oldPrice'];
    final newPrice = deal['newPrice'];
    final expiresAt = deal['expiresAt'];
    final availableCoupons = deal['availableCoupons'];
    final couponId = deal[r'$id'];
    final List<String>? images = deal['images'];
    final mainImage = images != null && images.isNotEmpty ? images[0] : null;

    final isFavorite = userData['favorites']?.contains(couponId) ?? false;
    final isLiked = userData['likes']?.contains(couponId) ?? false;
    final isDisliked = userData['dislikes']?.contains(couponId) ?? false;

    final hasNoPrices = deal['oldPrice'] == null || deal['newPrice'] == null;
    final hasNoDiscount = deal['discount'] == null;
    final hasNoQrCodes = (deal['qrCode'] == null || deal['qrCode'].trim().isEmpty) &&
        (deal['hiddenQrCode'] == null || deal['hiddenQrCode'].trim().isEmpty);

    // Hide if: (no prices AND no discount)
    // Ausblenden wenn: (keine Preise UND kein Rabatt)
    if (hasNoPrices && hasNoDiscount || hasNoQrCodes) {
      return const SizedBox.shrink();
    }

    // build voting buttons
    // Abstimmungsbuttons Erstellen
    Widget buildVotingButtons() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.55),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Upvote button with fire animation
            // Upvote-Button mit Feuer-Animation
            Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    // Upvote logic here
                    // Upvote-Logik hier
                    final newLikes = List<String>.from(userData['likes'] ?? []);
                    final newDislikes = List<String>.from(userData['dislikes'] ?? []);
                    int newVoteCount = voteCount;
                    bool willAnimate = false;

                    if (isLiked) {
                      newLikes.remove(couponId);
                      newVoteCount--;
                    } else {
                      newLikes.add(couponId);
                      newVoteCount++;
                      willAnimate = true;

                      if (isDisliked) {
                        newDislikes.remove(couponId);
                        newVoteCount++;
                      }
                    }

                    try {
                      await backend.updateCoupon(
                        couponId: couponId,
                        updatedFields: {
                          'voteCount': newVoteCount,
                        },
                      );

                      await couponUserBackend.updateUserCoupons(
                        updatedFields: {
                          'likedCoupons': newLikes,
                          'dislikedCoupons': newDislikes,
                        },
                      );

                      if (mounted) {
                        setState(() {
                          userData['likes'] = newLikes;
                          userData['dislikes'] = newDislikes;
                          deal['voteCount'] = newVoteCount;
                          fireAnimations[couponId] = willAnimate;
                        });
                      }

                      if (willAnimate) {
                        await Future.delayed(const Duration(milliseconds: 700));
                        if (mounted) {
                          setState(() {
                            fireAnimations[couponId] = false;
                          });
                        }
                      }
                    } catch (e) {
                      print('Fehler beim Update: $e');
                      if (mounted) {
                        setState(() {
                          fireAnimations[couponId] = false;
                        });

                        if (!_isShowingError) {
                          _isShowingError = true;
                          showErrorSnackbar(context, 'Verbindungsfehler. Bitte erneut versuchen.');

                          Future.delayed(const Duration(seconds: 3), () {
                            _isShowingError = false;
                          });
                        }
                      }
                    }
                  },
                  child: Icon(
                    Icons.arrow_upward,
                    size: 30,
                    color: isLiked ? Colors.red : Colors.white,
                  ),
                ),
                if (fireAnimations[couponId] == true)
                  Lottie.asset(
                    'assets/animations/fire-effect.json',
                    width: 30,
                    height: 30,
                    repeat: false,
                    fit: BoxFit.contain,
                  ),
              ],
            ),
            const SizedBox(width: 6),
            // Vote count
            // Stimmenzähler
            Stack(
              alignment: Alignment.center,
              children: [
                // Fire effect (only shows when votes >= 50)
                // Feuer-Effekt (nur sichtbar bei ≥50 Stimmen)
                if (voteCount >= 50)
                  Opacity(
                    opacity: (voteCount / 200).clamp(0.35, 0.8),
                    child: Transform.scale(
                      scale: 1 + (voteCount * 0.003).clamp(0.0, 0.5),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          _getFireColor(voteCount),
                          BlendMode.srcATop,
                        ),
                        child: Lottie.asset(
                          'assets/animations/fire-effect.json',
                          width: 30,
                          height: 30,
                          repeat: true,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    voteCount.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: voteCount >= 50
                          ? const Color.fromARGB(255, 255, 175, 1)
                          : voteCount > 0
                              ? Colors.red
                              : voteCount < 0
                                  ? Colors.blue
                                  : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            // Downvote button with snow animation
            // Downvote-Button mit Schnee-Animation
            Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    // Downvote logic here
                    // Downvote-Logik hier
                    final newLikes = List<String>.from(userData['likes'] ?? []);
                    final newDislikes = List<String>.from(userData['dislikes'] ?? []);
                    int newVoteCount = voteCount;
                    bool willAnimate = false;

                    if (isDisliked) {
                      newDislikes.remove(couponId);
                      newVoteCount++;
                    } else {
                      newDislikes.add(couponId);
                      newVoteCount--;
                      willAnimate = true;

                      if (isLiked) {
                        newLikes.remove(couponId);
                        newVoteCount--;
                      }
                    }

                    try {
                      await backend.updateCoupon(
                        couponId: couponId,
                        updatedFields: {
                          'voteCount': newVoteCount,
                        },
                      );

                      await couponUserBackend.updateUserCoupons(
                        updatedFields: {
                          'likedCoupons': newLikes,
                          'dislikedCoupons': newDislikes,
                        },
                      );

                      if (mounted) {
                        setState(() {
                          userData['likes'] = newLikes;
                          userData['dislikes'] = newDislikes;
                          deal['voteCount'] = newVoteCount;
                          snowAnimations[couponId] = willAnimate;
                        });
                      }

                      if (willAnimate) {
                        await Future.delayed(const Duration(milliseconds: 700));
                        if (mounted) {
                          setState(() {
                            snowAnimations[couponId] = false;
                          });
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        setState(() {
                          snowAnimations[couponId] = false;
                        });

                        if (!_isShowingError) {
                          _isShowingError = true;
                          showErrorSnackbar(context, 'Verbindungsfehler. Bitte erneut versuchen.');

                          Future.delayed(const Duration(seconds: 3), () {
                            _isShowingError = false;
                          });
                        }
                      }
                    }
                  },
                  child: Icon(
                    Icons.arrow_downward,
                    size: 30,
                    color: isDisliked ? Colors.blue : Colors.white,
                  ),
                ),
                if (snowAnimations[couponId] == true)
                  Positioned(
                    child: Lottie.asset(
                      'assets/animations/snow-effect.json',
                      width: 30,
                      height: 30,
                      repeat: false,
                      fit: BoxFit.contain,
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    }

    // Helper method to build favorite and share buttons
    // Hilfsmethode zum Erstellen der Favoriten- und Teilen-Buttons
    Widget buildActionButtons() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Favorite button with heart animation
          // Favoriten-Button mit Herz-Animation
          Container(
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: IconButton(
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  if (heartAnimations[couponId] == true)
                    Positioned(
                      child: Transform.scale(
                        scale: 2.5,
                        child: Lottie.asset(
                          'assets/animations/heart-effect.json',
                          width: 50,
                          height: 50,
                          repeat: false,
                          fit: BoxFit.contain,
                          frameRate: const FrameRate(120),
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () async {
                final newFavorites = List<String>.from(userData['favorites'] ?? []);
                bool willAnimate = false;

                if (isFavorite) {
                  newFavorites.remove(couponId);
                } else {
                  newFavorites.add(couponId);
                  willAnimate = true;
                }

                try {
                  await couponUserBackend.updateUserCoupons(
                    updatedFields: {
                      'favoriteCoupons': newFavorites,
                    },
                  );

                  if (mounted) {
                    setState(() {
                      userData['favorites'] = newFavorites;
                      heartAnimations[couponId] = willAnimate;
                    });
                  }
                  if (willAnimate) {
                    await Future.delayed(const Duration(milliseconds: 1000));
                    if (mounted) {
                      setState(() {
                        heartAnimations[couponId] = false;
                      });
                    }
                  }
                } catch (e) {
                  if (mounted) {
                    setState(() {
                      heartAnimations[couponId] = false;
                    });

                    if (!_isShowingError) {
                      _isShowingError = true;
                      showErrorSnackbar(context, 'Verbindungsfehler. Bitte erneut versuchen.');

                      Future.delayed(const Duration(seconds: 3), () {
                        _isShowingError = false;
                      });
                    }
                  }
                }
              },
            ),
          ),
          const SizedBox(width: 4),
          // Share button
          // Teilen-Button
          Container(
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              padding: const EdgeInsets.all(8),
              onPressed: () {
                if (deal['website'] != null || deal['location'] != null) {
                  shareLink(deal);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kein Link zum Teilen verfügbar.'),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Card(
        surfaceTintColor: theme.colorScheme.tertiaryContainer.withOpacity(0.1),
        margin: const EdgeInsets.only(bottom: 8),
        shadowColor: Colors.black.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CouponDetailPage(deal: deal),
              ),
            );
          },
          splashColor: theme.colorScheme.primary.withOpacity(0.2),
          highlightColor: Colors.transparent,
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (mainImage?.isNotEmpty ?? false)
                  // Image section with interactive buttons
                  // Bildbereich mit interaktiven Buttons
                  Stack(
                    children: [
                      // Main deal image
                      // Hauptbild des Angebots
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          child: Image.network(
                            mainImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) => Container(),
                          ),
                        ),
                      ),
                      // Voting buttons container (top-left)
                      // Abstimmungsbuttons (oben links)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: buildVotingButtons(),
                      ),
                      // Favorite and share buttons (top-right)
                      // Favoriten- und Teilen-Buttons (oben rechts)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: buildActionButtons(),
                      ),
                    ],
                  ),

                // If no image, show buttons above title
                // Wenn kein Bild vorhanden, Buttons über dem Titel anzeigen
                if (mainImage?.isEmpty ?? true)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildVotingButtons(),
                        buildActionButtons(),
                      ],
                    ),
                  ),

                // Deal title
                // Angebotstitel
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    deal['description'] ?? 'Keine Details Verfügbar',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Price and expiration info
                // Preis- und Ablaufinformationen
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price information
                      // Preisinformation
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              if (oldPrice != null && newPrice != null) ...[
                                // Original price
                                // Originalpreis
                                Text(
                                  '$oldPrice€',
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                // Discounted price
                                // Reduzierter Preis
                                Padding(
                                  padding: EdgeInsets.zero,
                                  child: Text(
                                    '$newPrice€',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                      shadows: [
                                        Shadow(
                                          color: theme.colorScheme.primary.withOpacity(0.1),
                                          blurRadius: 1,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                              ],
                              // display Discount %
                              // Rabatt % anzeigen
                              if (oldPrice != null && newPrice != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.shade100.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    newPrice == 0
                                        ? 'Free 🎉'
                                        : '${newPrice > oldPrice ? '+' : '-'}${((oldPrice - newPrice).abs() / oldPrice * 100).round()}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                )
                              else if (discount != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.shade100.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    discount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (availableCoupons != null && availableCoupons <= 0)
                            Builder(
                              builder: (context) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  backend.deleteCoupon(couponId: deal[r'$id']);
                                });
                                return const SizedBox.shrink();
                              },
                            ),
                          if (expiresAt != null)
                            Builder(
                              builder: (context) {
                                final expiryDate = DateTime.parse(expiresAt).toLocal();
                                final now = DateTime.now();
                                if (expiryDate.isBefore(now)) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    backend.deleteCoupon(couponId: deal[r'$id']);
                                  });
                                  return const SizedBox.shrink();
                                } else {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.access_time, size: 16, color: Colors.deepOrange),
                                      const SizedBox(width: 4),
                                      Text(
                                        'End: ${DateFormat.yMMMd().add_jm().format(expiryDate)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
