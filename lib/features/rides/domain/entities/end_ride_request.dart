class EndRideRequest {
  final String scooterId;
  final String endLocation;

  const EndRideRequest({
    required this.scooterId,
    required this.endLocation,
  });

  Map<String, dynamic> toJson() => {
        'scooterId': scooterId,
        'endLocation': endLocation,
      };
}
