import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart'; // Import HapHapButton

class HapHapDeleteMenuDialog extends StatelessWidget {
  final String menuName;

  const HapHapDeleteMenuDialog({super.key, required this.menuName});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Hapus Menu?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Yakin mau hapus "$menuName"? Data yang sudah dihapus tidak bisa dikembalikan.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.greyDark),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: HapHapButton(
                    text: 'Batal',
                    isOutline: true, // Asumsi ada parameter ini di tombolmu
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Tombol bahaya
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      print('Menu $menuName berhasil dihapus!');
                      Navigator.pop(context);
                    },
                    child: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}