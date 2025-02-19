import 'dart:async';
import 'dart:convert';
import 'package:escooter/core/configs/services/api/base_api.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escooter/utils/logger.dart';

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

  @override
  Stream<ScooterLocation?> build() {
    return Stream.empty();
  }

  void connectToScooter(String scooterId) {
    _channel?.sink.close();

    final wsUrl = Uri.parse(
        '${BaseApi.socketScooterUrl}/scooters/ws2?scooterId=$scooterId');
    _channel = WebSocketChannel.connect(wsUrl);

    state = AsyncValue.data(null);

    _channel!.stream.listen(
      (data) {
        try {
          final json = jsonDecode(data);
          final location = ScooterLocation.fromJson(json);
          state = AsyncValue.data(location);
          AppLogger.log('Received scooter location update: $data');
        } catch (e) {
          AppLogger.error('Error parsing scooter location', error: e);
        }
      },
      onError: (error) {
        AppLogger.error('WebSocket error', error: error);
        state = AsyncValue.error(error, StackTrace.current);
      },
      onDone: () {
        AppLogger.log('WebSocket connection closed');
      },
    );
  }
}
