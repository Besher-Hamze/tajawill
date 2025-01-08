// lib/services/place_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/service_model.dart';

class PlaceService {
  final CollectionReference _placesRef =
  FirebaseFirestore.instance.collection('services');

  Future<List<Service>> getPlaces() async {
    try {
      QuerySnapshot snapshot = await _placesRef.get();
      return snapshot.docs.map((doc) {
        return Service.fromMap(doc.data() as Map<String, dynamic>,doc.id);
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Service>> getPlacesByCategory(String categoryId) async {
    try {
      QuerySnapshot snapshot = await _placesRef
          .where('category.id', isEqualTo: categoryId)
          .get();
      return snapshot.docs.map((doc) {
        return Service.fromMap(doc.data() as Map<String, dynamic>,doc.id);
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
  Future<List<Service>> getPlacesByIds(List<String> placeIds) async {
    try {
      QuerySnapshot snapshot =
      await _placesRef.where(FieldPath.documentId, whereIn: placeIds).get();
      return snapshot.docs.map((doc) {
        return Service.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

}
