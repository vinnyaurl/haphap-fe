import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/inputs/text_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        HapHapTextField(
                          labelText: 'Alamat Email',
                          hintText: 'PuyPuy@gmail.com',
                          controller: _emailController,
                          isPassword: false,
                          isRequired: true,
                        ),

                        const SizedBox(height: 32),

                        HapHapTextField(
                          labelText: 'Kata Sandi',
                          hintText: 'Password',
                          controller: _passwordController,
                          isPassword: true,
                          isRequired: true,
                        ),

                        const SizedBox(height: 16),

                        //  Ingat Saya & Lupa Password
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() => _rememberMe = value ?? false);
                                },
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: const BorderSide(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Ingat Saya',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                color: AppColors.black,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                // TODO: Navigasi Lupa Password
                              },
                              child: const Text(
                                'Lupa Password?',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        //  Tombol Masuk
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              // print('Email: ${_emailController.text}');
                              // print('Password: ${_passwordController.text}');
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
                              'Masuk',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

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
                                // TODO: Handle Google Login
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

                        //  Footer (Belum punya akun)
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Navigasi ke Register
                            },
                            child: RichText(
                              text: const TextSpan(
                                text: 'Baru di HapHap? ',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600, 
                                  color: AppColors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Daftar sekarang',
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