import 'package:flutter/material.dart';
import '../../../models/category.dart';
import '../../../utils/app_colors.dart';

class CategoryCard extends StatefulWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  // Mapping of category names to icons. Add or adjust entries as needed.
  static final Map<String, IconData> _categoryIcons = {
    'مطاعم': Icons.restaurant,
    'فنادق': Icons.hotel,
    'معالم سياحية': Icons.landscape,
    'متاحف': Icons.museum,
    'حدائق': Icons.park,
    'تسوق': Icons.shopping_bag,
    'شواطئ': Icons.beach_access,
    'ترفيه': Icons.attractions,
    'مقاهي':Icons.local_cafe_outlined,
    'البسة': Icons.checkroom,
    'رياضة': Icons.sports_soccer,
    'صحة': Icons.local_hospital,
    'تعليم': Icons.school,
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Returns the corresponding icon for the category.
  IconData _getCategoryIcon() {
    // Normalize the category name (trim and use case-sensitive lookup if needed)
    final name = widget.category.name.trim();
    return _categoryIcons[name] ?? Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(left: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            // Use a gradient when selected, or a plain light grey background otherwise.
            gradient: widget.isSelected
                ? LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            color: widget.isSelected ? null : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            boxShadow: widget.isSelected
                ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getCategoryIcon(),
                size: 20,
                color: widget.isSelected ? Colors.white : AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                widget.category.name,
                style: TextStyle(
                  color: widget.isSelected ? Colors.white : Colors.black87,
                  fontSize: 14,
                  fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
