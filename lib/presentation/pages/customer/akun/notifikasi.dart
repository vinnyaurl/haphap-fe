import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Untuk switch gaya iOS yang mirip Figma
import 'package:haphap_fe/core/theme/app_colors.dart';

// --- IMPORT KOMPONEN HEADER KITA ---
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart'; 

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  // State untuk menyimpan nilai on/off dari masing-masing notifikasi
  bool _statusPesanan = true;
  bool _promoDiskon = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Background abu-abu muda biar card menonjol
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            // 1. HEADER MENGGUNAKAN KOMPONEN
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: HapHapPageHeader(
                title: 'Notifikasi',
              ),
            ),
            
            // Menyamakan jarak seperti di kode referensimu
            const SizedBox(height: 16),

            // 2. CARD PENGATURAN NOTIFIKASI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Baris 1: Status Pesanan
                    _buildNotificationTile(
                      icon: Icons.notifications,
                      title: 'Status Pesanan',
                      value: _statusPesanan,
                      onChanged: (newValue) {
                        setState(() {
                          _statusPesanan = newValue;
                        });
                      },
                    ),
                    
                    // Baris 2: Promo & Diskon
                    _buildNotificationTile(
                      icon: Icons.campaign, 
                      title: 'Promo & Diskon',
                      value: _promoDiskon,
                      onChanged: (newValue) {
                        setState(() {
                          _promoDiskon = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // WIDGET HELPER UNTUK BARIS PENGATURAN
  // ===========================================================================
  Widget _buildNotificationTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF505050)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ),
          // Switch gaya iOS biar persis kayak Figma
          CupertinoSwitch(
            value: value,
            activeTrackColor: Colors.green, // Warna hijau saat ON
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}