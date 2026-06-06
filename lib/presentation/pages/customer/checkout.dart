import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/core/router/app_routes.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/core/constants/app_icons.dart';
import 'package:haphap_fe/data/models/merchant_model.dart';
import 'package:haphap_fe/data/services/order_service.dart';
import 'package:haphap_fe/data/services/payment_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';

class CheckoutArgs {
  final String merchantId;
  final String merchantName;
  final Map<String, int> cart;
  final List<SurplusItemModel> items;

  const CheckoutArgs({
    required this.merchantId,
    required this.merchantName,
    required this.cart,
    required this.items,
  });
}

class CheckoutPage extends StatefulWidget {
  final CheckoutArgs args;

  const CheckoutPage({super.key, required this.args});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPaymentMethod = 'QRIS';
  bool _isSubmitting = false;
  bool _isCheckingPayment = false;
  String? _errorMessage;
  String? _pendingOrderId;

  late Map<String, int> _cart;

  @override
  void initState() {
    super.initState();
    _cart = Map<String, int>.from(widget.args.cart);
  }

  List<SurplusItemModel> get _activeItems => widget.args.items
      .where((item) => (_cart[item.surplusItemId] ?? 0) > 0)
      .toList();

  int get _totalPrice => widget.args.items.fold(0, (sum, item) {
        final qty = _cart[item.surplusItemId] ?? 0;
        return sum + (item.discountPrice * qty);
      });

  void _add(SurplusItemModel item) {
    final current = _cart[item.surplusItemId] ?? 0;
    if (current < item.stock) {
      setState(() => _cart[item.surplusItemId] = current + 1);
    }
  }

  void _remove(SurplusItemModel item) {
    final current = _cart[item.surplusItemId] ?? 0;
    if (current > 1) {
      setState(() => _cart[item.surplusItemId] = current - 1);
    } else if (current == 1) {
      setState(() => _cart.remove(item.surplusItemId));
    }
  }

  bool _isValidUrl(String? url) =>
      url != null &&
      (url.startsWith('http://') || url.startsWith('https://'));

  String _formatPrice(int price) => price
      .toString()
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

  Future<void> _buatPesanan() async {
    if (_activeItems.isEmpty || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final orderItems = _cart.entries
          .map((e) => {'surplusItemId': e.key, 'quantity': e.value})
          .toList();

      final order = await OrderService.createOrder(
        merchantId: widget.args.merchantId,
        orderItems: orderItems,
      );

      if (!mounted) return;

      if (_selectedPaymentMethod == 'Cash') {
        context.go(AppRoutes.aktivitas);
        return;
      }

      final payment = await PaymentService.createPayment(order.orderId);

      if (!mounted) return;

      final uri = Uri.parse(payment.redirectUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        setState(() => _errorMessage = 'Tidak dapat membuka halaman pembayaran.');
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _checkPaymentStatus() async {
    if (_pendingOrderId == null || _isCheckingPayment) return;

    setState(() {
      _isCheckingPayment = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiClient.get('/orders/$_pendingOrderId');
      final data = response['data'] ?? response;
      final status = (data['status'] as String?)?.toUpperCase() ?? '';

      if (!mounted) return;

      if (status == 'PAID') {
        context.go(AppRoutes.aktivitas);
      } else if (status == 'CANCELLED' || status == 'EXPIRED') {
        setState(() {
          _errorMessage = 'Pesanan dibatalkan atau kadaluarsa.';
          _pendingOrderId = null;
        });
      } else {
        setState(() => _errorMessage =
            'Pembayaran belum terkonfirmasi. Pastikan kamu telah menyelesaikan pembayaran.');
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    } catch (_) {
      if (mounted) setState(() => _errorMessage = 'Gagal mengecek status. Coba lagi.');
    } finally {
      if (mounted) setState(() => _isCheckingPayment = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: HapHapPageHeader(title: widget.args.merchantName),
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rangkuman Pesanan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Text(
                        'Tambah Pesanan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_activeItems.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Keranjang kosong.',
                            style: TextStyle(
                                color: AppColors.greyDark, fontSize: 14),
                          ),
                        )
                      else
                        ..._activeItems.map((item) => Column(
                              children: [
                                _buildCartItem(item),
                                const Divider(
                                    color: Color(0xFFF1F1F1),
                                    height: 1,
                                    thickness: 1),
                              ],
                            )),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rincian Pembayaran',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.greyDark)),
                                Text(
                                  'Rp ${_formatPrice(_totalPrice)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
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
              ),

              const SizedBox(height: 140),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildCheckoutBottomBar(),
    );
  }

  Widget _buildCartItem(SurplusItemModel item) {
    final qty = _cart[item.surplusItemId] ?? 0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _isValidUrl(item.image)
                ? Image.network(
                    item.image!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderBox(),
                  )
                : _placeholderBox(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.description != null &&
                          item.description!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.description!,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.greyDark),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${_formatPrice(item.discountPrice)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _remove(item),
                            behavior: HitTestBehavior.opaque,
                            child: const Icon(Icons.remove_circle,
                                color: AppColors.primary, size: 24),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              '$qty',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _add(item),
                            behavior: HitTestBehavior.opaque,
                            child: const Icon(Icons.add_circle,
                                color: AppColors.primary, size: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderBox() => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
      );

  Widget _buildCheckoutBottomBar() {
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: bottomSafeArea > 0 ? bottomSafeArea : 24,
      ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  _selectedPaymentMethod == 'QRIS'
                      ? SvgPicture.asset(AppIcons.QRIS, height: 24)
                      : const Icon(Icons.payments,
                          color: Colors.green, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    _selectedPaymentMethod,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _isSubmitting ? null : _showPaymentMethodDialog,
                child: const Text(
                  'Ubah',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (_pendingOrderId != null) ...[
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isCheckingPayment ? null : _checkPaymentStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.greyLight,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                child: _isCheckingPayment
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Saya Sudah Bayar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: _isCheckingPayment ? null : _buatPesanan,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text(
                  'Bayar Ulang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ] else
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: (_activeItems.isEmpty || _isSubmitting)
                    ? null
                    : _buatPesanan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.greyLight,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Buat Pesanan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  void _showPaymentMethodDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding:
              const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 34),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Metode Pembayaran',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 24),
              _buildPaymentOption(
                title: 'Cash',
                icon: const Icon(Icons.payments, color: Colors.green, size: 24),
                value: 'Cash',
              ),
              const SizedBox(height: 24),
              _buildPaymentOption(
                title: 'QRIS',
                icon: SvgPicture.asset(AppIcons.QRIS, height: 24),
                value: 'QRIS',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required Widget icon,
    required String value,
  }) {
    final isSelected = _selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedPaymentMethod = value);
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black)),
            const Spacer(),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.greyLight,
                  width: isSelected ? 6 : 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}