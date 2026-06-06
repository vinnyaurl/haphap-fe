import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/dialog/menu_detail_bottom_sheet.dart';

class HapHapMenuCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String price;
  final int stockCount;
  final int cartCount;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const HapHapMenuCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.stockCount,
    this.cartCount = 0,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    bool isOutOfStock = stockCount == 0;

    return GestureDetector(
      onTap: () {
        showMenuDetailBottomSheet(
          context,
          imageUrl: imageUrl,
          title: title,
          description: description,
          price: price,
          onAddToCart: onAdd,
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 402,
        height: 144,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F1F1), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildImage(isOutOfStock),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStockIndicator(isOutOfStock),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: AppColors.greyDark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      _buildActionButtons(isOutOfStock),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(bool isOutOfStock) {
    final isValidUrl = imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

    Widget imageWidget = isValidUrl
        ? Image.network(
            imageUrl,
            width: 112,
            height: 112,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _imagePlaceholder(),
          )
        : _imagePlaceholder();

    if (isOutOfStock) {
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0,      0,      0,      1, 0,
        ]),
        child: imageWidget,
      );
    }
    return imageWidget;
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 112,
      height: 112,
      color: const Color(0xFFF1F1F1),
      child: const Icon(Icons.fastfood, color: AppColors.greyDark, size: 32),
    );
  }

  Widget _buildStockIndicator(bool isOutOfStock) {
    if (isOutOfStock) {
      return const Text(
        'Out of\nStock',
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.error,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.error,
          height: 1.2,
        ),
      );
    } else if (stockCount <= 5) {
      return Text(
        '$stockCount left',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.primary,
        ),
      );
    }
    return Text(
      '$stockCount left',
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.greyDark,
        decoration: TextDecoration.underline,
        decorationColor: AppColors.greyDark,
      ),
    );
  }

  Widget _buildActionButtons(bool isOutOfStock) {
    if (isOutOfStock) return const SizedBox(height: 24);

    Widget circleButton(IconData icon, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.white, size: 16),
        ),
      );
    }

    if (cartCount == 0) {
      return circleButton(Icons.add, onAdd);
    } else {
      return Row(
        children: [
          circleButton(Icons.remove, onRemove),
          const SizedBox(width: 12),
          Text(
            '$cartCount',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(width: 12),
          circleButton(Icons.add, onAdd),
        ],
      );
    }
  }
}