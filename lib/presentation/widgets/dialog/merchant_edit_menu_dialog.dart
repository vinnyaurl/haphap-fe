import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';

class HapHapEditMenuDialog extends StatefulWidget {
  final String initialName;
  final String initialPrice;
  final String initialDesc;

  const HapHapEditMenuDialog({
    super.key,
    required this.initialName,
    required this.initialPrice,
    required this.initialDesc,
  });

  @override
  State<HapHapEditMenuDialog> createState() => _HapHapEditMenuDialogState();
}

class _HapHapEditMenuDialogState extends State<HapHapEditMenuDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descController;
  final TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Isi otomatis data lama ke text field saat pop up muncul
    _nameController = TextEditingController(text: widget.initialName);
    
    // Hilangkan "Rp " dan titik agar murni angka saja saat diedit
    String cleanPrice = widget.initialPrice.replaceAll(RegExp(r'[^0-9]'), '');
    _priceController = TextEditingController(text: cleanPrice);
    
    _descController = TextEditingController(text: widget.initialDesc);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _imageController.dispose();
    super.dispose();
  }

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
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
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
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Menu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const SizedBox(height: 24),

              _buildInputField(label: 'Nama Menu', hint: 'Masukkan nama...', controller: _nameController),
              _buildInputField(label: 'Harga', hint: '0', controller: _priceController, keyboardType: TextInputType.number),
              _buildInputField(label: 'Deskripsi', hint: 'Masukkan deskripsi...', controller: _descController),
              _buildInputField(label: 'Gambar', hint: 'Pilih Gambar Baru', controller: _imageController),

              const SizedBox(height: 16),
              Center(
                child: HapHapButton(
                  text: 'Simpan Perubahan',
                  size: HapHapButtonSize.large,
                  onPressed: () {
                    print('Update menu menjadi: ${_nameController.text}');
                    Navigator.pop(context);
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