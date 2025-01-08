// lib/models/review.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String id;
  final String userId;
  final String userName;
  final String placeId;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.placeId,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      userId: map['userId'],
      userName: map['userName'],
      placeId: map['placeId'],
      rating: map['rating'].toDouble(),
      comment: map['comment'],
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'placeId': placeId,
      'rating': rating,
      'comment': comment,
      'date': date,
    };
  }
}
