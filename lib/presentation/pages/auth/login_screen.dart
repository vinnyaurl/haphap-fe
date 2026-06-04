import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/core/router/app_routes.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/data/services/auth_service.dart';
import 'package:haphap_fe/presentation/widgets/inputs/text_fields.dart';
import 'package:haphap_fe/core/network/token_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Email tidak boleh kosong.';
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Format email tidak valid.';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Kata sandi tidak boleh kosong.';
    return null;
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (!response.success) {
        _showErrorSnackbar(response.message);
        return;
      }

      final token = response.data?.token;

      if (token != null && token.isNotEmpty) {
        await TokenManager.saveToken(token);
      } else {
        _showErrorSnackbar('Token tidak ditemukan dari server.');
        return;
      }

      context.go(AppRoutes.beranda);
      _showSuccessSnackbar('Login berhasil! Selamat datang.');
    } on ApiException catch (e) {
      if (!mounted) return;
      _showErrorSnackbar(e.message);
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackbar('Terjadi kesalahan saat menghubungi server.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      final idToken = await authService.signInWithGoogle();

      if (!mounted) return;

      if (idToken == null) {
        setState(() => _isLoading = false);
        return;
      }

      // TODO: add google in backend
      final response = await ApiClient.post('/auth/google', {
        'idToken': idToken,
      });

      if (!mounted) return;

      final data = response['data'];
      final message = response['message'];

      if (data != null && data['token'] != null) {
        final token = data['token'] as String;

        await TokenManager.saveToken(token);

        _showSuccessSnackbar('Login Google berhasil! Selamat datang.');

        if (!mounted)
          return;
        context.go(AppRoutes.beranda);
      } else {
        _showErrorSnackbar(message ?? 'Token tidak ditemukan dari server.');
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      _showErrorSnackbar(e.message);
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackbar('Terjadi kesalahan saat menghubungi server.');
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Masuk ke akun HapHapmu sekarang dan jadi pahlawan buat bumi dan perut laparmu.',
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
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            hintText: 'Password',
                            controller: _passwordController,
                            isPassword: true,
                            isRequired: true,
                            validator: _validatePassword,
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(
                                      () => _rememberMe = value ?? false,
                                    );
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
                                  // TODO: Navigate to Forgot Password screen
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

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                                disabledBackgroundColor: AppColors.primary
                                    .withOpacity(0.6),
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
                              Expanded(
                                child: Divider(color: AppColors.greyLight),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Atau Lanjut Dengan',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    color: AppColors.greyDark,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: AppColors.greyLight),
                              ),
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
                                onPressed: _isLoading
                                    ? null
                                    : _handleGoogleLogin,
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
                              onTap: () {
                                context.push(AppRoutes.register);
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
