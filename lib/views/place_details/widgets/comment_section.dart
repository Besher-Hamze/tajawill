import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajawil/controllers/service_controller.dart';
import 'package:tajawil/utils/cache_helper.dart';
import '../../../controllers/review_controller.dart';
import '../../../models/review.dart';
import '../../../utils/app_colors.dart';
import 'review_card.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({super.key});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final ReviewController reviewController = Get.find();
  final TextEditingController _commentController = TextEditingController();
  final RxDouble _rating = 0.0.obs;
  final RxBool _isExpanded = false.obs;

  void _submitReview() {
    if (_rating.value == 0 || _commentController.text.trim().isEmpty) {
      Get.snackbar(
        'تنبيه',
        'الرجاء اختيار تقييم وكتابة تعليق',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    Review newReview = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: FirebaseAuth.instance.currentUser!.uid,
      userName: CacheHelper.getData(key: "name"),
      placeId: reviewController.placeId,
      rating: _rating.value,
      comment: _commentController.text.trim(),
      date: DateTime.now(),
    );

    reviewController.addReview(newReview);
    // Optionally refresh your places.
    Get.put(PlaceController())
      ..fetchMyPlaces()
      ..fetchPlaces();

    _commentController.clear();
    _rating.value = 0;

    Get.snackbar(
      'نجاح',
      'تم إضافة تقييمك بنجاح',
      backgroundColor: Colors.green[100],
      colorText: Colors.green[900],
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (reviewController.isLoading.value) {
        return Center(
            child: CircularProgressIndicator(
                color: AppColors.primary, strokeWidth: 3));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التقييمات والمراجعات',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text),
              ),
              if (reviewController.reviews.isNotEmpty)
                TextButton.icon(
                  onPressed: () => _isExpanded.toggle(),
                  icon: Icon(
                    _isExpanded.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    _isExpanded.value ? 'عرض أقل' : 'عرض الكل',
                    style: TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Reviews List or empty state
          reviewController.reviews.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      Icon(Icons.rate_review_outlined,
                          size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text('لا توجد تقييمات بعد',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16)),
                    ],
                  ),
                )
              : AnimatedColumn(
                  children: reviewController.reviews
                      .take(_isExpanded.value
                          ? reviewController.reviews.length
                          : 3)
                      .map((review) => ReviewCard(review: review))
                      .toList(),
                ),
          const SizedBox(height: 24),
          // Add Review Section
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Gradient Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.rate_review_outlined,
                          color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'أضف تقييمك',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating Stars
                      const Text(
                        'تقييمك',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () => _rating.value = index + 1.0,
                            child: Obx(() {
                              final isSelected = index < _rating.value;
                              return Icon(
                                isSelected
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: isSelected
                                    ? Colors.amber
                                    : Colors.grey[400],
                                size: 36,
                              );
                            }),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      // Comment Field
                      TextField(
                        controller: _commentController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'شاركنا رأيك...',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitReview,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'إرسال التقييم',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      );
    });
  }
}

class AnimatedColumn extends StatelessWidget {
  final List<Widget> children;

  const AnimatedColumn({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.asMap().entries.map((entry) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 200 + (entry.key * 100)),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: entry.value,
        );
      }).toList(),
    );
  }
}
