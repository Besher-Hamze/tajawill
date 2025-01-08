// lib/bindings/home_binding.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tajawil/controllers/favorite_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/service_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<PlaceController>(() => PlaceController());
    Get.lazyPut<FavoriteController>(() => FavoriteController(FirebaseAuth.instance.currentUser!.uid));
  }
}
