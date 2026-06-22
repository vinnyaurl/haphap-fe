import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';
import 'package:haphap_fe/presentation/widgets/inputs/text_fields.dart';
import 'package:haphap_fe/presentation/widgets/feedback/app_snackbar.dart';
import 'package:haphap_fe/data/services/menu_service.dart';

class HapHapAddMenuDialog extends StatefulWidget {
  const HapHapAddMenuDialog({super.key});

  @override
  State<HapHapAddMenuDialog> createState() => _HapHapAddMenuDialogState();
}

class _HapHapAddMenuDialogState extends State<HapHapAddMenuDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  XFile? _selectedImage;
  bool _isSaving = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, 'Tidak dapat mengakses galeri. Periksa izin aplikasi di pengaturan.');
    }
  }

  Future<void> _onSave() async {
    final name = _nameController.text.trim();
    final price = int.tryParse(_priceController.text.trim());
    final description = _descController.text.trim();

    if (name.isEmpty) {
      AppSnackbar.showError(context, 'Nama menu tidak boleh kosong.');
      return;
    }
    if (price == null || price < 1) {
      AppSnackbar.showError(context, 'Masukkan harga yang valid (minimal 1).');
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Satu request multipart/form-data: kirim data + gambar sekaligus
      await MenuService.createMenu(
        name: name,
        originalPrice: price,
        description: description.isNotEmpty ? description : null,
        imagePath: _selectedImage?.path,
      );

      if (!mounted) return;
      setState(() => _isSaving = false);

      AppSnackbar.showSuccess(context, '"$name" berhasil ditambahkan!');
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      AppSnackbar.showError(context, e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      AppSnackbar.showError(context, 'Gagal tambah menu. Coba lagi.');
    }
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
        HapHapTextField(
          labelText: label,
          hintText: hint,
          controller: controller,
          keyboardType: keyboardType,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gambar',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            child: _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      File(_selectedImage!.path),
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_photo_alternate_outlined,
                          size: 32, color: AppColors.primary),
                      SizedBox(height: 8),
                      Text(
                        'Pilih Gambar',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
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
                'Tambah Menu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 24),

              _buildInputField(
                label: 'Nama Menu',
                hint: 'Szechuan Chicken Bowl',
                controller: _nameController,
              ),
              _buildInputField(
                label: 'Harga',
                hint: '25000',
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),
              _buildInputField(
                label: 'Deskripsi',
                hint: 'Nasi + Ayam + Saus Szechuan',
                controller: _descController,
              ),
              _buildImagePicker(),

              const SizedBox(height: 16),

              Center(
                child: HapHapButton(
                  text: 'Simpan',
                  size: HapHapButtonSize.large,
                  isLoading: _isSaving,
                  onPressed: _onSave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}