// lib/controllers/favorite_controller.dart
import 'package:get/get.dart';
import '../services/favorite_service.dart';

class FavoriteController extends GetxController {
  var favoritePlaceIds = <String>[].obs;
  final FavoriteService _favoriteService = FavoriteService();
  final String userId;

  FavoriteController(this.userId);

  @override
  void onInit() {
    fetchFavorites();
    fetchFavorites();
    super.onInit();
  }

  void fetchFavorites() async {
    var favorites = await _favoriteService.getUserFavorites(userId);
    favoritePlaceIds.assignAll(favorites);
  }

  Future<void> toggleFavorite(String placeId) async {
    if (favoritePlaceIds.contains(placeId)) {
      await _favoriteService.removeFavorite(userId, placeId);
      favoritePlaceIds.remove(placeId);
    } else {
      await _favoriteService.addFavorite(userId, placeId);
      favoritePlaceIds.add(placeId);
    }
  }

  bool isFavorite(String placeId) {
    return favoritePlaceIds.contains(placeId);
  }
}
