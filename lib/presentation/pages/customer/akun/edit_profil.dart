import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

// --- IMPORT KOMPONEN LEGO KITA ---
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/presentation/widgets/inputs/text_fields.dart'; // Sesuaikan path HapHapTextField
import 'package:haphap_fe/presentation/widgets/buttons/button.dart'; // Sesuaikan path HapHapButton

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  // Controller untuk mengisi nilai awal (default) pada input field
  late TextEditingController _namaController;
  late TextEditingController _teleponController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    // Mengisi data awal sesuai desain Figma
    _namaController = TextEditingController(text: 'PuyPuy');
    _teleponController = TextEditingController(text: '+6286767676767');
    _emailController = TextEditingController(text: 'puypuy@haphap.com');
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              
              // 1. HEADER
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: HapHapPageHeader(
                  title: 'Edit Profil',
                ),
              ),
              
              const SizedBox(height: 24),

              // 2. FOTO PROFIL DENGAN ICON KAMERA
              _buildProfilePicture(),

              const SizedBox(height: 24),

              // 3. FORM INPUT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    HapHapTextField(
                      labelText: 'Nama Lengkap',
                      hintText: 'Masukkan nama lengkap',
                      controller: _namaController,
                      isRequired: true, // Memunculkan bintang merah
                    ),
                    
                    const SizedBox(height: 32), // Jarak 32px sesuai garis pink di desain
                    
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
              
              const SizedBox(height: 100), // Jarak napas sebelum bottom bar
            ],
          ),
        ),
      ),
      
      // 4. TOMBOL SIMPAN DI BAWAH
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  // ===========================================================================
  // WIDGET HELPERS
  // ===========================================================================

  Widget _buildProfilePicture() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Foto Utama
        ClipRRect(
          borderRadius: BorderRadius.circular(60), // Setengah dari lebar/tinggi
          child: Image.network(
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80', // Dummy avatar
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        
        // Icon Kamera Bulat (di pojok kanan bawah foto)
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              print('Ganti foto profil ditekan');
            },
            child: Container(
              padding: const EdgeInsets.all(6), // Jarak icon ke border
              decoration: BoxDecoration(
                color: AppColors.primary, // Background oren
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white, // Border putih memisahkan icon dengan foto
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

  Widget _buildBottomButton() {
    // Menghindari tombol nabrak home indicator iPhone
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
        heightFactor: 1, // Biar button tidak melar penuh ke container
        child: HapHapButton(
          text: 'Simpan',
          size: HapHapButtonSize.large,
          onPressed: () {
            // Logika menyimpan data
            print('Menyimpan Profil: ${_namaController.text}');
            context.pop(); // Kembali ke halaman Akun setelah simpan
          },
        ),
      ),
    );
  }
}