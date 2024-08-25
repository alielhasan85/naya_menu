class TimingHours {
  final Map<String, String> operatingHours;

  TimingHours({
    required this.operatingHours,
  });

  // Convert TimingHours to a map
  Map<String, dynamic> toMap() {
    return {
      'operatingHours': operatingHours,
    };
  }

  // Create TimingHours from a map
  factory TimingHours.fromMap(Map<String, dynamic> data) {
    return TimingHours(
      operatingHours: Map<String, String>.from(data['operatingHours']),
    );
  }
}
