import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/presentation/widgets/inputs/text_fields.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';
import 'package:haphap_fe/data/services/merchant_service.dart';

class EditProfilMerchantPage extends StatefulWidget {
  const EditProfilMerchantPage({super.key});

  @override
  State<EditProfilMerchantPage> createState() => _EditProfilMerchantPageState();
}

class _EditProfilMerchantPageState extends State<EditProfilMerchantPage> {
  late TextEditingController _namaTokoController;
  late TextEditingController _teleponController;
  late TextEditingController _alamatController;
  late TextEditingController _deskripsiController;
  late TextEditingController _jamBukaController;
  late TextEditingController _jamTutupController;

  bool _isLoading = true;
  bool _isSaving = false;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _namaTokoController = TextEditingController();
    _teleponController = TextEditingController();
    _alamatController = TextEditingController();
    _deskripsiController = TextEditingController();
    _jamBukaController = TextEditingController();
    _jamTutupController = TextEditingController();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final merchant = await MerchantService.getMe();
      if (!mounted) return;
      setState(() {
        _namaTokoController.text = merchant.merchantName;
        _teleponController.text = merchant.phone ?? '';
        _alamatController.text = merchant.address ?? '';
        _deskripsiController.text = merchant.description ?? '';
        _jamBukaController.text = merchant.openTime ?? '';
        _jamTutupController.text = merchant.closeTime ?? '';
        _avatarUrl = merchant.avatar;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat profil toko: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      await MerchantService.updateMe({
        'merchantName': _namaTokoController.text,
        'phone': _teleponController.text,
        'address': _alamatController.text,
        'description': _deskripsiController.text,
        'openTime': _jamBukaController.text,
        'closeTime': _jamTutupController.text,
      });

      if (!mounted) return;
      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil toko berhasil diperbarui!')),
      );
      
      context.pop(); 
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan profil: $e')),
      );
    }
  }

  @override
  void dispose() {
    _namaTokoController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    _deskripsiController.dispose();
    _jamBukaController.dispose();
    _jamTutupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: HapHapPageHeader(
                  title: 'Edit Profil Toko',
                ),
              ),
              
              const SizedBox(height: 24),

              _buildProfilePicture(),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    HapHapTextField(
                      labelText: 'Nama Toko',
                      hintText: 'Masukkan nama toko',
                      controller: _namaTokoController,
                      isRequired: true,
                    ),
                    const SizedBox(height: 32),
                    HapHapTextField(
                      labelText: 'Nomor Telepon',
                      hintText: 'Masukkan nomor telepon',
                      controller: _teleponController,
                      isRequired: true,
                    ),
                    const SizedBox(height: 32),
                    HapHapTextField(
                      labelText: 'Alamat',
                      hintText: 'Masukkan alamat lengkap',
                      controller: _alamatController,
                    ),
                    const SizedBox(height: 32),
                    HapHapTextField(
                      labelText: 'Deskripsi',
                      hintText: 'Deskripsi toko singkat',
                      controller: _deskripsiController,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: HapHapTextField(
                            labelText: 'Jam Buka',
                            hintText: 'Contoh: 08:00',
                            controller: _jamBukaController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: HapHapTextField(
                            labelText: 'Jam Tutup',
                            hintText: 'Contoh: 20:00',
                            controller: _jamTutupController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    SizedBox(
                      width: double.infinity,
                      child: HapHapButton(
                        text: 'Simpan',
                        size: HapHapButtonSize.large,
                        isLoading: _isSaving,
                        onPressed: _saveProfile,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFD9D9D9), 
            border: Border.all(color: AppColors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            image: _avatarUrl != null && _avatarUrl!.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(_avatarUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: _avatarUrl == null || _avatarUrl!.isEmpty
              ? const Icon(Icons.store, size: 50, color: Colors.grey)
              : null,
        ),
        
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 16,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
