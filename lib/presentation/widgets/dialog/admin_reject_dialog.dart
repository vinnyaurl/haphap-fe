import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';

class AdminRejectDialog extends StatefulWidget {
  final Future<void> Function(String rejectNote) onSubmit;

  const AdminRejectDialog({super.key, required this.onSubmit});

  @override
  State<AdminRejectDialog> createState() => _AdminRejectDialogState();
}

class _AdminRejectDialogState extends State<AdminRejectDialog> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final note = _controller.text.trim();
    if (note.isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      await widget.onSubmit(note);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tolak Pengajuan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Berikan alasan penolakan agar pemohon dapat memperbaiki pendaftarannya.',
              style: TextStyle(fontSize: 14, color: AppColors.greyDark),
            ),

            const SizedBox(height: 20),

            const Text(
              'Catatan Penolakan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tuliskan alasan penolakan...',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.greyLight,
                ),
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppColors.greyLight.withValues(alpha: 0.6)),
                ),
              ),
            ),

            const SizedBox(height: 24),

            HapHapButton(
              text: 'Kirim Penolakan',
              isExpanded: true,
              isLoading: _isSubmitting,
              onPressed: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
