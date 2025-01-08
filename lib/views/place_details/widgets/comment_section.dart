// lib/views/place_details/widgets/comment_section.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajawil/utils/cache_helper.dart';
import '../../../controllers/review_controller.dart';
import '../../../models/review.dart';
import 'review_card.dart';

class CommentSection extends StatelessWidget {
  CommentSection({super.key});

  final ReviewController reviewController = Get.find();

  final TextEditingController _commentController = TextEditingController();
  final RxDouble _rating = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (reviewController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...reviewController.reviews.map((review) {
            return ReviewCard(review: review);
          }).toList(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إضافة تقييم',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        _rating.value = index + 1.0;
                      },
                      child: Obx(() {
                        return Icon(
                          index < _rating.value
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        );
                      }),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                // حقل كتابة التعليق
                TextField(
                  controller: _commentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'اكتب تعليقك هنا...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 16),
                // زر الإرسال
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_rating.value == 0) {
                        Get.snackbar('خطأ', 'الرجاء اختيار تقييم',
                            snackPosition: SnackPosition.BOTTOM);
                        return;
                      }
                      if (_commentController.text.trim().isEmpty) {
                        Get.snackbar('خطأ', 'الرجاء كتابة تعليق',
                            snackPosition: SnackPosition.BOTTOM);
                        return;
                      }

                      // إنشاء مراجعة جديدة
                      Review newReview = Review(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        // يجب ربطه بنظام المستخدم الحقيقي
                        userName: CacheHelper.getData(key: "name"),
                        // يجب جلبه من المستخدم الحقيقي
                        placeId: reviewController.placeId,
                        rating: _rating.value,
                        comment: _commentController.text.trim(),
                        date: DateTime.now(),
                      );

                      reviewController.addReview(newReview);

                      _commentController.clear();
                      _rating.value = 0;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('إرسال التقييم'),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
