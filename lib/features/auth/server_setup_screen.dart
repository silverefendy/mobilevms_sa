import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_vms/config/app_config.dart';
import 'package:mobile_vms/core/network/jwt_api_client.dart';

const _kServerUrl = 'vms_server_url';

class ServerSetupScreen extends StatefulWidget {
  const ServerSetupScreen({super.key});

  @override
  State<ServerSetupScreen> createState() => _ServerSetupScreenState();
}

class _ServerSetupScreenState extends State<ServerSetupScreen> {
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _urlFocus = FocusNode();

  bool _testing = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _loadSavedUrl();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _urlFocus.dispose();
    super.dispose();
  }

  Future<void> _loadSavedUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUrl = prefs.getString(_kServerUrl);
      if (savedUrl != null && savedUrl.isNotEmpty && mounted) {
        _urlController.text = savedUrl;
      }
    } catch (_) {}
  }

  Future<void> _testConnection() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _testing = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final url = _normalizeUrl(_urlController.text.trim());
    final apiClient = context.read<JwtApiClient>();

    try {
      // Temporarily update base URL for testing
      apiClient.updateBaseUrl(url);

      // Test connection by calling a public endpoint
      await apiClient.dio.get('/api/v1/auth/me',
          options: Options(validateStatus: (status) => status != null && status < 500));

      if (!mounted) return;

      setState(() {
        _testing = false;
        _successMessage = '✅ Koneksi berhasil ke server VMS';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _testing = false;
        _errorMessage = _friendlyError(e.toString());
      });
    }
  }

  Future<void> _saveAndContinue() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final url = _normalizeUrl(_urlController.text.trim());

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kServerUrl, url);
      AppConfig.baseUrl = url;
      context.read<JwtApiClient>().updateBaseUrl(url);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Server URL berhasil disimpan'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pushReplacementNamed('/login');
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Gagal menyimpan konfigurasi server';
      });
    }
  }

  String _normalizeUrl(String url) {
    if (url.isEmpty) return url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    url = url.replaceAll(RegExp(r'/+$'), '');
    return url;
  }

  String _friendlyError(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('timeout') || lower.contains('timed out'))
      return 'Koneksi timeout. Periksa jaringan internet Anda.';
    if (lower.contains('network') || lower.contains('socket') ||
        lower.contains('connection') || lower.contains('failed host lookup'))
      return 'Tidak dapat terhubung ke server. Periksa URL dan jaringan internet.';
    if (lower.contains('401') || lower.contains('403'))
      return 'Server merespons tetapi belum terautentikasi (normal).';
    if (lower.contains('404'))
      return 'Server ditemukan tetapi endpoint API tidak tersedia.';
    if (lower.contains('500') || lower.contains('server error'))
      return 'Server sedang bermasalah. Coba beberapa saat lagi.';
    if (lower.contains('certificate') || lower.contains('ssl'))
      return 'Masalah sertifikat SSL. Gunakan HTTP untuk development.';
    return 'Gagal terhubung ke server. Periksa URL dan jaringan.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: _BrandLogo()),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text('Setup Server',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.teal)),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text('Masukkan URL server VMS Backend',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B))),
                    ),
                    const SizedBox(height: 36),
                    if (_errorMessage != null) ...[
                      _ErrorBanner(message: _errorMessage!),
                      const SizedBox(height: 16),
                    ],
                    if (_successMessage != null) ...[
                      _SuccessBanner(message: _successMessage!),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _urlController,
                      focusNode: _urlFocus,
                      decoration: _inputDecoration(
                        label: 'Server URL',
                        icon: Icons.cloud_outlined,
                        hintText: 'https://api.example.com',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      onFieldSubmitted: (_) => _testConnection(),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Server URL tidak boleh kosong';
                        }
                        final url = v.trim();
                        if (!url.startsWith('http://') && !url.startsWith('https://')) {
                          return 'URL harus dimulai dengan http:// atau https://';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: _testing ? null : _testConnection,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.teal,
                                side: const BorderSide(color: Colors.teal),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _testing
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2.4,
                                          color: Colors.teal))
                                  : const Text('Test Koneksi',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: FilledButton(
                              onPressed: _testing ? null : _saveAndContinue,
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Simpan & Lanjut',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _InfoCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF64748B)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 1.8)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.teal.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 10)),
        ],
      ),
      child: const Icon(Icons.domain_rounded, size: 48, color: Colors.white),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded,
              color: Colors.red.shade600, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.red.shade700,
                    height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline_rounded,
              color: Colors.green.shade600, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.green.shade700,
                    height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: Colors.blue.shade600, size: 18),
              const SizedBox(width: 8),
              Text('Informasi',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade800)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• Gunakan URL lengkap dengan protokol (http:// atau https://)\n'
            '• Untuk development, gunakan http://localhost:8000\n'
            '• Untuk production, gunakan https://api.example.com\n'
            '• Pastikan server VMS Backend dapat diakses dari perangkat ini',
            style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade700,
                height: 1.5),
          ),
        ],
      ),
    );
  }
}
