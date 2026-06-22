import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/presentation/widgets/inputs/text_fields.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';
import 'package:haphap_fe/data/services/user_service.dart';

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  late TextEditingController _namaController;
  late TextEditingController _teleponController;
  late TextEditingController _emailController;

  bool _isLoading = true;
  bool _isSaving = false;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _teleponController = TextEditingController();
    _emailController = TextEditingController();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final user = await UserService.getMe();
      if (!mounted) return;
      setState(() {
        _namaController.text = user.name;
        _teleponController.text = user.phone ?? '';
        _emailController.text = user.email;
        _avatarUrl = user.avatar;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat profil: $e')),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _teleponController.dispose();
    _emailController.dispose();
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
                  title: 'Edit Profil',
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
                      labelText: 'Nama Lengkap',
                      hintText: 'Masukkan nama lengkap',
                      controller: _namaController,
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
                      labelText: 'Alamat Email',
                      hintText: 'Masukkan alamat email',
                      controller: _emailController,
                      isRequired: true,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildProfilePicture() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: _avatarUrl != null && _avatarUrl!.isNotEmpty
              ? Image.network(
                  _avatarUrl!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholderAvatar(),
                )
              : _buildPlaceholderAvatar(),
        ),
        
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              print('Ganti foto profil ditekan');
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderAvatar() {
    return Container(
      width: 100,
      height: 100,
      color: AppColors.primary.withOpacity(0.2),
      child: const Icon(Icons.person, size: 50, color: AppColors.primary),
    );
  }

  Widget _buildBottomButton() {
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;
    
    return Container(
      padding: EdgeInsets.only(
        left: 24, 
        right: 24, 
        top: 16, 
        bottom: bottomSafeArea > 0 ? bottomSafeArea : 24,
      ),
      color: const Color(0xFFF9F9F9),
      child: Center(
        heightFactor: 1,
        child: _isSaving
            ? const CircularProgressIndicator(color: AppColors.primary)
            : HapHapButton(
                text: 'Simpan',
                size: HapHapButtonSize.large,
                onPressed: () async {
                  setState(() => _isSaving = true);
                  try {
                    await UserService.updateMe(
                      name: _namaController.text,
                      phone: _teleponController.text,
                      email: _emailController.text,
                    );
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profil berhasil diperbarui')),
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menyimpan: $e')),
                    );
                    setState(() => _isSaving = false);
                  }
                },
              ),
      ),
    );
  }
}