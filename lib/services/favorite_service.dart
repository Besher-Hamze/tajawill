// lib/services/favorite_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteService {
  final CollectionReference _favoritesRef =
  FirebaseFirestore.instance.collection('favorites');

  Future<void> addFavorite(String userId, String placeId) async {
    try {
      await _favoritesRef.doc('${userId}_$placeId').set({
        'userId': userId,
        'placeId': placeId,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeFavorite(String userId, String placeId) async {
    try {
      await _favoritesRef.doc('${userId}_$placeId').delete();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isFavorite(String userId, String placeId) async {
    try {
      DocumentSnapshot doc = await _favoritesRef.doc('${userId}_$placeId').get();
      return doc.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<String>> getUserFavorites(String userId) async {
    try {
      QuerySnapshot snapshot =
      await _favoritesRef.where('userId', isEqualTo: userId).get();
      return snapshot.docs.map((doc) => doc['placeId'] as String).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
