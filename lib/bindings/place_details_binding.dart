// lib/bindings/place_details_binding.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../controllers/review_controller.dart';
import '../controllers/favorite_controller.dart';

class PlaceDetailsBinding extends Bindings {
  @override
  void dependencies() {
    String placeId = Get.arguments.id;
    Get.lazyPut<ReviewController>(() => ReviewController(placeId));
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Get.lazyPut<FavoriteController>(() => FavoriteController(userId));
  }
}
