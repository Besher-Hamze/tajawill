import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajawil/views/home/widgets/category_card.dart';
import 'package:tajawil/views/home/widgets/place_card.dart';

import '../../controllers/category_controller.dart';
import '../../controllers/service_controller.dart';
import '../../models/service_model.dart';
import '../../utils/app_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.find();
    final PlaceController placeController = Get.find();

    return Column(
      children: [
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {},
          ),
        ),
        Container(
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Obx(() {
            if (categoryController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categoryController.categories.length,
              itemBuilder: (context, index) {
                final category = categoryController.categories[index];
                return CategoryCard(
                  category: category,
                  isSelected:
                      placeController.selectedCategoryId.value == category.id,
                  onTap: () async {
                    await placeController.filterByCategory(category.id);
                    setState(() {});
                  },
                );
              },
            );
          }),
        ),
        Expanded(
          child: Obx(() {
            if (placeController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (placeController.places.isEmpty) {
              return Center(child: Text('لا توجد أماكن'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: placeController.places.length,
              itemBuilder: (context, index) {
                final Service place = placeController.places[index];
                return PlaceCard(place: place);
              },
            );
          }),
        ),
      ],
    );
  }
}
