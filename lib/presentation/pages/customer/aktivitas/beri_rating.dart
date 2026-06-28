import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';
import 'package:haphap_fe/presentation/widgets/feedback/app_snackbar.dart';

class BeriRatingPage extends StatefulWidget {
  final String orderId;
  final String merchantId;
  final String merchantName;
  final String merchantAvatar;

  const BeriRatingPage({
    super.key,
    required this.orderId,
    required this.merchantId,
    required this.merchantName,
    required this.merchantAvatar,
  });

  @override
  State<BeriRatingPage> createState() => _BeriRatingPageState();
}

class _BeriRatingPageState extends State<BeriRatingPage> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  final List<String> _feedbackOptions = [
    'Rasa enak',
    'Porsi banyak',
    'Harga pas',
    'Kemasan rapi',
    'Sesuai ekspektasi',
  ];
  final Set<String> _selectedFeedback = {};
  bool _isLoading = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    if (_rating == 0) {
      AppSnackbar.showError(context, 'Pilih rating terlebih dahulu.');
      return;
    }

    final comment = _reviewController.text.trim();
    if (comment.isEmpty && _selectedFeedback.isEmpty) {
      AppSnackbar.showError(context, 'Tulis ulasan atau pilih ulasan cepat terlebih dahulu.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final quickFeedback = _selectedFeedback.join(', ');
      final finalComment = [
        if (quickFeedback.isNotEmpty) quickFeedback,
        if (comment.isNotEmpty) comment,
      ].join(' - ');

      await ApiClient.post('/reviews', {
        'orderId': widget.orderId,
        'merchantId': widget.merchantId,
        'rating': _rating,
        'comment': finalComment,
      });

      if (!mounted) return;
      AppSnackbar.showSuccess(context, 'Terima kasih atas ulasan kamu!');
      context.pop();
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, 'Gagal mengirim ulasan. Silakan coba lagi.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: HapHapPageHeader(
                title: 'Beri Rating',
                fontSize: 24,
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: widget.merchantAvatar.isNotEmpty
                          ? Image.network(
                              widget.merchantAvatar,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Text('🤠', style: TextStyle(fontSize: 64)),
                              ),
                            )
                          : const Center(
                              child: Text('🤠', style: TextStyle(fontSize: 64)),
                            ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Text(
                      widget.merchantName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _rating = index + 1;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              color: index < _rating ? Colors.amber : AppColors.greyLight,
                              size: 45,
                            ),
                          ),
                        );
                      }),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: _feedbackOptions.map((option) {
                        final isSelected = _selectedFeedback.contains(option);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedFeedback.remove(option);
                              } else {
                                _selectedFeedback.add(option);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.greyLight,
                              ),
                            ),
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppColors.primary : AppColors.greyDark,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary, width: 1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _reviewController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Tambahkan ulasan',
                          hintStyle: TextStyle(
                            color: AppColors.greyLight,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: HapHapButton(
                text: 'Simpan',
                isExpanded: true,
                isLoading: _isLoading,
                onPressed: _submitRating,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
