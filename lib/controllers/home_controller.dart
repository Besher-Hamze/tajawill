import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajawil/services/service_service.dart';
import 'package:tajawil/views/home/favorite_screen.dart';
import 'package:tajawil/views/home/main_page.dart';

import '../views/home/account_screen.dart';

class HomeController extends GetxController {
  Rx<int> currentScreen = 0.obs;

  bool isAdmin = false;
  List<Widget> screens = [
    MainPage(),
    FavoriteScreen(),
    AccountScreen(),
  ];

  changeScreen(int index) {
    currentScreen(index);
    update();
  }

  checkIsAdmin() async {
    var places = await PlaceService().getMyPlaces();
    if (places.isNotEmpty) {
      isAdmin = true;
    } else {
      isAdmin = false;
    }
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkIsAdmin();
  }
}
