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
  bool _statusPesanan = true;
  bool _promoDiskon = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: HapHapPageHeader(
                title: 'Notifikasi',
              ),
            ),
            
            const SizedBox(height: 16),

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
          CupertinoSwitch(
            value: value,
            activeTrackColor: Colors.green,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}