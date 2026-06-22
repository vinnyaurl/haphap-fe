import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'package:haphap_fe/core/theme/app_colors.dart';

import 'package:haphap_fe/presentation/widgets/cards/beranda_stats.dart';
import 'package:haphap_fe/presentation/widgets/cards/merchant_menu.dart'; 
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/data/services/merchant_service.dart';
import 'package:haphap_fe/data/services/order_service.dart';
import 'package:haphap_fe/data/models/order_model.dart';
import 'package:haphap_fe/core/network/api_client.dart';

class StatistikMerchantPage extends StatefulWidget {
  const StatistikMerchantPage({super.key});

  @override
  State<StatistikMerchantPage> createState() => _StatistikMerchantPageState();
}

class _StatistikMerchantPageState extends State<StatistikMerchantPage> {
  bool _isLoading = true;
  String? _errorMessage;

  int _totalRevenue = 0;
  int _totalPortion = 0;


  List<double> _weeklySales = List.filled(7, 0.0);
  int _weeklyGross = 0;
  int _weeklyNet = 0;

  OrderItemModel? _bestSellingItem;
  int _bestSellingSoldCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final merchant = await MerchantService.getMe();
      final orders = await OrderService.fetchOrderMerchant();

      if (!mounted) return;

      _totalRevenue = merchant.totalRevenue;
      _totalPortion = merchant.totalPortion;



      _processOrders(orders);

      setState(() {
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat statistik';
      });
    }
  }

  void _processOrders(List<OrderModel> orders) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    
    final endOfWeekDate = startOfWeekDate.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    _weeklySales = List.filled(7, 0.0);
    _weeklyGross = 0;
    _weeklyNet = 0;

    final Map<String, int> itemSalesCount = {};
    final Map<String, OrderItemModel> itemDetails = {};

    for (var order in orders) {
      if (!order.isCompleted) continue;

      for (var item in order.orderItems) {
        itemSalesCount[item.surplusItemId] = (itemSalesCount[item.surplusItemId] ?? 0) + item.quantity;
        itemDetails[item.surplusItemId] = item;
      }

      if (order.createdAt.isAfter(startOfWeekDate) && order.createdAt.isBefore(endOfWeekDate)) {
        final dayIndex = order.createdAt.weekday - 1;
        _weeklySales[dayIndex] += order.totalAmount.toDouble();
        
        _weeklyGross += order.totalOriginal;
        _weeklyNet += order.totalAmount;
      }
    }

    String? bestSellingId;
    int maxCount = 0;
    for (var entry in itemSalesCount.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        bestSellingId = entry.key;
      }
    }

    if (bestSellingId != null) {
      _bestSellingItem = itemDetails[bestSellingId];
      _bestSellingSoldCount = maxCount;
    }
  }

  String _formatCurrency(int value) {
    if (value >= 1000000) {
      final v = value / 1000000;
      return 'Rp${v % 1 == 0 ? v.toInt() : v.toStringAsFixed(1)}jt';
    } else if (value >= 1000) {
      final v = value / 1000;
      return 'Rp${v % 1 == 0 ? v.toInt() : v.toStringAsFixed(1)}rb';
    }
    return 'Rp$value';
  }

  String _formatPrice(int value) {
    final parts = value.toString().split('').reversed.toList();
    String result = '';
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && i % 3 == 0) result = '.$result';
      result = parts[i] + result;
    }
    return result;
  }

  String _formatChartLabel(double value) {
    if (value == 0) return '0';
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}jt';
    } else if (value >= 1000) {
      return '${(value / 1000).toInt()}rb';
    }
    return value.toInt().toString();
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

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: HapHapPageHeader(
                  title: 'Statistik',
                ),
              ),
              
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _isLoading 
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : _errorMessage != null
                        ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
                        : Row(
                            children: [
                              Expanded(
                                child: HapHapStatsCard(
                                  title: 'Total Penghasilan',
                                  prefixText: 'Rp ',
                                  mainValue: _formatPrice(_totalRevenue),
                                  valueColor: Colors.green,
                                  subtitle: 'Total pendapatan kamu',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: HapHapStatsCard(
                                  title: 'Total Pesanan',
                                  mainValue: '$_totalPortion Porsi',
                                  valueColor: AppColors.primary,
                                  subtitle: 'Total porsi diselamatkan',
                                ),
                              ),
                            ],
                          ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
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
                    children: [
                      SizedBox(
                        height: 200,
                        child: _buildLineChart(),
                      ),
                      
                      const SizedBox(height: 24),
                      const Divider(color: Color(0xFFF1F1F1), height: 1),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Total Penjualan',
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w700, 
                              color: AppColors.black,
                            ),
                          ),
                          Row(
                            children: const [
                              Text(
                                'Minggu ini', 
                                style: TextStyle(
                                  fontSize: 12, 
                                  fontWeight: FontWeight.w500, 
                                  color: Color(0xFFAAAAAA), 
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatCurrency(_weeklyGross), 
                                style: const TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold, 
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 2), 
                              const Text(
                                'Pendapatan Kotor', 
                                style: TextStyle(
                                  fontSize: 12, 
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFAAAAAA), 
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatCurrency(_weeklyNet), 
                                style: const TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold, 
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Pendapatan Bersih', 
                                style: TextStyle(
                                  fontSize: 12, 
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFAAAAAA), 
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Menu Paling Laris',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _isLoading
                    ? const SizedBox()
                    : _bestSellingItem != null
                        ? HapHapMerchantMenuCard(
                            title: _bestSellingItem!.name,
                            description: 'Menu favorit pelanggan',
                            price: 'Rp ${_formatPrice(_bestSellingItem!.discountPrice)}',
                            stockText: '$_bestSellingSoldCount Terjual', 
                            imageUrl: '',
                          )
                        : const Text(
                            'Belum ada data pesanan.',
                            style: TextStyle(color: AppColors.greyDark),
                          ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    double maxSales = _weeklySales.reduce((a, b) => a > b ? a : b);
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false, 
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Color(0xFFE0E0E0),
              strokeWidth: 1,
              dashArray: [5, 5], 
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(color: AppColors.greyDark, fontSize: 10);
                Widget text;
                switch (value.toInt()) {
                  case 0: text = const Text('Senin', style: style); break;
                  case 1: text = const Text('Selasa', style: style); break;
                  case 2: text = const Text('Rabu', style: style); break;
                  case 3: text = const Text('Kamis', style: style); break;
                  case 4: text = const Text('Jumat', style: style); break;
                  case 5: text = const Text('Sabtu', style: style); break;
                  case 6: text = const Text('Minggu', style: style); break;
                  default: text = const Text('', style: style); break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide, 
                  space: 8,
                  child: text,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatChartLabel(value),
                  style: const TextStyle(color: AppColors.greyDark, fontSize: 10),
                  textAlign: TextAlign.left,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: maxSales == 0 ? 1000 : maxSales * 1.2,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, _weeklySales[0]),
              FlSpot(1, _weeklySales[1]),
              FlSpot(2, _weeklySales[2]),
              FlSpot(3, _weeklySales[3]),
              FlSpot(4, _weeklySales[4]),
              FlSpot(5, _weeklySales[5]), 
              FlSpot(6, _weeklySales[6]),
            ],
            isCurved: true, 
            color: AppColors.primary, 
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              checkToShowDot: (spot, barData) {
                final todayIndex = DateTime.now().weekday - 1;
                return spot.x == todayIndex; 
              },
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: AppColors.white,
                  strokeWidth: 2,
                  strokeColor: AppColors.primary,
                );
              },
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}