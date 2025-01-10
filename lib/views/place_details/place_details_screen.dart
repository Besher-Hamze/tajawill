import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intel;
import 'package:tajawil/views/place_details/view_map.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/review_controller.dart';
import '../../controllers/favorite_controller.dart';
import '../../models/service_model.dart';
import '../../models/offer.dart';
import '../../services/offer_service.dart';
import '../../utils/app_colors.dart';
import 'widgets/comment_section.dart';

class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({super.key});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  final OfferService _offerService = OfferService();
  late Future<List<Offer>> _offersFuture;

  @override
  void initState() {
    super.initState();
    final Service place = Get.arguments as Service;
    _offersFuture = _offerService.getOffersByPlace(place.id);
  }

  @override
  Widget build(BuildContext context) {
    final Service place = Get.arguments as Service;
    final ReviewController reviewController =
        Get.put(ReviewController(place.id));
    final FavoriteController favoriteController = Get.put(
      FavoriteController("${FirebaseAuth.instance.currentUser!.uid}"),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 350,
              floating: false,
              pinned: true,
              stretch: true,
              backgroundColor: AppColors.primary,
              leading: CircleAvatar(
                backgroundColor: Colors.black26,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                ],
                title: Text(
                  place.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3.0,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'place_image_${place.id}',
                      child: ClipRRect(
                        child: Image.network(
                          place.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Obx(() {
                  bool isFav = favoriteController.isFavorite(place.id);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        favoriteController.toggleFavorite(place.id);
                      },
                    ),
                  );
                }),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Place details
                      Text(
                        place.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                      if (place.openTime != null) ...[
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Icon(Icons.timelapse),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              place.openTime!,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Offers Section
                      FutureBuilder<List<Offer>>(
                        future: _offersFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text(
                                'لا توجد عروض حالياً',
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          }

                          final offers = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'العروض المميزة',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: offers.length,
                                itemBuilder: (context, index) {
                                  final offer = offers[index];
                                  final formattedEndDate =
                                      intel.DateFormat('yyyy-MM-dd').format(
                                          offer.endDate); // Format the date

                                  return Card(
                                    elevation: 4,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: ListTile(
                                      title: Text(
                                        offer.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(offer.description),
                                          const SizedBox(height: 8),
                                          Text(
                                            'السعر الأصلي: ${offer.originalPrice.toStringAsFixed(2)} ل.س',
                                          ),
                                          Text(
                                            'السعر بعد الخصم: ${offer.discountedPrice.toStringAsFixed(2)} ل.س',
                                          ),
                                          Text(
                                            'ينتهي بتاريخ: ${formattedEndDate}',
                                          ),
                                        ],
                                      ),
                                      trailing: true
                                          ? const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                      CommentSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomActions(context, place),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, Service place) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.phone_outlined),
                label: const Text(
                  'اتصال',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  const phoneNumber = '+963 947813951';
                  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not launch phone dialer'),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.map_outlined),
                label: const Text(
                  'الخريطة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapboxPathExample(
                        destination: LatLng(place.latitude, place.longitude),
                        destinationTitle: place.name,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
