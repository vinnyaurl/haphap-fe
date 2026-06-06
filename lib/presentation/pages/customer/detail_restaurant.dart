import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/core/router/app_routes.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/data/models/merchant_model.dart';
import 'package:haphap_fe/data/services/merchant_service.dart';
import 'package:haphap_fe/presentation/pages/customer/checkout.dart';
import 'package:haphap_fe/presentation/widgets/cards/menu_card.dart';
import 'package:haphap_fe/presentation/widgets/cards/restaurant_card.dart';

class DetailRestoranPage extends StatefulWidget {
  final String merchantId;

  const DetailRestoranPage({super.key, required this.merchantId});

  @override
  State<DetailRestoranPage> createState() => _DetailRestoranPageState();
}

class _DetailRestoranPageState extends State<DetailRestoranPage> {
  MerchantDetailModel? _merchant;
  bool _isLoading = true;
  String? _error;

  final Map<String, int> _cart = {};

  @override
  void initState() {
    super.initState();
    _fetchMerchant();
  }

  Future<void> _fetchMerchant() async {
    try {
      final merchant = await MerchantService.fetchOne(widget.merchantId);
      if (!mounted) return;
      setState(() {
        _merchant = merchant;
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
        _error = 'Gagal memuat detail merchant.';
        _isLoading = false;
      });
    }
  }

  int get _cartTotalItems =>
      _cart.values.fold(0, (sum, qty) => sum + qty);

  int get _cartTotalPrice {
    if (_merchant == null) return 0;
    return _cart.entries.fold(0, (sum, entry) {
      final item = _merchant!.surplusItems.firstWhere(
        (i) => i.surplusItemId == entry.key,
        orElse: () => const SurplusItemModel(
          surplusItemId: '',
          name: '',
          discountPrice: 0,
          originalPrice: 0,
          stock: 0,
        ),
      );
      return sum + (item.discountPrice * entry.value);
    });
  }

  void _addToCart(SurplusItemModel item) {
    final current = _cart[item.surplusItemId] ?? 0;
    if (current < item.stock) {
      setState(() => _cart[item.surplusItemId] = current + 1);
    }
  }

  void _removeFromCart(SurplusItemModel item) {
    final current = _cart[item.surplusItemId] ?? 0;
    if (current > 0) {
      setState(() {
        if (current == 1) {
          _cart.remove(item.surplusItemId);
        } else {
          _cart[item.surplusItemId] = current - 1;
        }
      });
    }
  }

  bool _isValidUrl(String? url) =>
      url != null &&
      (url.startsWith('http://') || url.startsWith('https://'));

  void _goToCheckout() {
    if (_merchant == null) return;

    context.push(
      AppRoutes.checkout,
      extra: CheckoutArgs(
        merchantId: _merchant!.merchantId,
        merchantName: _merchant!.merchantName,
        cart: Map<String, int>.from(_cart),
        items: _merchant!.surplusItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar:
          _cartTotalItems > 0 ? _buildFloatingCart() : const SizedBox.shrink(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _error!,
            style: const TextStyle(color: Colors.red, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final merchant = _merchant!;

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroSection(merchant),
          const SizedBox(height: 24),
          _buildDaftarMenuSection(merchant),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildHeroSection(MerchantDetailModel merchant) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          width: double.infinity,
          height: 220,
          child: _isValidUrl(merchant.avatar)
              ? Image.network(
                  merchant.avatar!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: AppColors.primary),
                )
              : Container(color: AppColors.primary),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 160, left: 24, right: 24),
          child: HapHapRestaurantCard(
            imageUrl: merchant.avatar ?? '',
            distanceTime: merchant.address ?? '',
            restaurantName: merchant.merchantName,
            ratingText: merchant.rating != null
                ? '${merchant.rating!.toStringAsFixed(1)} rating'
                : 'Belum ada rating',
          ),
        ),
      ],
    );
  }

  Widget _buildDaftarMenuSection(MerchantDetailModel merchant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            merchant.merchantName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (merchant.surplusItems.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Belum ada surplus item tersedia.',
              style: TextStyle(color: AppColors.greyDark, fontSize: 14),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: merchant.surplusItems.map((item) {
                final cartCount = _cart[item.surplusItemId] ?? 0;
                return Column(
                  children: [
                    HapHapMenuCard(
                      imageUrl: item.image ?? '',
                      title: item.name,
                      description: item.description ?? '',
                      price: 'Rp ${item.discountPrice}',
                      stockCount: item.stock,
                      cartCount: cartCount,
                      onAdd: () => _addToCart(item),
                      onRemove: () => _removeFromCart(item),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildFloatingCart() {
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

    return Container(
      height: 81 + bottomSafeArea,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: bottomSafeArea),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Center(
        child: InkWell(
          onTap: _goToCheckout,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Keranjang - $_cartTotalItems Hidangan',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  'Rp $_cartTotalPrice',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}