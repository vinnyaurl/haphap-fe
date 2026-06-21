import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';

void showMenuDetailBottomSheet(
  BuildContext context, {
  required String imageUrl,
  required String title,
  required String description,
  required String price,
  required VoidCallback onAddToCart,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Wajib true agar tingginya bisa menyesuaikan isi konten
    backgroundColor: Colors.transparent, // Background tembus pandang agar sudut membulatnya terlihat
    builder: (context) {
      return Container(
        padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 34), // Padding sesuai desain (ada 34 di bawah)
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)), // Membulat di atas saja
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Agar tingginya nge-pas sama isi konten
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. GAMBAR BESAR
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 300, // Tinggi gambar besar
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 2. JUDUL
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 3. DESKRIPSI
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.greyDark,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 4. HARGA
            Text(
              price,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 5. TOMBOL TAMBAH KE KERANJANG
            HapHapButton(
              text: 'Tambahkan ke Keranjang - $price',
              isExpanded: true,
              onPressed: () {
                onAddToCart();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}