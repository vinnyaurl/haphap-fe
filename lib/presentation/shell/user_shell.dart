import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/presentation/widgets/navigations/navigation_bar.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: HapHapNavBar(
        currentIndex: navigationShell.currentIndex,
        type: NavBarType.user,
        onTap: (index) {
          bool initialLocation = index == navigationShell.currentIndex;
          if (index == 2 && navigationShell.currentIndex != 2) {
            initialLocation = true;
          }
          navigationShell.goBranch(
            index,
            initialLocation: initialLocation,
          );
        },
      ),
    );
  }
}