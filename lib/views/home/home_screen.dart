// lib/views/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajawil/controllers/home_controller.dart';
import 'package:tajawil/views/home/nearest_places.dart';
import 'package:tajawil/views/manage_service/home_page.dart';
import '../../utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    return GetBuilder<HomeController>(
      builder: (controller) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(
                'دليلك السياحي',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                if (controller.isAdmin)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: TextButton(
                      child: Text(
                        "إدارة خدماتي",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeAdminManagement(),
                            ));
                      },
                    ),
                  ),
              ]),
          body: homeController.screens[homeController.currentScreen.value],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(NearestPlacesScreen());
            },
            child: Icon(Icons.near_me),
          ),
          bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline),
                  activeIcon: Icon(Icons.favorite),
                  label: 'المفضلة',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'حسابي',
                ),
              ],
              currentIndex: homeController.currentScreen.value,
              // يمكنك إدارة الحالة بشكل أفضل باستخدام GetX
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              onTap: homeController.changeScreen),
        ),
      ),
    );
  }
}
