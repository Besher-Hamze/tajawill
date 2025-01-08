import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/service_model.dart';
import '../services/service_service.dart';
import '../services/favorite_service.dart';

class PlaceController extends GetxController {
  var places = <Service>[].obs;
  var isLoading = true.obs;
  var selectedCategoryId = "".obs;
  var favoritePlaces = <Service>[].obs; // List for favorite places

  final PlaceService _placeService = PlaceService();
  final FavoriteService _favoriteService = FavoriteService();

  @override
  void onInit() {
    fetchPlaces();
    getFavoritePlaces();
    super.onInit();
  }

  void fetchPlaces() async {
    try {
      isLoading(true);
      var fetchedPlaces = await _placeService.getPlaces();
      if (fetchedPlaces.isNotEmpty) {
        places.assignAll(fetchedPlaces);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> filterByCategory(String categoryId) async {
    selectedCategoryId(categoryId);
    try {
      isLoading(true);
      var fetchedPlaces = await _placeService.getPlacesByCategory(categoryId);
      if (fetchedPlaces.isNotEmpty) {
        places.assignAll(fetchedPlaces);
      } else {
        places.clear();
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> getFavoritePlaces() async {
    try {
      isLoading(true);
      List<String> favoritePlaceIds = await _favoriteService
          .getUserFavorites(FirebaseAuth.instance.currentUser!.uid);

      if (favoritePlaceIds.isNotEmpty) {
        var fetchedPlaces =
            await _placeService.getPlacesByIds(favoritePlaceIds);
        favoritePlaces.assignAll(fetchedPlaces);
      } else {
        favoritePlaces.clear();
      }
    } finally {
      isLoading(false);
    }
  }
}
