import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Wajib import ini buat navigasi
import 'package:haphap_fe/core/router/app_routes.dart'; // Wajib import ini buat AppRoutes
import 'package:haphap_fe/core/constants/app_icons.dart';
import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/data/models/merchant_model.dart';
import 'package:haphap_fe/data/services/merchant_service.dart';

// --- IMPORT KOMPONEN LEGO DARI PLAYGROUND KAMU ---
import 'package:haphap_fe/presentation/widgets/inputs/search_bar.dart';
import 'package:haphap_fe/presentation/widgets/buttons/beranda_category.dart';
import 'package:haphap_fe/presentation/widgets/cards/restaurant_card.dart';

class JelajahPage extends StatefulWidget {
  final String? initialCategory;

  const JelajahPage({
    super.key,
    this.initialCategory,
  });

  @override
  State<JelajahPage> createState() => _JelajahPageState();
}

class _JelajahPageState extends State<JelajahPage> {
  final TextEditingController _searchController = TextEditingController();
  
  int _selectedCategoryIndex = 0;
  
  final List<String> _categories = [
    'All', 
    'Bakery',
    'Restoran', 
    'Kafe', 
    'Grocery',
    'Jajanan',
    'Dessert',
  ];

  final Map<String, String> _categoryEnumMap = {
    'Bakery': 'ROTI',
    'Restoran': 'RESTORAN',
    'Kafe': 'KAFE',
    'Grocery': 'KEBUTUHAN',
    'Jajanan': 'JAJANAN',
    'Dessert': 'PENUTUP',
  };

  // --- STATE UNTUK DATA DARI API ---
  List<MerchantModel> _merchants = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _applyInitialCategory();
    _fetchMerchants();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(covariant JelajahPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != oldWidget.initialCategory) {
      _applyInitialCategory();
    }
  }

  void _applyInitialCategory() {
    if (widget.initialCategory != null) {
      // Find the UI label that matches the backend enum passed in query
      final entry = _categoryEnumMap.entries.firstWhere(
        (e) => e.value == widget.initialCategory,
        orElse: () => const MapEntry('All', ''),
      );
      
      final index = _categories.indexOf(entry.key);
      if (index != -1) {
        setState(() {
          _selectedCategoryIndex = index;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  Future<void> _fetchMerchants() async {
    try {
      final merchants = await MerchantService.fetchAll();
      if (!mounted) return;
      setState(() {
        _merchants = merchants;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal memuat data merchant. Silakan coba lagi.';
        _isLoading = false;
      });
    }
  }

  /// Filter merchants berdasarkan kategori dan search query
  List<MerchantModel> get _filteredMerchants {
    List<MerchantModel> result = _merchants;

    // Filter by category (index 0 = 'All', skip filtering)
    if (_selectedCategoryIndex > 0) {
      final selectedCategoryLabel = _categories[_selectedCategoryIndex];
      final backendEnum = _categoryEnumMap[selectedCategoryLabel];
      
      if (backendEnum != null) {
        result = result.where((merchant) {
          return merchant.categories.contains(backendEnum);
        }).toList();
      }
    }

    // Filter by search query
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((merchant) {
        return merchant.merchantName.toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), 
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: HapHapSearchBar(
                hintText: 'Mau makan apa hari ini?',
                prefixIconPath: AppIcons.magnifying_glass,
                controller: _searchController,
              ),
            ),
            
            const SizedBox(height: 16), 
            
            // 2. CATEGORY PILLS
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: List.generate(_categories.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: HapHapCategoryPill(
                      label: _categories[index],
                      isSelected: _selectedCategoryIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                    ),
                  );
                }),
              ),
            ),
            
            const SizedBox(height: 16), 

            // 3. RESTAURANT LIST (dynamic dari API)
            Expanded(
              child: _buildMerchantList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMerchantList() {
    // --- LOADING STATE ---
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    // --- ERROR STATE ---
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.greyLight),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.greyDark, fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _fetchMerchants();
                },
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // --- EMPTY STATE ---
    final filtered = _filteredMerchants;
    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.storefront_outlined, size: 48, color: AppColors.greyLight),
              const SizedBox(height: 16),
              Text(
                _searchController.text.trim().isNotEmpty || _selectedCategoryIndex > 0
                    ? 'Tidak ada merchant yang sesuai dengan pencarian kamu.'
                    : 'Belum ada merchant yang tersedia saat ini.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.greyDark, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    // --- SUCCESS STATE ---
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemCount: filtered.length + 1, // +1 for bottom spacing
      itemBuilder: (context, index) {
        if (index == filtered.length) {
          return const SizedBox(height: 40);
        }

        final merchant = filtered[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0), 
          child: GestureDetector(
            onTap: () {
              context.push(
                '${AppRoutes.detailRestoran}/${merchant.merchantId}',
              );
            },
            child: HapHapRestaurantCard(
              imageUrl: merchant.avatar ?? '',
              distanceTime: merchant.address ?? '',
              restaurantName: merchant.merchantName,
              ratingText: merchant.rating != null
                  ? '${merchant.rating!.toStringAsFixed(1)} rating'
                  : 'Belum ada rating',
            ),
          ),
        );
      },
    );
  }
}