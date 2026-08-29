import 'package:cloud_firestore/cloud_firestore.dart';

class StoreProfile {
  final String uid;
  final String storeName;
  final String ownerName;
  final String phone;
  final String email;
  final String address;
  final double latitude;
  final double longitude;
  final int totalFertilizers;
  final int totalStock;
  final int totalViews;
  final double rating;
  final int totalReviews;
  final bool isVerified;
  final String? profileImageUrl;
  final DateTime? updatedAt;

  StoreProfile({
    required this.uid,
    required this.storeName,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.totalFertilizers = 0,
    this.totalStock = 0,
    this.totalViews = 0,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.isVerified = false,
    this.profileImageUrl,
    this.updatedAt,
  });

  factory StoreProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StoreProfile(
      uid: doc.id,
      storeName: data['storeName']?.toString() ?? '',
      ownerName: data['ownerName']?.toString() ?? '',
      phone: data['phone']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      totalFertilizers: data['totalFertilizers'] ?? 0,
      totalStock: data['totalStock'] ?? 0,
      totalViews: data['totalViews'] ?? 0,
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalReviews: data['totalReviews'] ?? data['total_reviews'] ?? 0,
      isVerified: data['isVerified'] ?? false,
      profileImageUrl: data['profileImageUrl']?.toString(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'storeName': storeName,
      'ownerName': ownerName,
      'phone': phone,
      'email': email,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'totalFertilizers': totalFertilizers,
      'totalStock': totalStock,
      'totalViews': totalViews,
      'rating': rating,
      'totalReviews': totalReviews,
      'isVerified': isVerified,
      'profileImageUrl': profileImageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  String get coordinates =>
      '${latitude.toStringAsFixed(4)}° N, ${longitude.toStringAsFixed(4)}° E';

  String get formattedRating => rating.toStringAsFixed(1);

  String get formattedReviews =>
      totalReviews > 0 ? '($totalReviews+ reviews)' : '(No reviews)';

  String get formattedStock => totalStock >= 1000
      ? '${(totalStock / 1000).toStringAsFixed(1)}k'
      : totalStock.toString();

  String get formattedViews => totalViews >= 1000
      ? '${(totalViews / 1000).toStringAsFixed(1)}k'
      : totalViews.toString();
}
