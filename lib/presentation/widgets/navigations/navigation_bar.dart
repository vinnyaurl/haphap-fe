import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/core/constants/app_icons.dart';

enum NavBarType { user, merchant, admin }

class HapHapNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final NavBarType type; 

  const HapHapNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.type = NavBarType.user, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402,
      height: 104,
      padding: const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 36),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, 
        crossAxisAlignment: CrossAxisAlignment.start, 
        
        children: type == NavBarType.user
          ? _buildUserItems()
          : type == NavBarType.merchant
              ? _buildMerchantItems()
              : _buildAdminItems(),
      ),
    );
  }

  List<Widget> _buildUserItems() {
    return [
      _buildNavItem(0, AppIcons.nav_beranda, 'Beranda'),
      const SizedBox(width: 32), 
      _buildNavItem(1, AppIcons.nav_jelajah, 'Jelajah'),
      const SizedBox(width: 32),
      _buildNavItem(2, AppIcons.nav_aktivitas, 'Aktivitas'),
      const SizedBox(width: 32),
      _buildNavItem(3, AppIcons.nav_akun, 'Akun'),
    ];
  }

  List<Widget> _buildMerchantItems() {
    return [
      _buildNavItem(0, AppIcons.nav_beranda, 'Beranda'),
      const SizedBox(width: 32),
      _buildNavItem(1, AppIcons.nav_menu, 'Menu'),
      const SizedBox(width: 32),
      _buildNavItem(2, AppIcons.nav_aktivitas, 'Aktivitas'),
      const SizedBox(width: 32),
      _buildNavItem(3, AppIcons.nav_akun, 'Akun'),
    ];
  }

  List<Widget> _buildAdminItems() {
    return [
      _buildNavItem(0, AppIcons.nav_beranda, 'Beranda'),
      const SizedBox(width: 56),
      _buildNavItem(1, AppIcons.nav_aktivitas, 'Pengajuan'),
      const SizedBox(width: 56),
      _buildNavItem(2, AppIcons.nav_akun, 'Akun'),
    ];
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
            
            const SizedBox(height: 12), 
            
            SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  isActive ? AppColors.primary : AppColors.greyDark,
                  BlendMode.srcIn,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.greyDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}