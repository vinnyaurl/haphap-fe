import 'package:go_router/go_router.dart';
import 'package:haphap_fe/presentation/shell/main_shell.dart';
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
  ],
);