// lib/services/offer_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/offer.dart';

class OfferService {
  final CollectionReference _offersRef =
  FirebaseFirestore.instance.collection('offers');

  Future<List<Offer>> getOffersByPlace(String placeId) async {
    try {
      QuerySnapshot snapshot = await _offersRef
          .where('placeId', isEqualTo: placeId)
          .orderBy('endDate', descending: false)
          .get();
      return snapshot.docs.map((doc) {
        return Offer.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> addOffer(Offer offer) async {
    try {
      DocumentReference<Object?> offerDoc = _offersRef.doc();
      offer.id = offerDoc.id;
      await offerDoc.set(offer.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateOffer(Offer offer) async {
    try {
      await _offersRef.doc(offer.id).update(offer.toMap());
    } catch (e) {
      print(e);
    }
  }
  Future<void> deleteOffer(String id) async {
    try {
      await _offersRef.doc(id).delete();
    } catch (e) {
      print(e);
    }
  }
}
