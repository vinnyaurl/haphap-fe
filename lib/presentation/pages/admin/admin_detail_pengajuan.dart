import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/data/models/application_model.dart';
import 'package:haphap_fe/data/services/application_service.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';
import 'package:haphap_fe/presentation/widgets/dialog/admin_reject_dialog.dart';
import 'package:haphap_fe/presentation/widgets/feedback/app_snackbar.dart';

class DetailPengajuanAdminPage extends StatefulWidget {
  final ApplicationModel application;

  const DetailPengajuanAdminPage({super.key, required this.application});

  @override
  State<DetailPengajuanAdminPage> createState() =>
      _DetailPengajuanAdminPageState();
}

class _DetailPengajuanAdminPageState extends State<DetailPengajuanAdminPage> {
  bool _isProcessing = false;

  String _categoryLabel(String cat) {
    switch (cat) {
      case 'ROTI':
        return 'Bakery';
      case 'RESTORAN':
        return 'Restoran';
      case 'KAFE':
        return 'Kafe';
      case 'KEBUTUHAN':
        return 'Grocery';
      case 'JAJANAN':
        return 'Jajanan';
      case 'PENUTUP':
        return 'Dessert';
      default:
        return cat;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _openDocument(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      AppSnackbar.showError(context, 'Tidak dapat membuka dokumen.');
    }
  }

  Future<void> _approve() async {
    setState(() => _isProcessing = true);
    try {
      await ApplicationService.updateStatus(
        widget.application.applicationId,
        status: 'APPROVED',
      );
      if (!mounted) return;
      AppSnackbar.showSuccess(context, 'Pengajuan berhasil diterima!');
      context.pop();
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, 'Gagal menerima pengajuan: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _reject(String rejectNote) async {
    await ApplicationService.updateStatus(
      widget.application.applicationId,
      status: 'REJECTED',
      rejectNote: rejectNote,
    );
    if (!mounted) return;
    Navigator.of(context).pop();
    AppSnackbar.showSuccess(context, 'Pengajuan berhasil ditolak.');
    context.pop();
  }

  void _showRejectDialog() {
    showDialog(
      context: context,
      builder: (_) => AdminRejectDialog(onSubmit: _reject),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.application;
    final isPending = app.status == 'PENDING';

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          _buildTopHeader(app),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Informasi Pemohon'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _InfoRow(icon: Icons.person_outline, text: app.userName),
                    _InfoRow(icon: Icons.email_outlined, text: app.userEmail),
                    _InfoRow(icon: Icons.phone_outlined, text: app.userPhone),
                  ]),

                  const SizedBox(height: 24),

                  _buildSectionTitle('Detail Operasional'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _InfoRow(
                      icon: Icons.access_time,
                      text: '${app.openTime} - ${app.closeTime}',
                    ),
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      text: app.address,
                    ),
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      text: app.phone,
                    ),
                    if (app.description != null && app.description!.isNotEmpty)
                      _InfoRow(
                        icon: Icons.notes_outlined,
                        text: app.description!,
                      ),
                  ]),

                  const SizedBox(height: 24),

                  _buildSectionTitle('Informasi Bank'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _InfoRow(
                      icon: Icons.account_balance_outlined,
                      text: app.bankType,
                    ),
                    _InfoRow(
                      icon: Icons.credit_card_outlined,
                      text: app.bankAccount,
                    ),
                    _InfoRow(
                      icon: Icons.badge_outlined,
                      text: app.bankHolder,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  _buildSectionTitle('Dokumen'),
                  const SizedBox(height: 12),
                  _buildDocumentTile(app.document),

                  if (app.status == 'REJECTED' &&
                      app.rejectNote != null &&
                      app.rejectNote!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSectionTitle('Catatan Penolakan'),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.red.withValues(alpha: 0.25)),
                      ),
                      child: Text(
                        app.rejectNote!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          if (isPending) _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildTopHeader(ApplicationModel app) {
    final hasAvatar = app.avatar != null && app.avatar!.isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back,
                    color: AppColors.white, size: 28),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: hasAvatar
                            ? DecorationImage(
                                image: NetworkImage(app.avatar!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: hasAvatar
                          ? null
                          : Center(
                              child: Text(
                                app.merchantName.isNotEmpty
                                    ? app.merchantName[0].toUpperCase()
                                    : 'M',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            app.merchantName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          if (app.merchantOwner.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              app.merchantOwner,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.greyDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            'Diajukan: ${_formatDate(app.createdAt)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.greyDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: app.categories.map((cat) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.greyLight),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Text(
                                  _categoryLabel(cat),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
    );
  }

  Widget _buildInfoCard(List<_InfoRow> rows) {
    return Container(
      width: double.infinity,
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
        children: rows.map((row) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(row.icon, size: 20, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    row.text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDocumentTile(String documentUrl) {
    return GestureDetector(
      onTap: () => _openDocument(documentUrl),
      child: Container(
        width: double.infinity,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dokumen Pengajuan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Ketuk untuk membuka dokumen',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.greyDark,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.open_in_new_rounded,
              size: 20,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: HapHapButton(
              text: 'Tolak',
              isExpanded: true,
              isOutline: true,
              onPressed: _isProcessing ? null : _showRejectDialog,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: HapHapButton(
              text: 'Terima',
              isExpanded: true,
              isLoading: _isProcessing,
              onPressed: _approve,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});
}
