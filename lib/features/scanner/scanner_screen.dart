import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:mobile_vms/domain/repositories/qr_operations_repository.dart';

enum ScanState { idle, scanning, resolving, executing, success, error }

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  ScanState _state = ScanState.idle;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final qrRepo = context.watch<QROperationsRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _state == ScanState.scanning
                  ? MobileScanner(
                      onDetect: (capture) {
                        final code = capture.barcodes.firstOrNull?.rawValue;
                        if (code != null && _state == ScanState.scanning) {
                          _handleCodeDetected(code, qrRepo);
                        }
                      },
                    )
                  : _buildStatusWidget(),
            ),
            if (_state == ScanState.scanning)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Scan QR code to check-in visitor',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusWidget() {
    switch (_state) {
      case ScanState.idle:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.qr_code_scanner_rounded, size: 80, color: Colors.teal),
              const SizedBox(height: 24),
              const Text(
                'QR Scanner',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => setState(() => _state = ScanState.scanning),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Start Scanning'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        );
      case ScanState.resolving:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Resolving QR code...'),
            ],
          ),
        );
      case ScanState.executing:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Executing check-in...'),
            ],
          ),
        );
      case ScanState.success:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'Check-in Successful',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => setState(() {
                  _state = ScanState.scanning;
                }),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Scan Another'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        );
      case ScanState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_rounded, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                'Scan Failed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage ?? 'An error occurred',
                  style: TextStyle(color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => setState(() {
                  _state = ScanState.scanning;
                  _errorMessage = null;
                }),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _handleCodeDetected(String code, QROperationsRepository qrRepo) async {
    setState(() {
      _state = ScanState.resolving;
      _errorMessage = null;
    });

    try {
      // Resolve scan (preview without execution)
      final resolution = await qrRepo.resolveScan(code);

      if (!resolution.valid) {
        setState(() {
          _state = ScanState.error;
          _errorMessage = resolution.warnings.isNotEmpty
              ? resolution.warnings.join(', ')
              : 'Invalid QR code';
        });
        return;
      }

      // Execute check-in
      setState(() => _state = ScanState.executing);
      await qrRepo.executeCheckIn(token: code);

      setState(() => _state = ScanState.success);
    } catch (e) {
      setState(() {
        _state = ScanState.error;
        _errorMessage = e.toString();
      });
    }
  }
}
