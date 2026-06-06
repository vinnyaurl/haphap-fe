import 'package:go_router/go_router.dart';
import 'package:haphap_fe/presentation/pages/customer/akun/alamat.dart';
import 'package:haphap_fe/presentation/pages/customer/akun/bahasa.dart';
import 'package:haphap_fe/presentation/pages/customer/akun/edit_profil.dart';
import 'package:haphap_fe/presentation/pages/customer/akun/notifikasi.dart';
import 'package:haphap_fe/presentation/pages/customer/akun/statistik.dart';
import 'package:haphap_fe/presentation/shell/merchant_shell.dart';
import 'package:haphap_fe/presentation/shell/user_shell.dart';

import 'package:haphap_fe/presentation/pages/splash/splash_screen.dart';
import 'package:haphap_fe/presentation/pages/splash/onboarding_screen.dart';
import 'package:haphap_fe/presentation/pages/auth/login_screen.dart';
import 'package:haphap_fe/presentation/pages/auth/register_screen.dart';

import 'package:haphap_fe/presentation/pages/customer/beranda.dart';
import 'package:haphap_fe/presentation/pages/customer/jelajah.dart';
import 'package:haphap_fe/presentation/pages/customer/aktivitas/aktivitas.dart';
import 'package:haphap_fe/presentation/pages/customer/aktivitas/detail_pesanan.dart';
import 'package:haphap_fe/presentation/pages/customer/aktivitas/laporan_transaksi.dart';
import 'package:haphap_fe/presentation/pages/customer/akun/akun.dart';

import 'package:haphap_fe/presentation/pages/customer/detail_restaurant.dart';
import 'package:haphap_fe/presentation/pages/customer/checkout.dart';

import 'package:haphap_fe/presentation/pages/merchant/merchant_beranda.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_menu.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_aktivitas.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_akun.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_statistik.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_notifikasi.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';

  static const String beranda = '/beranda';
  static const String jelajah = '/jelajah';
  static const String aktivitas = '/aktivitas';
  static const String akun = '/akun';
  static const String detailPesanan = '/detail';
  static const String laporanTransaksi = '/laporan';
  static const String editProfil = '/edit-profil';

  static const String statistik = '/statistik';
  static const String alamat = '/alamat';
  static const String bahasa = '/bahasa';
  static const String notifikasi = '/notifikasi';

  static const String detailRestoran = '/detail-restoran';
  static const String checkout = '/checkout';

  static const String merchantBeranda = '/merchant/beranda';
  static const String merchantMenu = '/merchant/menu';
  static const String merchantAktivitas = '/merchant/aktivitas';
  static const String merchantAkun = '/merchant/akun';
  static const String merchantStatistik = '/merchant/statistik';
  static const String merchantNotifikasi = '/merchant/notifikasi';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.beranda,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.detailPesanan,
      builder: (context, state) => const DetailPesananPage(),
    ),
    GoRoute(
      path: AppRoutes.laporanTransaksi,
      builder: (context, state) => const LaporanTransaksiPage(),
    ),

    GoRoute(
      path: '${AppRoutes.detailRestoran}/:merchantId',
      builder: (context, state) {
        final merchantId = state.pathParameters['merchantId']!;
        return DetailRestoranPage(merchantId: merchantId);
      },
    ),

    GoRoute(
      path: AppRoutes.checkout,
      builder: (context, state) {
        final args = state.extra as CheckoutArgs;
        return CheckoutPage(args: args);
      },
    ),

    GoRoute(
      path: AppRoutes.editProfil,
      builder: (context, state) => const EditProfilPage(),
    ),
    GoRoute(
      path: AppRoutes.statistik,
      builder: (context, state) => const StatistikPage(),
    ),
    GoRoute(
      path: AppRoutes.alamat,
      builder: (context, state) => const AlamatPage(),
    ),
    GoRoute(
      path: AppRoutes.bahasa,
      builder: (context, state) => const BahasaPage(),
    ),
    GoRoute(
      path: AppRoutes.notifikasi,
      builder: (context, state) => const NotifikasiPage(),
    ),
    GoRoute(
      path: AppRoutes.merchantStatistik,
      builder: (context, state) => const StatistikMerchantPage(),
    ),
    GoRoute(
      path: AppRoutes.merchantNotifikasi,
      builder: (context, state) => const NotifikasiMerchantPage(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.beranda,
              builder: (context, state) => const BerandaPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.jelajah,
              builder: (context, state) => const JelajahPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.aktivitas,
              builder: (context, state) => const AktivitasPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.akun,
              builder: (context, state) => const AkunPage(),
            ),
          ],
        ),
      ],
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MerchantShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.merchantBeranda,
              builder: (context, state) => const BerandaMerchantPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.merchantMenu,
              builder: (context, state) => const MenuMerchantPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.merchantAktivitas,
              builder: (context, state) => const AktivitasMerchantPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.merchantAkun,
              builder: (context, state) => const AkunMerchantPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);