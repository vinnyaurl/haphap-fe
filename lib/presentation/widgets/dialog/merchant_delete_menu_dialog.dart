import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/data/services/menu_service.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart'; // Import HapHapButton

class HapHapDeleteMenuDialog extends StatefulWidget {
  final String menuName;
  final String menuItemId;

  const HapHapDeleteMenuDialog({
    super.key,
    required this.menuName,
    required this.menuItemId,
  });

  @override
  State<HapHapDeleteMenuDialog> createState() => _HapHapDeleteMenuDialogState();
}

class _HapHapDeleteMenuDialogState extends State<HapHapDeleteMenuDialog> {
  bool _isDeleting = false;

  Future<void> _onDelete() async {
    setState(() => _isDeleting = true);

    try {
      await MenuService.deleteMenu(widget.menuItemId);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${widget.menuName}" berhasil dihapus.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // Return true to signal success
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus menu. Coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
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
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Hapus Menu?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Yakin mau hapus "${widget.menuName}"? Data yang sudah dihapus tidak bisa dikembalikan.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.greyDark),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: HapHapButton(
                    text: 'Batal',
                    isOutline: true, // Asumsi ada parameter ini di tombolmu
                    onPressed: _isDeleting ? () {} : () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _isDeleting
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.red,
                              strokeWidth: 2.5,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Tombol bahaya
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _onDelete,
                          child: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}