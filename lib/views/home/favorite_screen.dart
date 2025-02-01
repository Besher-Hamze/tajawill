import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajawil/views/home/widgets/place_card.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/service_controller.dart';
import '../../models/service_model.dart';
import '../../utils/app_colors.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final PlaceController placeController = Get.find();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch favorite places when the screen loads
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    await placeController.getFavoritePlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child:  RefreshIndicator(
        onRefresh: fetchFavorites,
        child: Column(
          children: [
            // Search Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث عن خدمة...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim();
                  });
                },
              ),
            ),

            // List of Favorite Places
            Expanded(
              child: Obx(() {
                if (placeController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                final filteredPlaces = placeController.favoritePlaces
                    .where((place) =>
                place.name.contains(searchQuery) ||
                    place.description.contains(searchQuery))
                    .toList();

                if (filteredPlaces.isEmpty) {
                  return Center(child: Text('لا توجد أماكن مفضلة.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredPlaces.length,
                  itemBuilder: (context, index) {
                    final Service place = filteredPlaces[index];
                    return PlaceCard(place: place, index: index,);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
