import 'dart:async';
import 'package:flutter/material.dart';

class RideTimer extends StatefulWidget {
  final DateTime startTime;
  final double distanceCovered;

  const RideTimer({
    super.key,
    required this.startTime,
    required this.distanceCovered,
  });

  @override
  State<RideTimer> createState() => _RideTimerState();
}

class _RideTimerState extends State<RideTimer> {
  late Timer _timer;
  late Duration _elapsed;
  static const double _minuteRate = 0.15;
  static const double _distanceRate = 0.5;

  double get _estimatedCost {
    final timeBasedCost = _elapsed.inMinutes * _minuteRate;
    final distanceBasedCost = widget.distanceCovered * _distanceRate;
    return timeBasedCost + distanceBasedCost;
  }

  @override
  void initState() {
    super.initState();
    _elapsed = DateTime.now().difference(widget.startTime);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed = DateTime.now().difference(widget.startTime);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _elapsed.inHours;
    final minutes = _elapsed.inMinutes.remainder(60);
    final seconds = _elapsed.inSeconds.remainder(60);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Time Elapsed',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            Text(
              '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${widget.distanceCovered.toStringAsFixed(2)} km',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Estimated Cost',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            Text(
              '﷼${_estimatedCost.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '﷼${_minuteRate}/min + ﷼${_distanceRate}/km',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
