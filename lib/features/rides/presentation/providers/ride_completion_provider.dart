import 'package:flutter_riverpod/flutter_riverpod.dart';

final rideCompletionProvider =
    StateNotifierProvider<RideCompletionNotifier, bool>((ref) {
  return RideCompletionNotifier();
});

class RideCompletionNotifier extends StateNotifier<bool> {
  RideCompletionNotifier() : super(false);

  void setRideJustEnded(bool value) {
    state = value;
  }
}
