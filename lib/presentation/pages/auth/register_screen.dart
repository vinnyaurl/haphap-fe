import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/inputs/text_fields.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isAgreed = false; 

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- HEADER TEXT ---
                Padding(
                  padding: const EdgeInsets.only(top: 132, left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Waktunya Ngunyah!',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 32,
                          fontWeight: FontWeight.bold, 
                          color: AppColors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Center(
                        child: const Text(
                          'Masuk ke akun HapHapmu sekarang dan jadi pahlawan buat bumi dan perut laparmu.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF70340C),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 59),

                // --- FORM CARD (KOTAK PUTIH) ---
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Field Email
                        HapHapTextField(
                          labelText: 'Alamat Email',
                          hintText: 'PuyPuy@gmail.com',
                          controller: _emailController,
                          isPassword: false,
                          isRequired: true,
                        ),
                        
                        const SizedBox(height: 32),

                        // Field Kata Sandi
                        HapHapTextField(
                          labelText: 'Kata Sandi',
                          hintText: 'Password',
                          controller: _passwordController,
                          isPassword: true,
                          isRequired: true,
                        ),

                        const SizedBox(height: 32),

                        //  Field Konfirmasi Kata Sandi
                        HapHapTextField(
                          labelText: 'Konfirmasi Kata Sandi',
                          hintText: 'Password',
                          controller: _confirmPasswordController,
                          isPassword: true,
                          isRequired: true,
                        ),

                        const SizedBox(height: 16),

                        //  Persetujuan Syarat & Ketentuan
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start, // Agar checkbox sejajar dengan baris pertama teks jika teksnya panjang
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _isAgreed,
                                onChanged: (value) {
                                  setState(() => _isAgreed = value ?? false);
                                },
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: const BorderSide(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2), // Menyelaraskan teks dengan checkbox
                                child: RichText(
                                  text: const TextSpan(
                                    text: 'Saya telah membaca dan menyetujui ',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 14,
                                      color: AppColors.black,
                                      height: 1.4,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Syarat & Ketentuan',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        //  Tombol Daftar
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Validasi dasar bisa ditambahkan di sini
                              // if (_passwordController.text != _confirmPasswordController.text) { ... }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26), 
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Daftar',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),
                        const SizedBox(height: 32),

                        // Divider "Atau Lanjut Dengan"
                        Row(
                          children: [
                            Expanded(child: Divider(color: AppColors.greyLight)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Atau Lanjut Dengan',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14,
                                  color: AppColors.greyDark,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: AppColors.greyLight)),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Tombol Google
                        Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                // TODO: Handle Google Register
                              },
                              icon: Image.asset(
                                'assets/images/google_logo.png', 
                                width: 40,                
                                height: 40,               
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 8. Footer (Sudah punya akun)
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Navigasi kembali ke Login
                              Navigator.pop(context);
                            },
                            child: RichText(
                              text: const TextSpan(
                                text: 'Sudah punya akun? ',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600, 
                                  color: AppColors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Masuk',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SafeArea(
                          top: false,
                          child: SizedBox(height: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}