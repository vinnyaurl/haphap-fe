import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'package:haphap_fe/core/theme/app_colors.dart';

import 'package:haphap_fe/presentation/widgets/cards/beranda_stats.dart';
import 'package:haphap_fe/presentation/widgets/cards/merchant_menu.dart'; 
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';

class StatistikMerchantPage extends StatefulWidget {
  const StatistikMerchantPage({super.key});

  @override
  State<StatistikMerchantPage> createState() => _StatistikMerchantPageState();
}

class _StatistikMerchantPageState extends State<StatistikMerchantPage> {
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

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: HapHapStatsCard(
                        title: 'Total Penghasilan',
                        prefixText: 'Rp ',
                        mainValue: '500.000',
                        valueColor: Colors.green,
                        subtitle: 'Sejak 6 Juli 2026',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: HapHapStatsCard(
                        title: 'Total Pesanan',
                        mainValue: '67 Porsi',
                        valueColor: AppColors.primary,
                        subtitle: 'Sejak 6 Juli 2026',
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
                              SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFFAAAAAA)),
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
                            children: const [
                              Text(
                                'Rp1.200jt', 
                                style: TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold, 
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(height: 2), 
                              Text(
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
                            children: const [
                              Text(
                                'Rp800rb', 
                                style: TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold, 
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: HapHapMerchantMenuCard(
                  title: 'Szechuan Chicken Bowl',
                  description: 'Nasi + Ayam Saus Szechuan',
                  price: 'Rp 25.000',
                  stockText: '167 Sold', 
                  imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
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
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false, 
          horizontalInterval: 250,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xFFE0E0E0),
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
              interval: 250, 
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
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
        maxY: 1000,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 150),
              FlSpot(1, 280),
              FlSpot(2, 200),
              FlSpot(3, 300),
              FlSpot(4, 750),
              FlSpot(5, 950), 
              FlSpot(6, 680),
            ],
            isCurved: true, 
            color: AppColors.primary, 
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              checkToShowDot: (spot, barData) {
                return spot.x == 5; 
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