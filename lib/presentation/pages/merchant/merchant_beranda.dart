import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/constants/app_icons.dart';
import 'package:haphap_fe/core/router/app_routes.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/beranda_merchant_category.dart';
import 'package:haphap_fe/presentation/widgets/cards/merchant_add_stock.dart';
import 'package:haphap_fe/presentation/widgets/cards/merchant_menu.dart';
import 'package:haphap_fe/presentation/widgets/cards/beranda_stats.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';
import 'package:haphap_fe/data/services/merchant_service.dart';
import 'package:haphap_fe/data/services/surplus_service.dart';
import 'package:haphap_fe/data/models/merchant_model.dart';
import 'package:haphap_fe/core/network/api_client.dart';

// ---------------------------------------------------------------------------
// Layout constants
// ---------------------------------------------------------------------------
class _BerandaMerchantLayout {
  // Hero section
  static const double heroTopPadding = 40; 
  static const double heroHorizontalPadding = 24;
  static const double heroTaglineToCards = 32;
  static const double heroRedBgBottomCut = 80;

  // Stats cards
  static const double statCardSpacing = 16;

  // Features & Active Menu sections
  static const double sectionHorizontalPadding = 24;
  static const double sectionTitleToContent = 16;
  static const double fiturToMenuAktif = 32;
  static const double menuAktifSpacing = 16;
  static const double categoryItemSpacing = 20;

  // Bottom padding 
  static const double bottomScrollPadding = 80;
}

// ---------------------------------------------------------------------------
// Content constants
// ---------------------------------------------------------------------------
class _BerandaMerchantContent {
  static const String statsIncomeTitle = 'Total Penghasilan';
  static const String statsIncomePrefix = 'Rp ';
  static const String statsSavedTitle = 'Berhasil Selamatin';
}

// ---------------------------------------------------------------------------
// Main page
// ---------------------------------------------------------------------------
class BerandaMerchantPage extends StatefulWidget {
  const BerandaMerchantPage({super.key});

  @override
  State<BerandaMerchantPage> createState() => _BerandaMerchantPageState();
}

class _BerandaMerchantPageState extends State<BerandaMerchantPage> { 
  MerchantDetailModel? _merchant;
  List<SurplusItemModel> _surplusItems = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isUnauthorized = false;

  // Stats dari API (totalRevenue & totalPortion tidak ada di MerchantDetailModel,
  // jadi kita parse langsung dari raw JSON)
  int _totalRevenue = 0;
  int _totalPortion = 0;
  String _createdAtLabel = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _isUnauthorized = false;
      });
    }

    try {
      // Fetch merchant profile (raw JSON untuk ambil totalRevenue & totalPortion)
      final rawJson = await ApiClient.get('/merchants/me');
      final merchantData = rawJson['data'] as Map<String, dynamic>? ?? {};
      
      final merchant = MerchantDetailModel.fromJson(merchantData);
      _totalRevenue = (merchantData['totalRevenue'] as num?)?.toInt() ?? 0;
      _totalPortion = (merchantData['totalPortion'] as num?)?.toInt() ?? 0;

      // Format createdAt label dari data merchant (gunakan createdAt jika ada)
      final createdAtRaw = merchantData['createdAt'] as String?;
      if (createdAtRaw != null) {
        final createdAt = DateTime.tryParse(createdAtRaw);
        if (createdAt != null) {
          _createdAtLabel = 'Sejak ${_formatDate(createdAt)}';
        }
      }

      // Fetch surplus items (menu aktif merchant)
      final surplusItems = await SurplusService.getMySurplus();
      
      if (!mounted) return;
      setState(() {
        _merchant = merchant;
        _surplusItems = surplusItems;
        _isLoading = false;
        _errorMessage = null;
        _isUnauthorized = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        if (e.statusCode == 401) {
          _isUnauthorized = true;
          _errorMessage = 'Sesi kamu telah berakhir. Silakan login kembali.';
        } else if (e.statusCode == 403) {
          _errorMessage = 'Kamu tidak memiliki akses ke halaman ini.';
        } else {
          _errorMessage = e.message;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Tidak dapat memuat data. Periksa koneksi internet kamu.';
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.white,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isUnauthorized ? Icons.lock_outline : Icons.error_outline,
                    size: 48,
                    color: AppColors.greyDark,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage ?? 'Terjadi kesalahan.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.greyDark,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 160,
                    child: HapHapButton(
                      text: _isUnauthorized ? 'Login Ulang' : 'Coba Lagi',
                      onPressed: () {
                        if (_isUnauthorized) {
                          context.go(AppRoutes.login);
                        } else {
                          _fetchData();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          await _fetchData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroSection(
                merchantName: _merchant?.merchantName ?? 'Toko',
                totalRevenue: _formatPrice(_totalRevenue),
                totalPortion: '$_totalPortion Porsi',
                statsSubtitle: _createdAtLabel.isNotEmpty ? _createdAtLabel : '-',
              ),
              const SizedBox(height: 32),
              _FiturSection(),
              const SizedBox(height: _BerandaMerchantLayout.fiturToMenuAktif),
              _MenuAktifSection(
                surplusItems: _surplusItems,
                onStockAdded: () => _fetchData(),
              ),
              const SizedBox(height: _BerandaMerchantLayout.bottomScrollPadding),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero section
// ---------------------------------------------------------------------------
class _HeroSection extends StatelessWidget {
  final String merchantName;
  final String totalRevenue;
  final String totalPortion;
  final String statsSubtitle;

  const _HeroSection({
    required this.merchantName,
    required this.totalRevenue,
    required this.totalPortion,
    required this.statsSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: _BerandaMerchantLayout.heroRedBgBottomCut,
          child: const _RedBackground(),
        ),

        SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: _BerandaMerchantLayout.heroTopPadding),
              
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _BerandaMerchantLayout.heroHorizontalPadding,
                ),
                child: Text(
                  'Welcome,\n$merchantName!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    height: 1.3,
                  ),
                ),
              ),
              
              const SizedBox(height: _BerandaMerchantLayout.heroTaglineToCards),
              
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _BerandaMerchantLayout.heroHorizontalPadding,
                ),
                child: _StatsRow(
                  totalRevenue: totalRevenue,
                  totalPortion: totalPortion,
                  subtitle: statsSubtitle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RedBackground extends StatelessWidget {
  const _RedBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary, 
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final String totalRevenue;
  final String totalPortion;
  final String subtitle;

  const _StatsRow({
    required this.totalRevenue,
    required this.totalPortion,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: HapHapStatsCard(
            title: _BerandaMerchantContent.statsIncomeTitle,
            prefixText: _BerandaMerchantContent.statsIncomePrefix,
            mainValue: totalRevenue,
            valueColor: Colors.green, 
            subtitle: subtitle,
          ),
        ),
        const SizedBox(width: _BerandaMerchantLayout.statCardSpacing),
        Expanded(
          child: HapHapStatsCard(
            title: _BerandaMerchantContent.statsSavedTitle,
            mainValue: totalPortion,
            valueColor: AppColors.primary, 
            subtitle: subtitle,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Fitur section
// ---------------------------------------------------------------------------
class _FiturSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _BerandaMerchantLayout.sectionHorizontalPadding,
          ),
          child: _SectionTitle(text: 'Fitur'),
        ),
        const SizedBox(height: _BerandaMerchantLayout.sectionTitleToContent),
        
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _BerandaMerchantLayout.sectionHorizontalPadding,
          ),
          child: Row(
            children: [
              HapHapCategoryButton(
                iconPath: AppIcons.menu,
                label: 'Menu',
                onTap: () {
                  context.go(AppRoutes.merchantMenu);
                },
              ),
              const SizedBox(width: _BerandaMerchantLayout.categoryItemSpacing),
              HapHapCategoryButton(
                iconPath: AppIcons.statistics,
                label: 'Statistik',
                onTap: () {
                  context.push(AppRoutes.merchantStatistik);
                },
              ),
              const SizedBox(width: _BerandaMerchantLayout.categoryItemSpacing),
              HapHapCategoryButton(
                iconPath: AppIcons.scan,
                label: 'Scan QR',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Menu Aktif section
// ---------------------------------------------------------------------------
class _MenuAktifSection extends StatelessWidget {
  final List<SurplusItemModel> surplusItems;
  final VoidCallback? onStockAdded;

  const _MenuAktifSection({
    required this.surplusItems,
    this.onStockAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _BerandaMerchantLayout.sectionHorizontalPadding,
          ),
          child: _SectionTitle(text: 'Menu Aktif'),
        ),
        const SizedBox(height: _BerandaMerchantLayout.sectionTitleToContent),
        
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _BerandaMerchantLayout.sectionHorizontalPadding,
          ),
          child: Column(
            children: [
              // Kartu tambah stok (selalu ditampilkan)
              HapHapMerchantAddStockCard(
                imagePath: 'assets/images/puypuy_laper_nih.png',
              ),
              
              const SizedBox(height: _BerandaMerchantLayout.menuAktifSpacing),

              // Daftar surplus items (dynamic dari API)
              if (surplusItems.isEmpty)
                _buildEmptyState()
              else
                ...surplusItems.map((item) {
                  final isSoldOut = item.stock <= 0;
                  final stockText = isSoldOut ? 'Sold' : '${item.stock} left';

                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: _BerandaMerchantLayout.menuAktifSpacing,
                    ),
                    child: HapHapMerchantMenuCard(
                      title: item.name,
                      description: item.description ?? '',
                      price: 'Rp ${_formatPrice(item.discountPrice)}',
                      stockText: stockText,
                      isSoldOut: isSoldOut,
                      imageUrl: item.image ?? '',
                    ),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: const [
          Icon(
            Icons.restaurant_menu_outlined,
            size: 48,
            color: AppColors.greyDark,
          ),
          SizedBox(height: 12),
          Text(
            'Belum ada menu aktif hari ini.\nTambahkan stok untuk mulai berjualan!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.greyDark,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared small widgets
// ---------------------------------------------------------------------------
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
    );
  }
}