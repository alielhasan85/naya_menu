class QRCodes {
  final String dineQrCode;
  final Map<String, String> qrCodeColor;
  final Map<String, String> tableQrCodes;

  QRCodes({
    required this.dineQrCode,
    required this.qrCodeColor,
    required this.tableQrCodes,
  });

  // Convert QRCodes to a map
  Map<String, dynamic> toMap() {
    return {
      'dineQrCode': dineQrCode,
      'qrCodeColor': qrCodeColor,
      'tableQrCodes': tableQrCodes,
    };
  }

  // Create QRCodes from a map
  factory QRCodes.fromMap(Map<String, dynamic> data) {
    return QRCodes(
      dineQrCode: data['dineQrCode'],
      qrCodeColor: Map<String, String>.from(data['qrCodeColor']),
      tableQrCodes: Map<String, String>.from(data['tableQrCodes']),
    );
  }
}
