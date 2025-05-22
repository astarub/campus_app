// ignore_for_file: deprecated_member_use, avoid_dynamic_calls

import 'dart:io' show Platform;
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

final GetIt sl = GetIt.instance;

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
  bool _isLoading = false;
  Map<String, bool> fireAnimations = {};
  Map<String, bool> snowAnimations = {};
  Map<String, bool> heartAnimations = {};
  bool _isShowingError = false;

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

  Map<String, dynamic> userData = {};

  List<Map<String, dynamic>> deals = [
    {
      // nur als test falls backend nicht funktioniert
      'title': 'Handy Rabatt',
      'oldPrice': 555.40,
      'newPrice': 499.00,
      'discount': '10%',
      'mainImage': 'assets/img/iphone_coupon.jpg',
      'category': 'Technik',
      'source': 'Markt',
      'url': 'https://example.com/deal1',
      'qrCodeData':
          'https://example.com/deal1WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW',
      'maxUses': 3,
      'usedCount': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadDealsFromAppwrite();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!_isLoading) {
        _refreshData();
      }
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadDealsFromAppwrite();
    setState(() {
      _isLoading = false;
    });
  }

  void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _loadDealsFromAppwrite() async {
    final backend = sl<BackendRepository>();
    final couponUserBackend = sl<CouponUserBackendRepository>();
    final coupons = await backend.getCoupons();
    final couponUser = await couponUserBackend.getUserCoupons('6822fb140013c217724f');

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

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported, size: 40),
    );
  }

  Color _getFireColor(int votes) {
    final intensity = (votes / 100).clamp(0.3, 1.0);
    return Color.lerp(
      Colors.orange.withOpacity(0.7),
      Colors.redAccent,
      intensity,
    )!;
  }

  Future<void> shareLink(Map<String, dynamic> deal) async {
    final String link = deal['website'] ?? deal['location'] ?? 'Check out this great deal from Campus App!';

    try {
      await Share.share(link);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not share: $e')),
      );
    }
  }

  List<Map<String, dynamic>> get sortedDeals {
    final filtered = filteredDeals;

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

    final dealsWithDiscount = filtered
        .where((deal) => deal['discount'] != null || (deal['oldPrice'] != null && deal['newPrice'] != null))
        .toList();
    final dealsWithoutDiscount = filtered
        .where((deal) => deal['discount'] == null && (deal['oldPrice'] == null || deal['newPrice'] == null))
        .toList();

    switch (selectedSort) {
      case 'Höchster Rabatt':
        dealsWithDiscount.sort((a, b) {
          final discountA = a['discount'] != null
              ? parseDiscountValue(a['discount'])
              : ((a['oldPrice'] - a['newPrice']) / a['oldPrice'] * 100);
          final discountB = b['discount'] != null
              ? parseDiscountValue(b['discount'])
              : ((b['oldPrice'] - b['newPrice']) / b['oldPrice'] * 100);

          return discountB.compareTo(discountA);
        });
        // Combine with deals without discount sorted by upvotes
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
          return dateB.compareTo(dateA); // Newest first
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

  void onSearch(String query) {
    setState(() {
      searchWord = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header section with back button and title (Kopfzeile mit Zurück-Button und Titel)
            Padding(
              padding: EdgeInsets.only(
                top: Platform.isAndroid ? 10 : 0,
                bottom: 10,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    // Back button (Zurück-Button)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CampusIconButton(
                        iconPath: 'assets/img/icons/arrow-left.svg',
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    // Centered title (Zentrierter Titel)
                    Align(
                      child: Text(
                        'Coupons & Rabatte',
                        style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Search bar / Filter row (Suchleiste/Filter-Zeile)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: showSearchBar
                  // Search field when active (Aktive Suchleiste)
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
                                    color: Provider.of<ThemesNotifier>(context)
                                        .currentThemeData
                                        .dividerColor
                                        .withOpacity(0.5),
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
                  // Filter buttons when search inactive (Filter-Buttons wenn Suche inaktiv)
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          // Search toggle button (Such-Button)
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
                          // Combined filter dropdowns (Kombinierte Filter-Dropdowns)
                          Expanded(
                            child: Row(
                              children: [
                                // Category filter (Kategorie-Filter)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Provider.of<ThemesNotifier>(context)
                                          .currentThemeData
                                          .colorScheme
                                          .surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Provider.of<ThemesNotifier>(context)
                                            .currentThemeData
                                            .colorScheme
                                            .outline
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                    child: DropdownButton<String>(
                                      value: selectedCategory,
                                      isExpanded: true,
                                      icon: const Icon(Icons.arrow_drop_down, size: 20),
                                      underline: Container(),
                                      style: Provider.of<ThemesNotifier>(context)
                                          .currentThemeData
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(height: 1.5),
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
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Provider.of<ThemesNotifier>(context)
                                          .currentThemeData
                                          .colorScheme
                                          .surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Provider.of<ThemesNotifier>(context)
                                            .currentThemeData
                                            .colorScheme
                                            .outline
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                    child: DropdownButton<String>(
                                      value: selectedSort,
                                      isExpanded: true,
                                      icon: const Icon(Icons.arrow_drop_down, size: 20),
                                      underline: Container(),
                                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
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
            // Main deals list (Hauptliste der Angebote)
            Expanded(
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
            ),
          ],
        ),
      ),
    );
  }

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
    final couponId = deal[r'$id'];
    final List<String>? images = deal['images'];
    final mainImage = images != null && images.isNotEmpty ? images[0] : null;

    final isFavorite = userData['favorites']?.contains(couponId) ?? false;
    final isLiked = userData['likes']?.contains(couponId) ?? false;
    final isDisliked = userData['dislikes']?.contains(couponId) ?? false;

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
          // Handles tap on entire card
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
                // Image section with interactive buttons
                Stack(
                  children: [
                    // Main deal image
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        child: mainImage?.isNotEmpty ?? false
                            ? Image.network(
                                mainImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                              )
                            : _buildImagePlaceholder(),
                      ),
                    ),
                    // Voting buttons container (top-left)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            // Upvote button with fire animation
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    // Upvote logic here
                                    // - Handles adding/removing likes
                                    // - Shows fire animation when adding
                                    // - Updates backend
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
                                        userId: '6822fb140013c217724f',
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

                                      // Reset animation after it plays
                                      if (willAnimate) {
                                        await Future.delayed(const Duration(milliseconds: 1000));
                                        if (mounted) {
                                          setState(() {
                                            fireAnimations[couponId] = false;
                                          });
                                        }
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        setState(() {
                                          fireAnimations[couponId] = false;
                                        });

                                        if (!_isShowingError) {
                                          _isShowingError = true;
                                          // ignore: use_build_context_synchronously
                                          showErrorSnackbar(context, 'Network error. Please try again.');

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
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Fire effect (only shows when votes > 50)
                                if (voteCount > 50)
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
                                          'assets/animations/fire-effect2.json',
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
                                      color: voteCount > 0
                                          ? const Color.fromARGB(255, 255, 103, 1)
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
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    // Downvote logic here
                                    // - Handles adding/removing dislikes
                                    // - Shows snow animation when adding
                                    // - Updates backend
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
                                        userId: '6822fb140013c217724f',
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

                                      // Reset animation after it plays
                                      if (willAnimate) {
                                        await Future.delayed(const Duration(milliseconds: 1000));
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
                                          // ignore: use_build_context_synchronously
                                          showErrorSnackbar(context, 'Network error. Please try again.');

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
                      ),
                    ),
                    // Favorite and share buttons (top-right)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Column(
                        children: [
                          // Favorite button with heart animation
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
                                      child: Lottie.asset(
                                        'assets/animations/heart-effect.json',
                                        width: 50,
                                        height: 50,
                                        repeat: false,
                                        fit: BoxFit.contain,
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

                                // Update backend
                                try {
                                  await couponUserBackend.updateUserCoupons(
                                    userId: '6822fb140013c217724f',
                                    updatedFields: {
                                      'favoriteCoupons': newFavorites,
                                    },
                                  );

                                  // Update UI state
                                  if (mounted) {
                                    setState(() {
                                      userData['favorites'] = newFavorites;
                                      heartAnimations[couponId] = willAnimate;
                                    });
                                  }
                                  if (willAnimate) {
                                    // Hide animation after it plays
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
                                      // ignore: use_build_context_synchronously
                                      showErrorSnackbar(context, 'Network error. Please try again.');

                                      Future.delayed(const Duration(seconds: 3), () {
                                        _isShowingError = false;
                                      });
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Share button
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
                                    const SnackBar(content: Text('No link available to share')),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Deal title
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price information
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              if (oldPrice != null && newPrice != null) ...[
                                // Original price
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
                              if (oldPrice != null && newPrice != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.shade100.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${newPrice > oldPrice ? '+' : '-'}${((oldPrice - newPrice).abs() / oldPrice * 100).round()}%',
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
                                )
                              else
                                const Text(
                                  'Kein Preis verfügbar',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
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
                          if (expiresAt != null)
                            // Expiration date display
                            Builder(
                              builder: (context) {
                                final expiryDate = DateTime.parse(expiresAt).toLocal();
                                final now = DateTime.now();
                                // Auto-delete expired coupons
                                if (expiryDate.isBefore(now)) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    backend.deleteCoupon(couponId: deal[r'$id']);
                                  });
                                  return const SizedBox.shrink();
                                } else {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.access_time, size: 16, color: Colors.orangeAccent),
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
