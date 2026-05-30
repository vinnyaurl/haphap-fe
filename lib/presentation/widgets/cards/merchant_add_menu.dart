import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart'; // Import HapHapButton

class HapHapAddMenuDialog extends StatefulWidget {
  const HapHapAddMenuDialog({super.key});

  @override
  State<HapHapAddMenuDialog> createState() => _HapHapAddMenuDialogState();
}

class _HapHapAddMenuDialogState extends State<HapHapAddMenuDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  // Widget Helper untuk membungkus Label + TextField
  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(fontSize: 14, color: AppColors.black),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.greyLight, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: AppColors.primary, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16), // Spasi antar input
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView( // Agar tidak overflow saat keyboard muncul
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Pop-up
              const Text(
                'Tambah Menu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 24),

              // Form Inputs
              _buildInputField(
                label: 'Nama Menu',
                hint: 'Szechuan Chicken Bowl',
                controller: _nameController,
              ),
              _buildInputField(
                label: 'Harga',
                hint: '25.000',
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),
              _buildInputField(
                label: 'Deskripsi',
                hint: 'Nasi + Ayam + Saus Szechuan',
                controller: _descController,
              ),
              _buildInputField(
                label: 'Gambar', // Typo di Figma ("Harga") diperbaiki di sini
                hint: 'Pilih Gambar',
                controller: _imageController,
              ),

              const SizedBox(height: 16),

              // Tombol Simpan
              Center(
                child: HapHapButton(
                  text: 'Simpan',
                  size: HapHapButtonSize.large,
                  onPressed: () {
                    print('Simpan menu: ${_nameController.text}');
                    Navigator.pop(context); // Tutup dialog
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