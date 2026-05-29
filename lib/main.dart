import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/pages/customer/aktivitas/aktivitas.dart';
import 'package:haphap_fe/presentation/pages/customer/beranda.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_aktivitas.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_akun.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_beranda.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_menu.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_statistik.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HapHap',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: AppColors.primary),
      home: const BerandaMerchantPage(),
    );
  }
}
