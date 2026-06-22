import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/data/models/merchant_model.dart';
import 'package:haphap_fe/data/services/menu_service.dart';
import 'package:haphap_fe/data/services/surplus_service.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';
import 'package:haphap_fe/presentation/widgets/inputs/text_fields.dart';
import 'package:haphap_fe/presentation/widgets/feedback/app_snackbar.dart';

class HapHapMerchantAddStockCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onStockAdded;

  const HapHapMerchantAddStockCard({
    super.key,
    required this.imagePath,
    this.onStockAdded,
  });

  void _showAddStockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _AddStockDialog(onStockAdded: onStockAdded);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddStockDialog(context),
      child: Container(
        width: 354,
        height: 120, 
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary, 
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add,
                    color: AppColors.primary,
                    size: 36,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Aktifkan menu kamu disini!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              right: 16,
              bottom: 0,
              child: Image.asset(
                imagePath,
                height: 90, 
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddStockDialog extends StatefulWidget {
  final VoidCallback? onStockAdded;

  const _AddStockDialog({this.onStockAdded});

  @override
  State<_AddStockDialog> createState() => _AddStockDialogState();
}

class _AddStockDialogState extends State<_AddStockDialog> {
  List<MenuItemModel> _menuItems = [];
  MenuItemModel? _selectedMenuItem;
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _discountPriceController = TextEditingController();
  
  bool _isLoadingMenus = true;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMenus();
  }

  Future<void> _fetchMenus() async {
    try {
      final items = await MenuService.getAllMenus();
      if (!mounted) return;
      final activeItems = items.where((m) => m.isActive).toList();
      setState(() {
        _menuItems = activeItems;
        _isLoadingMenus = false;
        if (activeItems.isNotEmpty) {
          _selectedMenuItem = activeItems.first;
        }
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingMenus = false;
        _errorMessage = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingMenus = false;
        _errorMessage = 'Gagal memuat daftar menu.';
      });
    }
  }

  Future<void> _onSave() async {
    if (_selectedMenuItem == null) return;

    final stock = int.tryParse(_stockController.text.trim());
    final discountPrice = int.tryParse(_discountPriceController.text.trim());

    if (stock == null || stock < 1) {
      AppSnackbar.showError(context, 'Masukkan jumlah stok yang valid (minimal 1).');
      return;
    }

    if (discountPrice == null || discountPrice < 1) {
      AppSnackbar.showError(context, 'Masukkan harga diskon yang valid (minimal 1).');
      return;
    }

    setState(() => _isSaving = true);

    try {
      await SurplusService.create({
        'menuItemId': _selectedMenuItem!.menuItemId,
        'stock': stock,
        'discountPrice': discountPrice,
      });

      if (!mounted) return;
      Navigator.pop(context);

      AppSnackbar.showSuccess(context, '${_selectedMenuItem!.name} berhasil diaktifkan!');
      widget.onStockAdded?.call();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      AppSnackbar.showError(context, e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      AppSnackbar.showError(context, 'Gagal menyimpan. Coba lagi.');
    }
  }

  @override
  void dispose() {
    _stockController.dispose();
    _discountPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _isLoadingMenus
            ? const SizedBox(
                height: 120,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            : _errorMessage != null
                ? _buildErrorContent()
                : _buildFormContent(),
      ),
    );
  }

  Widget _buildErrorContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, size: 48, color: AppColors.greyDark),
        const SizedBox(height: 12),
        Text(
          _errorMessage!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.greyDark, fontSize: 14),
        ),
        const SizedBox(height: 16),
        HapHapButton(
          text: 'Tutup',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    if (_menuItems.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.restaurant_menu_outlined, size: 48, color: AppColors.greyDark),
          const SizedBox(height: 12),
          const Text(
            'Belum ada menu.\nTambahkan menu terlebih dahulu di halaman Menu.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.greyDark, fontSize: 14),
          ),
          const SizedBox(height: 16),
          HapHapButton(
            text: 'Tutup',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min, 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aktifkan Menu',
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 24),

        const Text(
          'Pilih Menu',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        
        Container(
          height: 48, 
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24), 
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedMenuItem?.menuItemId,
              isExpanded: true, 
              dropdownColor: AppColors.white,
              focusColor: Colors.transparent,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.black),
              items: _menuItems.map((MenuItemModel menu) {
                return DropdownMenuItem<String>(
                  value: menu.menuItemId,
                  child: Text(
                    menu.name,
                    style: const TextStyle(fontSize: 14, color: AppColors.black),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedMenuItem = _menuItems.firstWhere(
                    (m) => m.menuItemId == newValue,
                  );
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        HapHapTextField(
          labelText: 'Harga Diskon',
          hintText: _selectedMenuItem != null
              ? '${_selectedMenuItem!.originalPrice}'
              : '0',
          controller: _discountPriceController,
          keyboardType: TextInputType.number,
        ),

        const SizedBox(height: 16),

        HapHapTextField(
          labelText: 'Tambahkan Stok',
          hintText: '10',
          controller: _stockController,
          keyboardType: TextInputType.number,
        ),

        const SizedBox(height: 32),

        Center(
          child: _isSaving
              ? const CircularProgressIndicator(color: AppColors.primary)
              : HapHapButton(
                  text: 'Simpan',
                  size: HapHapButtonSize.large, 
                  onPressed: _onSave,
                ),
        ),
      ],
    );
  }
}