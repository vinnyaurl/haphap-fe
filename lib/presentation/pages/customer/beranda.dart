import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/constants/app_icons.dart';
import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/core/router/app_routes.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/data/models/merchant_model.dart';
import 'package:haphap_fe/data/services/merchant_service.dart';
import 'package:haphap_fe/presentation/widgets/buttons/beranda_merchant_category.dart';
import 'package:haphap_fe/presentation/widgets/cards/beranda_stats.dart';
import 'package:haphap_fe/presentation/widgets/cards/restaurant_card.dart';
import 'package:haphap_fe/presentation/widgets/inputs/search_bar.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _HeroSection(),
            _KategoriSection(),
            SizedBox(height: _BerandaLayout.kategoriToSekitar),
            _SekitarKamuSection(),
            SizedBox(height: _BerandaLayout.bottomScrollPadding),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: _BerandaLayout.heroOrangeBgBottomCut,
          child: const _OrangeBackground(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: _BerandaLayout.heroTopPadding),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _BerandaLayout.heroHorizontalPadding,
              ),
              child: HapHapSearchBar(
                hintText: _BerandaContent.searchHint,
                prefixIconPath: AppIcons.magnifying_glass,
              ),
            ),
            const SizedBox(height: _BerandaLayout.heroSearchToTagline),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _BerandaLayout.heroHorizontalPadding,
              ),
              child: _TaglineWithMascot(),
            ),
            const SizedBox(height: _BerandaLayout.heroDiskonToCards),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _BerandaLayout.heroHorizontalPadding,
              ),
              child: _StatsRow(),
            ),
            const SizedBox(height: _BerandaLayout.heroCardsToKategori),
          ],
        ),
      ],
    );
  }
}

class _OrangeBackground extends StatelessWidget {
  const _OrangeBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
    );
  }
}

class _TaglineWithMascot extends StatelessWidget {
  const _TaglineWithMascot();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              _BerandaContent.tagline,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                height: 1.3,
              ),
            ),
            const SizedBox(height: _BerandaLayout.heroTaglineToDiskon),
            Row(
              children: const [
                Text(
                  _BerandaContent.discountCta,
                  style: TextStyle(fontSize: 14, color: AppColors.white),
                ),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, color: AppColors.white, size: 16),
              ],
            ),
          ],
        ),
        Positioned(
          right: _BerandaLayout.mascotRight,
          top: _BerandaLayout.mascotTop,
          child: Image.asset(
            _BerandaContent.mascotPath,
            width: _BerandaLayout.mascotWidth,
            height: _BerandaLayout.mascotHeight,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: HapHapStatsCard(
            title: _BerandaContent.statsSavingsTitle,
            prefixText: _BerandaContent.statsSavingsPrefix,
            mainValue: _BerandaContent.statsSavingsValue,
            valueColor: Colors.green,
            subtitle: _BerandaContent.statsSavingsSubtitle,
          ),
        ),
        SizedBox(width: _BerandaLayout.statCardSpacing),
        Expanded(
          child: HapHapStatsCard(
            title: _BerandaContent.statsSavedTitle,
            mainValue: _BerandaContent.statsSavedValue,
            valueColor: AppColors.primary,
            subtitle: _BerandaContent.statsSavedSubtitle,
          ),
        ),
      ],
    );
  }
}

class _KategoriSection extends StatelessWidget {
  const _KategoriSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _BerandaLayout.sectionHorizontalPadding,
          ),
          child: _SectionTitle(text: 'Kategori'),
        ),
        const SizedBox(height: _BerandaLayout.sectionTitleToContent),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: _BerandaLayout.sectionHorizontalPadding,
          ),
          child: Row(
            children: [
              HapHapCategoryButton(iconPath: AppIcons.bakery, label: 'Bakery', onTap: () {}),
              const SizedBox(width: _BerandaLayout.categoryItemSpacing),
              HapHapCategoryButton(iconPath: AppIcons.restaurant, label: 'Restoran', onTap: () {}),
              const SizedBox(width: _BerandaLayout.categoryItemSpacing),
              HapHapCategoryButton(iconPath: AppIcons.cafe, label: 'Kafe', onTap: () {}),
              const SizedBox(width: _BerandaLayout.categoryItemSpacing),
              HapHapCategoryButton(iconPath: AppIcons.grocery, label: 'Grocery', onTap: () {}),
              const SizedBox(width: _BerandaLayout.categoryItemSpacing),
              HapHapCategoryButton(iconPath: AppIcons.jajanan, label: 'Jajanan', onTap: () {}),
              const SizedBox(width: _BerandaLayout.categoryItemSpacing),
              HapHapCategoryButton(iconPath: AppIcons.dessert, label: 'Dessert', onTap: () {}),
            ],
          ),
        ),
      ],
    );
  }
}

class _SekitarKamuSection extends StatefulWidget {
  const _SekitarKamuSection();

  @override
  State<_SekitarKamuSection> createState() => _SekitarKamuSectionState();
}

class _SekitarKamuSectionState extends State<_SekitarKamuSection> {
  List<MerchantModel> _merchants = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMerchants();
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
        _error = 'Gagal memuat merchant.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _BerandaLayout.sectionHorizontalPadding,
          ),
          child: _SectionTitle(text: 'Sekitar Kamu'),
        ),
        const SizedBox(height: _BerandaLayout.sectionTitleToContent),
        _buildContent(context),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _BerandaLayout.sectionHorizontalPadding,
          vertical: 16,
        ),
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.red, fontSize: 14),
        ),
      );
    }

    if (_merchants.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _BerandaLayout.sectionHorizontalPadding,
          vertical: 16,
        ),
        child: Text(
          'Belum ada merchant di sekitar kamu.',
          style: TextStyle(color: AppColors.greyDark, fontSize: 14),
        ),
      );
    }


    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: _BerandaLayout.sectionHorizontalPadding,
      ),
      child: Row(
        children: _merchants.asMap().entries.map((entry) {
          final index = entry.key;
          final merchant = entry.value;

          return Row(
            children: [
              GestureDetector(
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
              if (index < _merchants.length - 1)
                const SizedBox(width: _BerandaLayout.restaurantCardSpacing),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
    );
  }
}

class _BerandaLayout {
  static const double heroTopPadding = 21;
  static const double heroHorizontalPadding = 24;
  static const double heroSearchToTagline = 47;
  static const double heroTaglineToDiskon = 16;
  static const double heroDiskonToCards = 47;
  static const double heroCardsToKategori = 32;
  static const double heroOrangeBgBottomCut = 120;

  static const double mascotWidth = 192;
  static const double mascotHeight = 198;
  static const double mascotRight = -30;
  static const double mascotTop = -55;

  static const double statCardSpacing = 16;
  static const double sectionHorizontalPadding = 24;
  static const double categoryItemSpacing = 20;
  static const double restaurantCardSpacing = 16;
  static const double sectionTitleToContent = 16;
  static const double kategoriToSekitar = 32;
  static const double bottomScrollPadding = 80;
}

class _BerandaContent {
  static const String searchHint = 'Mau makan apa hari ini?';
  static const String tagline = 'Selalu hemat beli\nmakanan pakai HapHap.';
  static const String discountCta = 'Lihat diskon selengkapnya disini';
  static const String mascotPath = 'assets/images/puy_beranda1.png';

  static const String statsSavingsTitle = 'Berhasil Hemat';
  static const String statsSavingsPrefix = 'Rp ';
  static const String statsSavingsValue = '67.6rb';
  static const String statsSavingsSubtitle = 'Sejak 6 Juli 2026';

  static const String statsSavedTitle = 'Berhasil Selamatin';
  static const String statsSavedValue = '67 Porsi';
  static const String statsSavedSubtitle = 'Sejak 6 Juli 2026';
}