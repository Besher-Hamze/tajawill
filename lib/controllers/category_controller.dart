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
      List<CategoryModel> categories=[
        CategoryModel(id: "", name: "الكل", description: "")
      ];
      isLoading(true);
      var fetchedCategories = await _categoryService.getCategories();
      if (fetchedCategories.isNotEmpty) {
        fetchedCategories.forEach((element) {categories.add(element);});
        this.categories.value=categories;
      }
    } finally {
      isLoading(false);
    }
  }
}
