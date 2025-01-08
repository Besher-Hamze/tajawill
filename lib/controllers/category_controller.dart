// lib/controllers/category_controller.dart
import 'package:get/get.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryController extends GetxController {
  var categories = <CategoryModel>[].obs;
  var isLoading = true.obs;

  final CategoryService _categoryService = CategoryService();

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  void fetchCategories() async {
    try {
      isLoading(true);
      var fetchedCategories = await _categoryService.getCategories();
      if (fetchedCategories.isNotEmpty) {
        categories.assignAll(fetchedCategories);
      }
    } finally {
      isLoading(false);
    }
  }
}
