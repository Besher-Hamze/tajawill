import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajawil/views/home/widgets/category_card.dart';
import 'package:tajawil/views/home/widgets/place_card.dart';

import '../../controllers/category_controller.dart';
import '../../controllers/service_controller.dart';
import '../../models/service_model.dart';
import '../../utils/app_colors.dart';
import '../widgets/drop_down.dart';

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
    String? _selectedGovernorate;
    String? categoryId;
    final List<String> _syrianGovernorates = [
      'الكل',
      'دمشق',
      'ريف دمشق',
      'حلب',
      'حمص',
      'حماة',
      'اللاذقية',
      'طرطوس',
      'درعا',
      'السويداء',
      'القنيطرة',
      'دير الزور',
      'الحسكة',
      'الرقة',
      'إدلب',
    ];
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'ابحث عن خدمة...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search_rounded,
                        color: AppColors.primary, size: 26),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onChanged: (value) async {
                    if (value == "") {
                      await placeController.fetchPlaces();
                    } else {
                      await placeController.search(value,_selectedGovernorate,categoryId);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: buildDropdownField(
              value: _selectedGovernorate,
              items: _syrianGovernorates,
              label: 'المحافظة',
              hint: 'اختر المحافظة',
              onChanged: (value) async {
                setState(() => _selectedGovernorate = value);
                if (_selectedGovernorate != null ||
                    _selectedGovernorate != "الكل") {
                  await placeController.filterByGov(_selectedGovernorate!);
                }
                setState(() {});
              },
              context: context),
        ),
        Container(
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Obx(() {
            if (categoryController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              );
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
                    categoryId=category.id;
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
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              );
            }
            if (placeController.places.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد خدمات متاحة',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
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
