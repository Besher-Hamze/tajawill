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

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.find();
    final PlaceController placeController = Get.find();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 180,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اكتشف سوريا',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'استكشف أجمل المعالم والوجهات السياحية',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Row(
                    children: [
                      // Search Bar
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'ابحث عن وجهتك...',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: AppColors.primary,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            onChanged: (value) async {
                              if (value.isEmpty) {
                                await placeController.fetchPlaces();
                              } else {
                                await placeController.search(
                                  value,
                                  _selectedGovernorate,
                                  categoryId,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Location Filter Button
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: PopupMenuButton<String>(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          position: PopupMenuPosition.under,
                          offset: const Offset(0, 8),
                          onSelected: (String value) async {
                            setState(() => _selectedGovernorate = value);
                            if (value != "الكل") {
                              await placeController.filterByGov(value);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(
                              Icons.location_on_outlined,
                              color: AppColors.primary,
                            ),
                          ),
                          itemBuilder: (context) => _syrianGovernorates
                              .map(
                                (gov) => PopupMenuItem<String>(
                              value: gov,
                              child: Text(
                                gov,
                                style: TextStyle(
                                  color: _selectedGovernorate == gov
                                      ? AppColors.primary
                                      : Colors.black87,
                                  fontWeight: _selectedGovernorate == gov
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Categories List
            SliverToBoxAdapter(
              child: Container(
                height: 70,
                color: Colors.white,
                child: Obx(
                      () {
                    if (categoryController.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      itemCount: categoryController.categories.length,
                      itemBuilder: (context, index) {
                        final category = categoryController.categories[index];
                        return CategoryCard(
                          category: category,
                          isSelected: placeController.selectedCategoryId.value ==
                              category.id,
                          onTap: () async {
                            categoryId = category.id;
                            await placeController.filterByCategory(category.id);
                            setState(() {});
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            // Places Grid
            Obx(
                  () {
                if (placeController.isLoading.value) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (placeController.places.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.search_off_rounded,
                              size: 32,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد وجهات متاحة',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'جرب البحث بكلمات مختلفة',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final Service place = placeController.places[index];
                        return PlaceCard(
                          place: place,
                          index: index,
                        );
                      },
                      childCount: placeController.places.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}