import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/data/services/auth_service.dart';
import 'package:haphap_fe/presentation/widgets/inputs/text_fields.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isAgreed = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nama tidak boleh kosong.';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nomor HP tidak boleh kosong.';
    final phoneRegex = RegExp(r'^[0-9+\-\s]{8,15}$');
    if (!phoneRegex.hasMatch(value.trim())) return 'Format nomor HP tidak valid.';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email tidak boleh kosong.';
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Format email tidak valid.';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Kata sandi tidak boleh kosong.';
    if (value.length < 8) return 'Kata sandi minimal 8 karakter.';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Konfirmasi kata sandi tidak boleh kosong.';
    if (value != _passwordController.text) return 'Kata sandi tidak cocok.';
    return null;
  }

  Future<void> _handleRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_isAgreed) {
      _showErrorSnackbar('Kamu harus menyetujui Syarat & Ketentuan terlebih dahulu.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
      );

      if (!mounted) return;

      if (!response.success) {
        _showErrorSnackbar(response.message);
        return;
      }

      _showSuccessSnackbar('Akun berhasil dibuat! Silakan masuk.');
      context.pop();

    } on ApiException catch (e) {
      if (!mounted) return;
      _showErrorSnackbar(e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

// TODO : add component

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                Padding(
                  padding: const EdgeInsets.only(top: 70, left: 24, right: 24),
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
                      const Text(
                        'Buat akun HapHapmu dan mulai selamatkan makanan bareng kami!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF70340C),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 59),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HapHapTextField(
                            labelText: 'Nama Lengkap',
                            hintText: 'John Doe',
                            controller: _nameController,
                            isPassword: false,
                            isRequired: true,
                            validator: _validateName,
                          ),

                          const SizedBox(height: 32),

                          HapHapTextField(
                            labelText: 'Nomor HP',
                            hintText: '08123456789',
                            controller: _phoneController,
                            isPassword: false,
                            isRequired: true,
                            validator: _validatePhone,
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 32),

                          HapHapTextField(
                            labelText: 'Alamat Email',
                            hintText: 'PuyPuy@gmail.com',
                            controller: _emailController,
                            isPassword: false,
                            isRequired: true,
                            validator: _validateEmail,
                          ),

                          const SizedBox(height: 32),

                          HapHapTextField(
                            labelText: 'Kata Sandi',
                            hintText: 'Min. 8 karakter',
                            controller: _passwordController,
                            isPassword: true,
                            isRequired: true,
                            validator: _validatePassword,
                          ),

                          const SizedBox(height: 32),

                          HapHapTextField(
                            labelText: 'Konfirmasi Kata Sandi',
                            hintText: 'Ulangi kata sandi',
                            controller: _confirmPasswordController,
                            isPassword: true,
                            isRequired: true,
                            validator: _validateConfirmPassword,
                          ),

                          const SizedBox(height: 16),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  padding: const EdgeInsets.only(top: 2),
                                  child: RichText(
                                    text: const TextSpan(
                                      text: 'Saya telah membaca dan menyetujui ',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 14,
                                        color: AppColors.black,
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

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                                disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : const Text(
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

                          Center(
                            child: GestureDetector(
                              onTap: () => context.pop(),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}