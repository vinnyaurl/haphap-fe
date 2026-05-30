import 'package:go_router/go_router.dart';
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
import 'package:haphap_fe/presentation/pages/customer/akun.dart';

import 'package:haphap_fe/presentation/pages/merchant/merchant_beranda.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_menu.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_aktivitas.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_akun.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_statistik.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_notifikasi.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash     = '/splash';
  static const String onboarding = '/onboarding';
  static const String login      = '/login';
  static const String register   = '/register';

  static const String beranda    = '/beranda';
  static const String jelajah    = '/jelajah';
  static const String aktivitas  = '/aktivitas';
  static const String akun       = '/akun';

  static const String detailPesanan    = '/aktivitas/detail';
  static const String laporanTransaksi = '/aktivitas/laporan';


  static const String merchantBeranda   = '/merchant/beranda';
  static const String merchantMenu      = '/merchant/menu';
  static const String merchantAktivitas = '/merchant/aktivitas';
  static const String merchantAkun      = '/merchant/akun';

  static const String merchantStatistik   = '/merchant/akun/statistik';
  static const String merchantNotifikasi  = '/merchant/akun/notifikasi';
  
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.merchantBeranda,
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
              routes: [
                GoRoute(
                  path: 'detail',
                  builder: (context, state) => const DetailPesananPage(),
                ),
                GoRoute(
                  path: 'laporan',
                  builder: (context, state) => const LaporanTransaksiPage(),
                ),
              ],
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
              routes: [
              ],
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
              routes: [
                GoRoute(
                  path: 'notifikasi',
                  builder: (context, state) => const NotifikasiMerchantPage(),
                ),
                GoRoute(
                  path: 'statistik',
                  builder: (context, state) => const StatistikMerchantPage(),
                ),
              ],
            ),
          ],
        ),
 
      ],
    ),
 
  ],
);


