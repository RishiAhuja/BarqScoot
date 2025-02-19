import 'package:escooter/common/router/app_router.dart';
import 'package:escooter/features/rides/domain/usecases/start_ride_usecase.dart';
import 'package:escooter/features/rides/presentation/providers/ride_provider.dart';
import 'package:escooter/features/scanner/presentation/provider/start_ride_provider.dart';
import 'package:escooter/features/scanner/presentation/widget/manual_entry_form.dart';
import 'package:escooter/features/scanner/presentation/widget/scanner_controls.dart';
import 'package:escooter/features/scanner/presentation/widget/screen_overlay.dart';
import 'package:escooter/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:math' as math;

class QRScannerScreen extends ConsumerStatefulWidget {
  const QRScannerScreen({super.key});

  @override
  ConsumerState<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends ConsumerState<QRScannerScreen> {
  bool _isTorchOn = false;
  late MobileScannerController _scannerController;
  bool _isProcessing = false;

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
    if (_isProcessing) return;

    try {
      setState(() {
        _isProcessing = true;
      });

      AppLogger.log('Scooter ID found: $code');
      _scannerController.stop();

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const LoadingDialog(
            message: 'Starting your ride...',
          ),
        );
      }

      final result = await ref.read(startRideUseCaseProvider)(
        params: StartRideParams(scooterId: code),
      );

      if (!mounted) return;

      // Close loading dialog
      context.pop();

      await result.fold(
        (failure) async {
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
        (_) async {
          AppLogger.log('Ride started successfully');
          // Refresh rides data before navigation
          await ref.read(ridesProvider.notifier).refresh();
          // Use go instead of push to replace the current screen
          if (mounted) context.go(AppPaths.activeRide);
        },
      );
    } catch (e) {
      AppLogger.error('Error processing QR code: $e');
      if (!mounted) return;

      // Close loading dialog if open
      Navigator.maybeOf(context)?.pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to process QR code: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        _scannerController.start();
      }
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

class LoadingDialog extends StatefulWidget {
  final String message;
  final Color? color;

  const LoadingDialog({
    super.key,
    required this.message,
    this.color,
  });

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * math.pi,
                  child: child,
                );
              },
              child: Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.color ?? theme.colorScheme.primary,
                    width: 3,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
                child: Icon(
                  Icons.electric_scooter,
                  color: widget.color ?? theme.colorScheme.primary,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
