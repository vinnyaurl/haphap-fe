import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapOrderItem {
  final String name;
  final String description;
  final String price;
  final int quantity;

  const HapHapOrderItem({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
  });
}

class HapHapDetailPesananCard extends StatelessWidget {
  final String restaurantName;
  final String restaurantLogoUrl;
  final List<HapHapOrderItem> items;

  const HapHapDetailPesananCard({
    super.key,
    required this.restaurantName,
    required this.restaurantLogoUrl,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF1F1F1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: restaurantLogoUrl.isNotEmpty
                    ? Image.network(
                        restaurantLogoUrl,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 32,
                            height: 32,
                            color: const Color(0xFFF5F5F5),
                            child: const Icon(Icons.storefront, color: AppColors.greyDark, size: 16),
                          );
                        },
                      )
                    : Container(
                        width: 32,
                        height: 32,
                        color: const Color(0xFFF5F5F5),
                        child: const Icon(Icons.storefront, color: AppColors.greyDark, size: 16),
                      ),
              ),
              const SizedBox(width: 12),
              Text(
                restaurantName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16), 

          ...List.generate(items.length, (index) {
            final item = items[index];
            
            return Padding(
              padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.greyDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 16), 
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.price,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'x${item.quantity}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.greyDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}