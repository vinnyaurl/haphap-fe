import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'dart:math' as math;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      imagePath: 'assets/images/onboarding-page1.png',
      backgroundColor: const Color(0xFFFAF4DF), // cream
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
    // Placeholder for slide 2 & 3 — will be added later
  ];

  void _onSkip() {
    // TODO: Navigate to login/register
    print('skip tapped');
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // TODO: Navigate to login/register
      print('onboarding done');
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
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 24, right: 24),
                child: GestureDetector(
                  onTap: _onSkip,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lewati',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 24,
                        color: AppColors.primary,
                        weight: 600,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Illustration
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Image.asset(
                      _pages[index].imagePath,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
            ),

            // Bottom white card
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with highlighted words
                  RichText(
                    text: TextSpan(
                      children: page.titleParts.map((part) {
                        return TextSpan(
                          text: part.text,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: part.isHighlighted
                                ? AppColors.primary
                                : AppColors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Text(
                    page.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.greyLight,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Dot indicator + Next button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dot indicators
                      Row(
                        children: List.generate(
                          _pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            width: _currentPage == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppColors.primary
                                  : AppColors.greyLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      // Circular progress next button
                      GestureDetector(
                        onTap: _onNext,
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Progress arc
                              CustomPaint(
                                size: const Size(64, 64),
                                painter: _ArcPainter(
                                  progress:
                                      (_currentPage + 1) / _pages.length,
                                ),
                              ),
                              // Inner circle button
                              Container(
                                width: 52,
                                height: 52,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.white,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

// --- Data model ---
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

// --- Arc painter for progress circle ---
class _ArcPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0

  _ArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.25)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Background track
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2 - 2,
      paint,
    );

    // Progress arc
    paint.color = AppColors.primary;
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2 - 2,
      ),
      -math.pi / 2, // start from top
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}