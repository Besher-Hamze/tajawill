import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

class CategoryService {
  final CollectionReference _categoriesRef =
  FirebaseFirestore.instance.collection('categories');

  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot snapshot = await _categoriesRef.get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CategoryModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}
