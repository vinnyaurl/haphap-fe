import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haphap_fe/core/constants/app_icons.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/pages/auth/login_screen.dart';
import 'package:haphap_fe/presentation/pages/auth/register_screen.dart';
import 'package:haphap_fe/presentation/pages/customer/beranda.dart';
import 'package:haphap_fe/presentation/pages/splash/onboarding_screen.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';
import 'package:haphap_fe/presentation/widgets/cards/menu_card.dart';
import 'package:haphap_fe/presentation/widgets/cards/restaurant_card.dart';
import 'package:haphap_fe/presentation/widgets/inputs/search_bar.dart';
import 'package:haphap_fe/presentation/widgets/navigations/navigation_bar.dart';

void main() {
  const phoneSizes = <Size>[
    Size(320, 568),
    Size(390, 844),
    Size(430, 932),
    Size(480, 800),
  ];

  for (final size in phoneSizes) {
    testWidgets('shared UI fits ${size.width}x${size.height}', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: MediaQueryData(
              size: size,
              textScaler: const TextScaler.linear(1.3),
            ),
            child: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      const HapHapSearchBar(
                        hintText: 'Cari makanan favoritmu',
                        prefixIconPath: AppIcons.magnifyingGlass,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const HapHapRestaurantCard(
                        imageUrl: '',
                        distanceTime: 'Alamat restoran yang cukup panjang',
                        restaurantName: 'Nama Restoran Sangat Panjang',
                        ratingText: '4.9 rating',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      HapHapMenuCard(
                        imageUrl: '',
                        title: 'Paket makanan dengan nama yang panjang',
                        description: 'Deskripsi makanan yang panjang',
                        price: 'Rp 99.000',
                        stockCount: 4,
                        cartCount: 2,
                        onAdd: () {},
                        onRemove: () {},
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      HapHapButton(
                        text: 'Lanjutkan',
                        size: HapHapButtonSize.large,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: HapHapNavBar(currentIndex: 0, onTap: (_) {}),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  }

  for (final type in NavBarType.values) {
    testWidgets('$type navigation distributes items without overflow', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            bottomNavigationBar: HapHapNavBar(
              currentIndex: 0,
              type: type,
              onTap: (_) {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('navigation icons load and tab taps report the correct index', (
    tester,
  ) async {
    for (final path in const [
      AppIcons.navBeranda,
      AppIcons.navJelajah,
      AppIcons.navAktivitas,
      AppIcons.navAkun,
      AppIcons.navMenu,
    ]) {
      expect((await rootBundle.load(path)).lengthInBytes, greaterThan(0));
    }

    int? tappedIndex;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          bottomNavigationBar: HapHapNavBar(
            currentIndex: 0,
            onTap: (index) => tappedIndex = index,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('nav_item_Jelajah')));
    expect(tappedIndex, 1);
    expect(tester.takeException(), isNull);
  });

  for (final size in const [Size(320, 568), Size(480, 800)]) {
    testWidgets('customer categories distribute within ${size.width}px', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light, home: const BerandaPage()),
      );
      await tester.pump();

      final visibleLabels = size.width >= AppLayout.widePhone
          ? const [
              'Bakery',
              'Restoran',
              'Kafe',
              'Grocery',
              'Jajanan',
              'Dessert',
            ]
          : const ['Bakery', 'Restoran', 'Kafe', 'Grocery'];
      for (final label in visibleLabels) {
        final rect = tester.getRect(
          find.byKey(ValueKey('home_category_$label')),
        );
        expect(rect.left, greaterThanOrEqualTo(0));
        expect(rect.right, lessThanOrEqualTo(size.width));
      }
      expect(tester.takeException(), isNull);
    });
  }

  for (final size in const [Size(320, 568), Size(480, 800)]) {
    for (final screen in const <Widget>[
      LoginScreen(),
      RegisterScreen(),
      OnboardingScreen(),
    ]) {
      testWidgets('${screen.runtimeType} fits ${size.width}x${size.height}', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: MediaQuery(
              data: MediaQueryData(
                size: size,
                textScaler: const TextScaler.linear(1.3),
              ),
              child: screen,
            ),
          ),
        );
        await tester.pump();

        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('auth and onboarding panels remain anchored to the bottom', (
    tester,
  ) async {
    const size = Size(430, 932);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    for (final entry in const <(Widget, Key)>[
      (LoginScreen(), Key('login_bottom_panel')),
      (RegisterScreen(), Key('register_bottom_panel')),
      (OnboardingScreen(), Key('onboarding_bottom_panel')),
    ]) {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light, home: entry.$1),
      );
      await tester.pump();

      expect(
        tester.getBottomLeft(find.byKey(entry.$2)).dy,
        greaterThanOrEqualTo(size.height),
      );
      expect(tester.takeException(), isNull);
    }
  });
}
