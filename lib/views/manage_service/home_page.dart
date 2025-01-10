import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajawil/views/manage_service/place_admin_card.dart';

import '../../controllers/service_controller.dart';
import '../../models/service_model.dart';
import '../../utils/app_colors.dart';
import '../home/widgets/place_card.dart';

class HomeAdminManagement extends StatelessWidget {
  HomeAdminManagement({super.key});

  final PlaceController placeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "خدماتي",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        if (placeController.isMyLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        }
        if (placeController.myPlaces.isEmpty) {
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
          itemCount: placeController.myPlaces.length,
          itemBuilder: (context, index) {
            final Service place = placeController.myPlaces[index];
            return PlaceAdminCard(place: place);
          },
        );
      }),
    );
  }
}
