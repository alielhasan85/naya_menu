class Operations {
  final int tables;
  final List<String> staff;
  final Map<String, double> extraCharges;
  final List<String> serviceOptions;
  final List<String> deviceManagement;

  Operations({
    required this.tables,
    this.staff = const [],
    this.extraCharges = const {},
    this.serviceOptions = const [],
    this.deviceManagement = const [],
  });

  // Convert Operations to a map
  Map<String, dynamic> toMap() {
    return {
      'tables': tables,
      'staff': staff,
      'extraCharges': extraCharges,
      'serviceOptions': serviceOptions,
      'deviceManagement': deviceManagement,
    };
  }

  // Create Operations from a map
  factory Operations.fromMap(Map<String, dynamic> data) {
    return Operations(
      tables: data['tables'],
      staff: List<String>.from(data['staff']),
      extraCharges: Map<String, double>.from(data['extraCharges']),
      serviceOptions: List<String>.from(data['serviceOptions']),
      deviceManagement: List<String>.from(data['deviceManagement']),
    );
  }
}
