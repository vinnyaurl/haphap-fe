import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/presentation/widgets/navigations/navigation_bar.dart';

class MerchantShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MerchantShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: navigationShell,
      bottomNavigationBar: HapHapNavBar(
        currentIndex: navigationShell.currentIndex,
        type: NavBarType.merchant,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}