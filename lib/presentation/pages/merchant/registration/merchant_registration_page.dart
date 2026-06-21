import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/data/services/application_service.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/presentation/widgets/inputs/dropdown_field.dart';
import 'package:haphap_fe/presentation/widgets/inputs/file_upload_field.dart';
import 'package:haphap_fe/presentation/widgets/inputs/text_fields.dart';
import 'package:haphap_fe/presentation/widgets/navigations/stepper_indicator.dart';
import 'package:image_picker/image_picker.dart';

class MerchantRegistrationPage extends StatefulWidget {
  const MerchantRegistrationPage({super.key});

  @override
  State<MerchantRegistrationPage> createState() =>
      _MerchantRegistrationPageState();
}

class _MerchantRegistrationPageState extends State<MerchantRegistrationPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Forms
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();

  // Controllers Step 1
  final _ownerNameCtrl = TextEditingController();
  final _businessNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _openTimeCtrl = TextEditingController();
  final _closeTimeCtrl = TextEditingController();

  // Controllers Step 2
  String? _selectedBank;
  final _accountNumberCtrl = TextEditingController();
  final _accountHolderCtrl = TextEditingController();

  // Step 3
  XFile? _avatarFile;
  XFile? _documentFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _pageController.dispose();
    _ownerNameCtrl.dispose();
    _businessNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _descriptionCtrl.dispose();
    _openTimeCtrl.dispose();
    _closeTimeCtrl.dispose();
    _accountNumberCtrl.dispose();
    _accountHolderCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_step1FormKey.currentState!.validate()) {
        if (_openTimeCtrl.text.isEmpty || _closeTimeCtrl.text.isEmpty) {
          _showErrorSnackBar('Waktu operasional harus diisi');
          return;
        }
        _moveToStep(1);
      }
    } else if (_currentStep == 1) {
      if (_selectedBank == null) {
        _showErrorSnackBar('Pilih bank terlebih dahulu');
        return;
      }
      if (_step2FormKey.currentState!.validate()) {
        _moveToStep(2);
      }
    }
  }

  void _moveToStep(int step) {
    setState(() {
      _currentStep = step;
    });
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      setState(() {
        controller.text = '$hour:$minute';
      });
    }
  }

  Future<void> _pickFile(bool isDocument) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        // Simple file size check (~5MB)
        final length = await pickedFile.length();
        if (length > 5 * 1024 * 1024) {
          _showErrorSnackBar('Ukuran file maksimal 5 MB');
          return;
        }
        
        setState(() {
          if (isDocument) {
            _documentFile = pickedFile;
          } else {
            _avatarFile = pickedFile;
          }
        });
      }
    } catch (e) {
      _showErrorSnackBar('Gagal memilih file: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _submitApplication() async {
    if (_documentFile == null) {
      _showErrorSnackBar('Dokumen (Proposal/Izin) wajib diunggah');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final fields = {
        'merchantName': _businessNameCtrl.text,
        'merchantOwner': _ownerNameCtrl.text,
        'address': _addressCtrl.text,
        'latitude': '-6.2', // Dummy, for real app get from maps
        'longitude': '106.8', // Dummy
        'openTime': _openTimeCtrl.text,
        'closeTime': _closeTimeCtrl.text,
        'phone': _phoneCtrl.text,
        'categories': 'RESTORAN', // Using RESTORAN as default for now
        'bankType': _selectedBank!,
        'bankAccount': _accountNumberCtrl.text,
        'bankHolder': _accountHolderCtrl.text,
      };

      if (_descriptionCtrl.text.isNotEmpty) {
        fields['description'] = _descriptionCtrl.text;
      }

      final files = <String, String>{};
      files['document'] = _documentFile!.path;
      if (_avatarFile != null) {
        files['avatar'] = _avatarFile!.path;
      }

      await ApplicationService.createApplication(
        fields: fields,
        files: files,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran berhasil dikirim!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: HapHapPageHeader(
            title: 'Merchant',
          ),
        ),
      ),
      body: Column(
        children: [
          HapHapStepperIndicator(
            currentStep: _currentStep,
            totalSteps: 3,
            labels: const ['Detail Bisnis', 'Detail Bank', 'Dokumen'],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
              ],
            ),
          ),
          _buildBottomNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _step1FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Bisnis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            HapHapTextField(
              labelText: 'Nama Pemilik',
              hintText: 'Nama lengkap pemilik',
              controller: _ownerNameCtrl,
              isRequired: true,
              validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            HapHapTextField(
              labelText: 'Nama Bisnis',
              hintText: 'Nama bisnis',
              controller: _businessNameCtrl,
              isRequired: true,
              validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            HapHapTextField(
              labelText: 'Telepon Bisnis',
              hintText: 'Nomor telepon bisnis',
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              isRequired: true,
              validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            HapHapTextField(
              labelText: 'Email Bisnis',
              hintText: 'Email bisnis',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              isRequired: true,
              validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            HapHapTextField(
              labelText: 'Alamat Bisnis',
              hintText: 'Alamat lengkap',
              controller: _addressCtrl,
              isRequired: true,
              validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            HapHapTextField(
              labelText: 'Deskripsi',
              hintText: 'Deskripsi bisnis (opsional)',
              controller: _descriptionCtrl,
            ),
            const SizedBox(height: 24),
            const Text(
              'Waktu Operasional',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(_openTimeCtrl),
                    child: IgnorePointer(
                      child: HapHapTextField(
                        labelText: 'Buka',
                        hintText: 'HH:mm',
                        controller: _openTimeCtrl,
                        isRequired: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(_closeTimeCtrl),
                    child: IgnorePointer(
                      child: HapHapTextField(
                        labelText: 'Tutup',
                        hintText: 'HH:mm',
                        controller: _closeTimeCtrl,
                        isRequired: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _step2FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Rekening',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            HapHapDropdownField(
              labelText: 'Nama Bank',
              hintText: 'Pilih Bank',
              value: _selectedBank,
              isRequired: true,
              options: const [
                'BCA',
                'BNI',
                'MANDIRI',
                'BRI',
                'CIMB',
                'DANAMON',
                'PERMATA',
                'BTN'
              ],
              onSelected: (val) {
                setState(() {
                  _selectedBank = val;
                });
              },
            ),
            const SizedBox(height: 16),
            HapHapTextField(
              labelText: 'Nomor Rekening',
              hintText: 'Nomor rekening',
              controller: _accountNumberCtrl,
              keyboardType: TextInputType.number,
              isRequired: true,
              validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            HapHapTextField(
              labelText: 'Nama Pemilik Rekening',
              hintText: 'Nama pemilik rekening',
              controller: _accountHolderCtrl,
              isRequired: true,
              validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Dokumen',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Silakan unggah dokumen yang diperlukan untuk pendaftaran merchant.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.greyDark,
            ),
          ),
          const SizedBox(height: 24),
          HapHapFileUploadField(
            labelText: 'Avatar / Logo Bisnis (Opsional)',
            selectedFileName: _avatarFile?.name,
            onFileSelected: () => _pickFile(false),
            onClear: () {
              setState(() {
                _avatarFile = null;
              });
            },
          ),
          const SizedBox(height: 24),
          HapHapFileUploadField(
            labelText: 'Dokumen (Proposal / Izin Bisnis)',
            isRequired: true,
            selectedFileName: _documentFile?.name,
            onFileSelected: () => _pickFile(true),
            onClear: () {
              setState(() {
                _documentFile = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: HapHapButton(
                text: 'Kembali',
                isOutline: true,
                onPressed: () => _moveToStep(_currentStep - 1),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: HapHapButton(
              text: _currentStep == 2 ? 'Kirim Pendaftaran' : 'Langkah Berikutnya',
              isLoading: _isLoading,
              onPressed: _currentStep == 2 ? _submitApplication : _nextStep,
            ),
          ),
        ],
      ),
    );
  }
}
