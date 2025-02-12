import 'package:escooter/features/scanner/presentation/widget/manual_entry_form.dart';
import 'package:escooter/features/scanner/presentation/widget/scanner_controls.dart';
import 'package:escooter/features/scanner/presentation/widget/screen_overlay.dart';
import 'package:escooter/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends ConsumerStatefulWidget {
  const QRScannerScreen({super.key});

  @override
  ConsumerState<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends ConsumerState<QRScannerScreen> {
  bool _isTorchOn = false;
  late MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: _isTorchOn,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        _handleScannedCode(barcode.rawValue!);
        break;
      }
    }
  }

  void _handleScannedCode(String code) {
    AppLogger.log('Barcode found! $code');

    // Navigate to scooter details or show error
  }

  void _showManualEntryForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: ManualEntryForm(
          onClose: () => context.pop(context),
          onSubmit: (code) {
            Navigator.pop(context);
            _handleScannedCode(code);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),
          const Positioned.fill(
            child: ScanOverlay(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ScannerControls(
              isTorchOn: _isTorchOn,
              onTorchPressed: () {
                setState(() {
                  _isTorchOn = !_isTorchOn;
                  _scannerController.toggleTorch();
                });
              },
              onManualEntryPressed: _showManualEntryForm,
            ),
          ),
        ],
      ),
    );
  }
}
