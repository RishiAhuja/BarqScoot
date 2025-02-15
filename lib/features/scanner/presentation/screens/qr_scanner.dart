import 'package:escooter/common/router/app_router.dart';
import 'package:escooter/features/rides/domain/usecases/start_ride_usecase.dart';
import 'package:escooter/features/scanner/presentation/provider/start_ride_provider.dart';
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

  void _handleScannedCode(String code) async {
    try {
      AppLogger.log('Scooter ID found: $code');

      // Pause scanner while processing
      _scannerController.stop();

      final result = await ref.read(startRideUseCaseProvider)(
        params: StartRideParams(scooterId: code),
      );

      if (!mounted) return;

      result.fold(
        (failure) {
          AppLogger.error('Failed to start ride: ${failure.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () => _handleScannedCode(code),
              ),
            ),
          );
        },
        (_) {
          AppLogger.log('Ride started successfully');
          context.push(AppPaths.activeRide);
        },
      );
    } catch (e) {
      AppLogger.error('Error processing QR code: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to process QR code: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Resume scanner
      if (mounted) _scannerController.start();
    }
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
            context.pop(context);
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
          onPressed: () => context.push(AppPaths.home),
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
