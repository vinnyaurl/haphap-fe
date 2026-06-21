import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/router/app_routes.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/data/models/application_model.dart';
import 'package:haphap_fe/data/services/application_service.dart';
import 'package:haphap_fe/presentation/widgets/cards/admin_application_card.dart';

class _AdminBerandaLayout {
  static const double heroTopPadding = 40.0;
  static const double heroHorizontalPadding = 24.0;
  static const double titleToGrid = 24.0;
  static const double gridCardSpacing = 16.0;
  static const double gridCardHeight = 110.0;
  static const double heroPaddingBottom = 32.0;
  static const double sectionHorizontalPadding = 24.0;
  static const double sectionTitleToContent = 16.0;
  static const double bottomScrollPadding = 80.0;
}

class BerandaAdminPage extends StatefulWidget {
  const BerandaAdminPage({super.key});

  @override
  State<BerandaAdminPage> createState() => _BerandaAdminPageState();
}

class _BerandaAdminPageState extends State<BerandaAdminPage> {
  List<ApplicationModel> _applications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    try {
      final apps = await ApplicationService.fetchAll();
      if (!mounted) return;
      setState(() {
        _applications = apps;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal memuat data pengajuan.';
        _isLoading = false;
      });
    }
  }

  int get _totalCount => _applications.length;
  int get _pendingCount =>
      _applications.where((a) => a.status == 'PENDING').length;
  int get _approvedCount =>
      _applications.where((a) => a.status == 'APPROVED').length;
  int get _rejectedCount =>
      _applications.where((a) => a.status == 'REJECTED').length;

  List<ApplicationModel> get _latestApplications =>
      _applications.take(5).toList();

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                  onRefresh: _fetchApplications,
                  color: AppColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroSection(),
                        const SizedBox(height: 24),
                        _buildPengajuanTerbaruSection(),
                        const SizedBox(
                            height: _AdminBerandaLayout.bottomScrollPadding),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            _AdminBerandaLayout.heroHorizontalPadding,
            _AdminBerandaLayout.heroTopPadding,
            _AdminBerandaLayout.heroHorizontalPadding,
            _AdminBerandaLayout.heroPaddingBottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ringkasan Sistem',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: _AdminBerandaLayout.titleToGrid),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      label: 'Total Pengajuan',
                      value: _totalCount.toString(),
                      valueColor: AppColors.black,
                    ),
                  ),
                  const SizedBox(
                      width: _AdminBerandaLayout.gridCardSpacing),
                  Expanded(
                    child: _buildStatCard(
                      label: 'Menunggu Validasi',
                      value: _pendingCount.toString(),
                      valueColor: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: _AdminBerandaLayout.gridCardSpacing),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      label: 'Diterima',
                      value: _approvedCount.toString(),
                      valueColor: Colors.green,
                    ),
                  ),
                  const SizedBox(
                      width: _AdminBerandaLayout.gridCardSpacing),
                  Expanded(
                    child: _buildStatCard(
                      label: 'Ditolak',
                      value: _rejectedCount.toString(),
                      valueColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      height: _AdminBerandaLayout.gridCardHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.greyDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPengajuanTerbaruSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _AdminBerandaLayout.sectionHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pengajuan Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              GestureDetector(
                onTap: () => context.go(AppRoutes.adminPengajuan),
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: _AdminBerandaLayout.sectionTitleToContent),

          if (_latestApplications.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Belum ada pengajuan.',
                style: TextStyle(color: AppColors.greyDark),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _latestApplications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final app = _latestApplications[index];
                return AdminApplicationCard(
                  merchantName: app.merchantName,
                  applicantName: app.userName,
                  dateText: _formatDate(app.createdAt),
                  status: app.status,
                  avatarUrl: app.avatar,
                  onTap: () => context.push(
                    AppRoutes.adminDetailPengajuan,
                    extra: app,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
