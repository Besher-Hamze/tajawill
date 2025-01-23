import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/service_model.dart';
import '../services/service_service.dart';
import '../services/favorite_service.dart';

class PlaceController extends GetxController {
  var places = <Service>[].obs;
  var myPlaces = <Service>[].obs;
  var isLoading = true.obs;
  var isMyLoading = true.obs;
  var selectedCategoryId = "".obs;
  var favoritePlaces = <Service>[].obs; // List for favorite places

  final PlaceService _placeService = PlaceService();
  final FavoriteService _favoriteService = FavoriteService();

  @override
  void onInit() {
    fetchPlaces();
    fetchMyPlaces();
    getFavoritePlaces();
    super.onInit();
  }

  fetchPlaces() async {
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

  void fetchMyPlaces() async {
    try {
      isMyLoading(true);
      var fetchedPlaces = await _placeService.getMyPlaces();
      if (fetchedPlaces.isNotEmpty) {
        myPlaces.assignAll(fetchedPlaces);
      }
    } finally {
      isMyLoading(false);
    }
  }

  Future<void> filterByCategory(String? categoryId) async {
    selectedCategoryId(categoryId);

    try {
      isLoading(true);
      var fetchedPlaces;
      if (categoryId == "") {
        fetchedPlaces = await _placeService.getPlaces();
      } else {
        fetchedPlaces = await _placeService.getPlacesByCategory(categoryId!);
      }
      if (fetchedPlaces.isNotEmpty) {
        places.assignAll(fetchedPlaces);
      } else {
        places.clear();
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> filterByGov(String gov) async {
    try {
      isLoading(true);
      var fetchedPlaces = await _placeService.getPlacesByGov(gov);
      if (fetchedPlaces.isNotEmpty) {
        places.assignAll(fetchedPlaces);
      } else {
        places.clear();
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> search(String searchKey, String? gov, String? categoryId) async {
    try {
      isLoading(true);
      var fetchedPlaces = places
          .where((p0) =>
              p0.name.contains(searchKey) &&
              (gov != null ? p0.governorates == gov : true) &&
              (categoryId != null ? p0.category.id == categoryId : true))
          .toList();
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
