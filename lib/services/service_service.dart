import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/service_model.dart';
import 'package:path/path.dart' as path;

class PlaceService {
  final CollectionReference _placesRef =
      FirebaseFirestore.instance.collection('services');
  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: "car-shop-2a53b.appspot.com");

  Future<List<Service>> getPlaces() async {
    try {
      QuerySnapshot snapshot = await _placesRef.get();
      return snapshot.docs.map((doc) {
        return Service.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Service>> getMyPlaces() async {
    try {
      QuerySnapshot snapshot = await _placesRef
          .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      return snapshot.docs.map((doc) {
        return Service.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Service>> getPlacesByCategory(String categoryId) async {
    try {
      QuerySnapshot snapshot =
          await _placesRef.where('category.id', isEqualTo: categoryId).get();
      return snapshot.docs.map((doc) {
        return Service.fromMap(doc.data() as Map<String, dynamic>, doc.id);
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

  Future<String> uploadImage(File imageFile) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final Reference storageRef = _storage.ref().child('places/$fileName');

      final UploadTask uploadTask = storageRef.putFile(imageFile);
      final TaskSnapshot taskSnapshot = await uploadTask;

      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> updateService(
      String serviceId, Map<String, dynamic> updates) async {
    try {
      print(serviceId);
      print(updates);
      await _placesRef.doc(serviceId).update(updates);
      print('Service updated successfully');
    } catch (e) {
      print('Error updating service: $e');
      rethrow;
    }
  }

  List<Service> _convertToServices(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Service.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> deleteService(String serviceId) async {
    try {
      await _placesRef.doc(serviceId).delete();
      print('Service deleted successfully');
    } catch (e) {
      print('Error deleting service: $e');
      rethrow;
    }
  }
}
