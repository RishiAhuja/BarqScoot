import 'dart:async';
import 'dart:convert';
import 'package:escooter/core/configs/services/api/base_api.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:escooter/utils/logger.dart';

class ScooterLocation {
  final double latitude;
  final double longitude;
  final double batteryLevel;

  ScooterLocation({
    required this.latitude,
    required this.longitude,
    required this.batteryLevel,
  });

  factory ScooterLocation.fromJson(Map<String, dynamic> json) {
    return ScooterLocation(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      batteryLevel: json['batteryLevel'] as double,
    );
  }
}

final scooterLocationProvider =
    StreamNotifierProvider<ScooterLocationNotifier, ScooterLocation?>(
  () => ScooterLocationNotifier(),
);

class ScooterLocationNotifier extends StreamNotifier<ScooterLocation?> {
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  static const _maxReconnectAttempts = 3;
  static const _reconnectDelay = Duration(seconds: 2);
  int _reconnectAttempts = 0;
  bool _isConnecting = false;

  @override
  Stream<ScooterLocation?> build() {
    return Stream.empty();
  }

  void connectToScooter(String scooterId) {
    if (_isConnecting) return;
    _reconnectAttempts = 0;
    _connect(scooterId);
  }

  Future<void> _connect(String scooterId) async {
    if (_isConnecting) return;
    _isConnecting = true;

    try {
      // Close existing connections
      await _channel?.sink.close();
      _reconnectTimer?.cancel();
      // AppLogger.log(
      //     'Connecting to scooter ${BaseApi.socketScooterUrl}scooters/ws2?scooterId=$scooterId');
      final wsUrl = Uri.parse(
        '${BaseApi.socketScooterUrl}/scooters/ws2?scooterId=$scooterId',
      );

      // Set initial state to loading
      state = const AsyncValue.loading();

      // Attempt WebSocket connection with timeout
      _channel = WebSocketChannel.connect(wsUrl);

      _isConnecting = false;
      state = const AsyncValue.data(null);

      _channel!.stream.listen(
        (data) {
          try {
            final json = jsonDecode(data);
            final location = ScooterLocation.fromJson(json);
            state = AsyncValue.data(location);
            _reconnectAttempts = 0;
            // AppLogger.log(
            //     'Location update received: ${location.latitude}, ${location.longitude}');
          } catch (e, stack) {
            // AppLogger.error('Error parsing location data',
            //     error: e, stackTrace: stack);
            state = AsyncValue.error(e, stack);
          }
        },
        onError: (error, stack) {
          // AppLogger.error('WebSocket error', error: error, stackTrace: stack);
          state = AsyncValue.error(error, stack);
          _isConnecting = false;
          _handleConnectionError(scooterId);
        },
        onDone: () {
          // AppLogger.log('WebSocket connection closed normally');
          _isConnecting = false;
          _handleConnectionError(scooterId);
        },
        cancelOnError: false,
      );
    } on TimeoutException catch (e, stack) {
      // AppLogger.error('WebSocket connection timeout',
      // error: e, stackTrace: stack);
      _isConnecting = false;
      state = AsyncValue.error(e, stack);
      _handleConnectionError(scooterId);
    } catch (e, stack) {
      // AppLogger.error('WebSocket connection failed',
      //     error: e, stackTrace: stack);
      _isConnecting = false;
      state = AsyncValue.error(e, stack);
      _handleConnectionError(scooterId);
    }
  }

  void _handleConnectionError(String scooterId) {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      // AppLogger.error(
      //     'Max reconnection attempts reached for scooter $scooterId');
      state = AsyncValue.error(
        'Connection failed after $_maxReconnectAttempts attempts',
        StackTrace.current,
      );
      return;
    }

    _reconnectAttempts++;
    // AppLogger.log(
    //     'Attempting reconnection $_reconnectAttempts/$_maxReconnectAttempts');

    _reconnectTimer = Timer(_reconnectDelay * _reconnectAttempts, () {
      _connect(scooterId);
    });
  }
}
