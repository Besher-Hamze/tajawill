import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tajawil/models/user_model.dart';
import 'package:tajawil/utils/cache_helper.dart';

import '../routes/app_pages.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Rx<User?> user;
  var isLoading = false.obs;
  int count = 0;

  @override
  void onReady() {
    super.onReady();
    user = Rx<User?>(_auth.currentUser);
    user.bindStream(_auth.userChanges());
    ever(
      user,
      _initialScreen,
    );
  }

  void _initialScreen(User? user) {
    if (user == null) {
      if (count > 0) {
        ++count;
        Get.offAllNamed(Routes.LOGIN);
      }
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> register(
      String email, String password, String phoneNumber, String name) async {
    try {
      isLoading(true);
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(phoneNumber);
      DocumentReference<Map<String, dynamic>> userRef = FirebaseFirestore
          .instance
          .collection("users")
          .doc(userCredential.user!.uid);
      UserModel userModel = UserModel(
          id: userRef.id, name: name, email: email, phone: phoneNumber);
      await userRef.set(userModel.toMap());
      await CacheHelper.putData(key: "name", value: userModel.name);
      Get.snackbar(
        'نجاح',
        'تم إنشاء الحساب بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        icon: Icon(Icons.check_circle, color: Colors.green),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'email-already-in-use') {
        message = 'البريد الإلكتروني مستخدم بالفعل.';
      } else if (e.code == 'weak-password') {
        message = 'كلمة المرور ضعيفة جداً.';
      } else if (e.code == 'invalid-email') {
        message = 'البريد الإلكتروني غير صالح.';
      } else {
        message = 'حدث خطأ غير معروف. الرجاء المحاولة مرة أخرى.';
      }
      Get.snackbar(
        'خطأ في التسجيل',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        icon: Icon(Icons.error, color: Colors.red),
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        icon: Icon(Icons.error, color: Colors.red),
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading(true);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .get();
      await CacheHelper.putData(key: "name", value: userData.data()?['name'] ?? "Sadam");
      Get.offAllNamed(Routes.HOME);
      Get.snackbar(
        'نجاح',
        'تم تسجيل الدخول بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        icon: Icon(Icons.check_circle, color: Colors.green),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'لا يوجد مستخدم بهذا البريد الإلكتروني.';
      } else if (e.code == 'wrong-password') {
        message = 'كلمة المرور غير صحيحة.';
      } else if (e.code == 'invalid-email') {
        message = 'البريد الإلكتروني غير صالح.';
      } else {
        message = 'حدث خطأ غير معروف. الرجاء المحاولة مرة أخرى.';
      }
      Get.snackbar(
        'خطأ في تسجيل الدخول',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        icon: Icon(Icons.error, color: Colors.red),
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع: ${e.toString()}',
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
      await _auth.signOut();
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
