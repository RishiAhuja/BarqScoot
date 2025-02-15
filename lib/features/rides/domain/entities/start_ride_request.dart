class StartRideRequest {
  final String scooterId;
  final String startLocation;

  StartRideRequest({
    required this.scooterId,
    required this.startLocation,
  });

  Map<String, dynamic> toJson() => {
        'scooterId': scooterId,
        'startLocation': startLocation,
      };
}
