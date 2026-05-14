import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<String> tabs;

  const HapHapTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    // Default tabs sesuai dengan desainmu
    this.tabs = const ['Proses', 'Riwayat', 'Lainnya'], 
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(tabs.length, (index) {
        return Row(
          children: [
            _buildTabItem(index, tabs[index]),
            // Jarak antar tulisan adalah 32 (kecuali setelah item terakhir)
            if (index < tabs.length - 1) const SizedBox(width: 32),
          ],
        );
      }),
    );
  }

  Widget _buildTabItem(int index, String title) {
    bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      // IntrinsicWidth memaksa lebar garis bawah persis mengikuti lebar teks di atasnya
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.black : AppColors.greyDark,
                ),
              ),
            ),
            const SizedBox(height: 8), // Jarak dari teks ke garis oren
            
            // GARIS INDIKATOR OREN
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(4), // Ujung garis dibuat membulat
              ),
            ),
          ],
        ),
      ),
    );
  }
}