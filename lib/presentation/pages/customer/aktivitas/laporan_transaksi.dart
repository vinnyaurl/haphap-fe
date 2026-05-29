import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/presentation/widgets/inputs/text_fields.dart'; 
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';

class LaporanTransaksiPage extends StatefulWidget {
  const LaporanTransaksiPage({super.key});

  @override
  State<LaporanTransaksiPage> createState() => _LaporanTransaksiPageState();
}

class _LaporanTransaksiPageState extends State<LaporanTransaksiPage> {
  final TextEditingController _dariController = TextEditingController(text: '06/07/2026');
  final TextEditingController _sampaiController = TextEditingController(text: '06/07/2027');

  @override
  void dispose() {
    _dariController.dispose();
    _sampaiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HapHapPageHeader(
                title: 'Laporan Transaksi',
              ),
              
              const SizedBox(height: 32),

              const Text(
                'Pilih rentang periode',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Minimum 1 hari, maksimum 1 tahun.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.greyDark,
                ),
              ),

              const SizedBox(height: 32),

              HapHapTextField(
                labelText: 'Dari',
                hintText: 'DD/MM/YYYY',
                controller: _dariController,
                isRequired: true,
              ),

              const SizedBox(height: 24),

              HapHapTextField(
                labelText: 'Sampai',
                hintText: 'DD/MM/YYYY',
                controller: _sampaiController,
                isRequired: true,
              ),

              const Spacer(), 

              Center(
                child: HapHapButton(
                  text: 'Unduh',
                  size: HapHapButtonSize.large, 
                  onPressed: () {
                    print('Mengunduh laporan dari ${_dariController.text} sampai ${_sampaiController.text}');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}