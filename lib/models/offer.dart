// lib/models/offer.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  final String id;
  final String title;
  final String description;
  final double originalPrice;
  final double discountedPrice;
  final DateTime startDate;
  final DateTime endDate;
  final int placeId;
  final bool isSpecial;

  Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.startDate,
    required this.endDate,
    required this.placeId,
    this.isSpecial = false,
  });

  factory Offer.fromMap(Map<String, dynamic> map) {
    return Offer(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      originalPrice: map['originalPrice'].toDouble(),
      discountedPrice: map['discountedPrice'].toDouble(),
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      placeId: map['placeId'],
      isSpecial: map['isSpecial'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'startDate': startDate,
      'endDate': endDate,
      'placeId': placeId,
      'isSpecial': isSpecial,
    };
  }
}
