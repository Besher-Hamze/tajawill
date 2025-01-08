import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../routes/app_pages.dart';

class UserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;
  var user = Rxn<UserModel>(); // Observable for user data

  Future<void> getUserData() async {
    try {
      isLoading(true);
      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (userDoc.exists) {
        user.value = UserModel.fromMap(userDoc.data()!, userDoc.id);
      } else {
        Get.snackbar(
          'خطأ',
          'لا يوجد مستخدم بالمعرف المحدد.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء جلب بيانات المستخدم: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  onInit() {
    getUserData();
  }

  /// Update user details (except email)
  Future<void> updateUserDetails(
      String userId, String name, String phone) async {
    try {
      isLoading(true);
      await _firestore.collection('users').doc(userId).update({
        'name': name,
        'phone': phone,
      });
      // Update local user data
      user.value = UserModel(
        id: userId,
        name: name,
        email: user.value?.email ?? '',
        phone: phone,
      );
      Get.snackbar(
        'نجاح',
        'تم تحديث بيانات المستخدم بنجاح.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        icon: Icon(Icons.check_circle, color: Colors.green),
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحديث بيانات المستخدم: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        icon: Icon(Icons.error, color: Colors.red),
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تسجيل الخروج: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        icon: Icon(Icons.error, color: Colors.red),
      );
    }
  }
}
