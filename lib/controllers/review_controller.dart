// lib/controllers/review_controller.dart
import 'package:get/get.dart';
import '../models/review.dart';
import '../services/review_service.dart';

class ReviewController extends GetxController {
  var reviews = <Review>[].obs;
  var isLoading = true.obs;
  final String placeId;

  final ReviewService _reviewService = ReviewService();

  ReviewController(this.placeId);

  @override
  void onInit() {
    fetchReviews();
    super.onInit();
  }

  void fetchReviews() async {
    try {
      isLoading(true);
      var fetchedReviews = await _reviewService.getReviews(placeId);
      if (fetchedReviews.isNotEmpty) {
        reviews.assignAll(fetchedReviews);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> addReview(Review review) async {
    await _reviewService.addReview(review);
    fetchReviews();
  }
}
