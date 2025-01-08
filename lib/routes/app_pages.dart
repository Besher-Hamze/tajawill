// lib/routes/app_pages.dart
import 'package:get/get.dart';
import '../views/home/home_screen.dart';
import '../views/place_details/place_details_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../bindings/home_binding.dart';
import '../bindings/place_details_binding.dart';
import '../bindings/auth_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.PLACE_DETAILS,
      page: () => const PlaceDetailsScreen(),
      binding: PlaceDetailsBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterScreen(),
      binding: AuthBinding(),
    ),
  ];
}
