import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/review.dart';

class ReviewService {
  final CollectionReference _reviewsRef =
      FirebaseFirestore.instance.collection('reviews');
  final CollectionReference _placesRef =
      FirebaseFirestore.instance.collection('services');

  Future<List<Review>> getReviews(String placeId) async {
    try {
      QuerySnapshot snapshot = await _reviewsRef
          .where('placeId', isEqualTo: placeId)
          .orderBy('date', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        return Review.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> addReview(Review review) async {
    try {
      // Add the review
      await _reviewsRef.add(review.toMap());

      // Update the average rating of the place
      await _updateAverageRating(review.placeId);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updateAverageRating(String placeId) async {
    try {
      // Fetch all reviews for the place
      QuerySnapshot snapshot =
          await _reviewsRef.where('placeId', isEqualTo: placeId).get();

      if (snapshot.docs.isNotEmpty) {
        double totalRating = 0.0;
        int count = snapshot.docs.length;

        for (var doc in snapshot.docs) {
          totalRating += (doc.data() as Map<String, dynamic>)['rating'];
        }

        double averageRating = totalRating / count;

        // Update the place's average rating and total rates
        await _placesRef.doc(placeId).update({
          'averageRating': averageRating,
          'totalRates': count,
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
