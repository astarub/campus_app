// ignore_for_file: avoid_dynamic_calls

class Coupon {
  final String id;
  final DateTime? createdAt;
  String title;
  String? description;
  double? oldPrice;
  double? newPrice;
  List<String>? images;
  final String provider;
  String? website;
  String? location;
  final String category;
  String qrCode;
  DateTime? expiresAt;
  String? discount;
  int? availableCoupons;
  int? voteCount;

  Coupon({
    required this.id,
    this.createdAt,
    required this.title,
    required this.description,
    this.oldPrice,
    this.newPrice,
    this.discount,
    this.images,
    required this.provider,
    this.website,
    this.location,
    required this.category,
    required this.qrCode,
    this.expiresAt,
    this.availableCoupons,
    this.voteCount,
  });

  factory Coupon.fromMap(Map<String, dynamic> map) {
    List<String>? processedImages;
    if (map['images'] != null) {
      processedImages = (map['images'] as List)
          .where((image) => image != null && image.toString().isNotEmpty)
          .map((image) => image.toString())
          .toList();
      processedImages = processedImages.isEmpty ? null : processedImages.toSet().toList();
    }

    return Coupon(
      id: map[r'$id'],
      createdAt: map[r'$createdAt'] != null ? DateTime.tryParse(map[r'$createdAt']) : null,
      title: (map['title'] == null || map['title'].isEmpty) ? 'Kein Titel' : map['title'],
      description:
          (map['description'] == null || map['description'].isEmpty) ? 'Keine Details vorhanden.' : map['description'],
      oldPrice: (map['oldPrice'] as num?)?.toDouble(),
      newPrice: (map['newPrice'] as num?)?.toDouble(),
      discount: map['discount'],
      images: processedImages,
      provider: (map['provider'] == null || map['provider'].isEmpty) ? 'Anbieter unbekannt' : map['provider'],
      website: map['website'],
      location: map['location'],
      category: map['category'],
      qrCode: map['qrCode'] ?? '',
      expiresAt: map['expiresAt'] != null ? DateTime.parse(map['expiresAt']) : null,
      availableCoupons: map['availableCoupons'],
      voteCount: map['voteCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'oldPrice': oldPrice,
      'newPrice': newPrice,
      'discount': discount,
      'images': images,
      'provider': provider,
      'website': website,
      'location': location,
      'category': category,
      'qrCode': qrCode,
      'expiresAt': expiresAt?.toIso8601String(),
      'availableCoupons': availableCoupons,
      'voteCount': voteCount,
    };
  }
}

/*{
      'title': 'Handy Rabatt',
      'oldPrice': 555.40,
      'newPrice': 499.00,
      'discount': '10%',
      'image': 'assets/img/iphone_coupon.jpg',
      'category': 'Technik',
      'source': 'Markt',
      'url': 'https://example.com/deal1',
      'qrCodeData': 'https://example.com/deal1', // Beispiel: URL, die in QR-Code kodiert wird
      'maxUses': 3,
      'usedCount': 0,
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
      'maxUses': 3,
      'usedCount': 0,
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
      'maxUses': 3,
      'usedCount': 0,
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
      'maxUses': 3,
      'usedCount': 0,
    },
    {
      'title': 'Test-Coupon: schon verbraucht',
      'source': 'Supermarkt',
      'maxUses': 2,
      'usedCount': 2,
    },
    {
      'title': 'Test-Coupon: nur 1x nutzbar',
      'source': 'Bäckerei XY',
      'maxUses': 1,
      'usedCount': 0,
    }  */
