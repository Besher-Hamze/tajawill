import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajawil/views/home/favorite_screen.dart';
import 'package:tajawil/views/home/main_page.dart';

import '../views/home/account_screen.dart';

class HomeController extends GetxController {
  Rx<int> currentScreen = 0.obs;

  List<Widget> screens = [
    MainPage(),
    FavoriteScreen(),
    AccountScreen(),
  ];

  changeScreen(int index) {
    currentScreen(index);
    update();
  }
}
