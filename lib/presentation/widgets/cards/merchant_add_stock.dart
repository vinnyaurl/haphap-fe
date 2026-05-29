import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart'; // Import HapHapButton

class HapHapMerchantAddStockCard extends StatelessWidget {
  final String imagePath;

  const HapHapMerchantAddStockCard({
    super.key,
    required this.imagePath,
  });

  // --- FUNGSI UNTUK MENAMPILKAN POP-UP DIALOG ---
  void _showAddStockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const _AddStockDialog(); 
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetector agar kartu bisa diklik
    return GestureDetector(
      onTap: () => _showAddStockDialog(context),
      child: Container(
        width: 354, // Lebar standar card kita
        height: 120, 
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary, // Border oren sesuai desain
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // 1. Teks dan Icon (+) persis di tengah
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
                    'Update your stock!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // 2. Gambar Karakter di Kanan Bawah
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

// ============================================================================
// WIDGET KHUSUS UNTUK POP-UP DIALOG AKTIFKAN MENU
// (Dibuat Stateful agar Dropdown dan Text Input bisa berubah)
// ============================================================================

class _AddStockDialog extends StatefulWidget {
  const _AddStockDialog();

  @override
  State<_AddStockDialog> createState() => _AddStockDialogState();
}

class _AddStockDialogState extends State<_AddStockDialog> {
  String? _selectedMenu = 'Szechuan Chicken Bowl'; 
  final TextEditingController _stockController = TextEditingController();

  @override
  void dispose() {
    _stockController.dispose();
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
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul
            const Text(
              'Aktifkan Menu',
              style: TextStyle(
                fontSize: 20, // Diperbesar sedikit sesuai desain
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 24),

            // LABEL 1: Dropdown Pilih Menu
            const Text(
              'Pilih Menu',
              style: TextStyle(
                fontSize: 14, // Diperbesar agar sesuai desain
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            
            // KOTAK DROPDOWN (Tinggi dikunci 48)
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
                  value: _selectedMenu,
                  isExpanded: true, 
                  dropdownColor: AppColors.white, // Menghilangkan background abu di list
                  focusColor: Colors.transparent, // Menghilangkan background abu saat diklik
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.black),
                  items: <String>[
                    'Szechuan Chicken Bowl', 
                    'Blackpepper Chicken Bowl', 
                    'Salted Egg Chicken Bowl'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 14, color: AppColors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedMenu = newValue;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // LABEL 2: Input Tambah Stok
            const Text(
              'Tambahkan Stok',
              style: TextStyle(
                fontSize: 14, // Diperbesar agar sesuai desain
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            
            // KOTAK TEXTFIELD (Tinggi dikunci 48 agar sama dengan dropdown)
            SizedBox(
              height: 48,
              child: TextField(
                controller: _stockController,
                keyboardType: TextInputType.number, 
                textAlignVertical: TextAlignVertical.center, // Bikin teks persis di tengah secara vertikal
                style: const TextStyle(fontSize: 14, color: AppColors.black),
                decoration: InputDecoration(
                  hintText: '10',
                  hintStyle: const TextStyle(color: AppColors.greyLight, fontSize: 14),
                  // Padding vertical di-nol-kan karena sudah pakai textAlignVertical & SizedBox height
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Tombol Simpan
            Center(
              child: HapHapButton(
                text: 'Simpan',
                size: HapHapButtonSize.large, 
                onPressed: () {
                  print("Menu $_selectedMenu ditambahkan stoknya: ${_stockController.text}");
                  Navigator.pop(context); 
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}