import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/pages/auth/login_screen.dart';
import 'package:haphap_fe/presentation/widgets/buttons/onboarding_buttons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const List<OnboardingData> _pages = [
    OnboardingData(
      imagePath: 'assets/images/onboarding-page1.png',
      backgroundColor: AppColors.primary,
      titleParts: [
        TextPart('Makan ', false),
        TextPart('Mewah', true),
        TextPart(', Harga ', false),
        TextPart('Murah', true),
        TextPart('!', false),
      ],
      description:
          'Nikmati makanan enak dari restoran dan warung pilihanmu dengan diskon besar-besaran tiap harinya!',
    ),
    OnboardingData(
      imagePath: 'assets/images/onboarding-page2.png',
      backgroundColor: AppColors.primary,
      titleParts: [
        TextPart('Jadi ', false),
        TextPart('Pahlawan', true),
        TextPart(' Modal ', false),
        TextPart('Ngunyah', true),
        TextPart('!', false),
      ],
      description:
          'Setiap porsi yang kamu beli, menyelamatkan makanan enak yang terbuang sia-sia.',
    ),
    OnboardingData(
      imagePath: 'assets/images/onboarding-page3.png',
      backgroundColor: AppColors.primary,
      titleParts: [
        TextPart('Pesan,', false),
        TextPart(' Ambil,', false),
        TextPart(' Sikat', true),
        TextPart('!', false),
      ],
      description:
          'Pesan di aplikasi, tunjukin kodenya ke kasir, dan bawa pulang makananmu sendiri. Gampang, cepat, sikat!',
    ),
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isFinishing = false;
  bool _isLoading = false;

  double? get _progress {
    if (_isLoading) return null;
    if (_isFinishing) return 1.0;
    return _currentPage / _pages.length;
  }

  bool get _isLastPage => _currentPage == _pages.length - 1;

  Future<void> _finishOnboarding() async {
    if (_isLoading || _isFinishing) return;

    setState(() => _isFinishing = true);
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _isFinishing = false;
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _onSkip() {
    if (_isLoading || _isFinishing) return;
    _finishOnboarding();
  }

  void _onNext() {
    if (_isLoading || _isFinishing) return;

    if (!_isLastPage) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      backgroundColor: page.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 83, right: 24),
                child: HapHapSkipButton(
                  onPressed: _onSkip,
                  isWhiteVariant: page.backgroundColor == AppColors.primary,
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: SizedBox(
                      height: 402,
                      child: Image.asset(
                        _pages[index].imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),

            Container(
              width: double.infinity,
              height: 358,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: page.titleParts.map((part) {
                        return TextSpan(
                          text: part.text,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Plus Jakarta Sans',
                            color: part.isHighlighted
                                ? AppColors.primary
                                : AppColors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    page.description,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Plus Jakarta Sans',
                      color: AppColors.greyLight,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(top: 32, bottom: 36),
                    child: Center(
                      child: HapHapOnboardingNextButton(
                        progress: _progress,
                        size: 128.0,
                        onPressed: _onNext,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------------

class OnboardingData {
  final String imagePath;
  final Color backgroundColor;
  final List<TextPart> titleParts;
  final String description;

  const OnboardingData({
    required this.imagePath,
    required this.backgroundColor,
    required this.titleParts,
    required this.description,
  });
}

class TextPart {
  final String text;
  final bool isHighlighted;

  const TextPart(this.text, this.isHighlighted);
}