// lib/services/sub_category_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sub_category.dart';

class SubCategoryService {
  final CollectionReference _subCategoriesRef =
  FirebaseFirestore.instance.collection('subCategories');

  Future<List<SubCategory>> getSubCategories() async {
    try {
      QuerySnapshot snapshot = await _subCategoriesRef.get();
      return snapshot.docs.map((doc) {
        return SubCategory.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<SubCategory>> getSubCategoriesByCategory(int categoryId) async {
    try {
      QuerySnapshot snapshot = await _subCategoriesRef
          .where('parentId', isEqualTo: categoryId)
          .get();
      return snapshot.docs.map((doc) {
        return SubCategory.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
