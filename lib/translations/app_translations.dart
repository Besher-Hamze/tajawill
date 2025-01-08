// lib/translations/app_translations.dart
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ar_SA': {
      'home': 'الرئيسية',
      'favorites': 'المفضلة',
      'account': 'حسابي',
      'search': 'ابحث عن خدمة...',
      'no_places': 'لا توجد أماكن',
      // أضف المزيد من الترجمات حسب الحاجة
    },
    'en_US': {
      'home': 'Home',
      'favorites': 'Favorites',
      'account': 'Account',
      'search': 'Search for a service...',
      'no_places': 'No places found',
      // أضف المزيد من الترجمات حسب الحاجة
    },
  };
}
