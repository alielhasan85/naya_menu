/* account setting to control the page of the client (will have access to read write menu and access to report also he will pay), 
the user will have this data: 
 - personal information: 
    first name 
    last name
    job title
    comnpany name
 - login information
    email 
    password 
    phone number
  - email notification
  - SMS notificatio
  - teams  (maybe need to creat a new model for team)
  - subscription {base , essential, premium}
  - invoice
  - billing and card


*/

class UserModel {
  final String userId;
  final String name;
  final String jobTitle;
  final Map<String, dynamic> contact; // Map to store contact details
  final Map<String, dynamic> address; // Map to store address information
  final String businessName;
  final Map<String, bool>
      notifications; // Map to store notification preferences
  final List<String> staff;
  final DateTime createdAt;
  final int loginCount;
  final String subscriptionType;
  final double totalPaid;
  final List<Map<String, dynamic>> paymentHistory;
  final bool isActive;
  final DateTime? lastLogin;
  final Map<String, dynamic>? userSettings;

  UserModel({
    required this.userId,
    required this.name,
    required this.contact, // Map storing 'email', 'phoneNumber', and 'countryCode'
    required this.address, // Map storing address information
    required this.businessName,
    this.jobTitle = '',
    this.notifications = const {
      'emailNotification': true,
      'smsNotification': true
    }, // Notifications map
    this.staff = const [],
    DateTime? createdAt,
    this.loginCount = 0,
    this.subscriptionType = 'free',
    this.totalPaid = 0.0,
    this.paymentHistory = const [],
    this.isActive = true,
    this.lastLogin,
    this.userSettings,
  }) : createdAt = createdAt ?? DateTime.now();

  // Add this copyWith method to update specific fields
  UserModel copyWith({
    String? name,
    String? jobTitle,
    Map<String, dynamic>? contact,
    Map<String, dynamic>? address,
    String? businessName,
    Map<String, bool>? notifications,
    List<String>? staff,
    DateTime? createdAt,
    int? loginCount,
    String? subscriptionType,
    double? totalPaid,
    List<Map<String, dynamic>>? paymentHistory,
    bool? isActive,
    DateTime? lastLogin,
    Map<String, dynamic>? userSettings,
  }) {
    return UserModel(
      userId: this.userId, // userId remains unchanged
      name: name ?? this.name,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      businessName: businessName ?? this.businessName,
      notifications: notifications ?? this.notifications,
      staff: staff ?? this.staff,
      createdAt: createdAt ?? this.createdAt,
      loginCount: loginCount ?? this.loginCount,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      totalPaid: totalPaid ?? this.totalPaid,
      paymentHistory: paymentHistory ?? this.paymentHistory,
      isActive: isActive ?? this.isActive,
      lastLogin: lastLogin ?? this.lastLogin,
      userSettings: userSettings ?? this.userSettings,
    );
  }

  // Convert a UserModel into a Map. The keys must correspond to the field names in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'jobTitle': jobTitle,
      'contact':
          contact, // Contact details map (phoneNumber, countryCode, email)
      'address': address, // Address details map
      'businessName': businessName,
      'notifications': notifications, // Notifications map
      'staff': staff,
      'createdAt': createdAt.toIso8601String(),
      'loginCount': loginCount,
      'subscriptionType': subscriptionType,
      'totalPaid': totalPaid,
      'paymentHistory': paymentHistory,
      'isActive': isActive,
      'lastLogin': lastLogin?.toIso8601String(),
      'userSettings': userSettings,
    };
  }

  // Create a UserModel from a Map (from Firestore).
  factory UserModel.fromMap(Map<String, dynamic> map, String userId) {
    return UserModel(
      userId: userId,
      name: map['name'],
      jobTitle: map['jobTitle'],
      contact: Map<String, dynamic>.from(map['contact']), // Get contact map
      address: Map<String, dynamic>.from(map['address']), // Get address map
      businessName: map['businessName'],
      notifications: Map<String, bool>.from(map['notifications'] ??
          {'emailNotification': true, 'smsNotification': true}),
      staff: List<String>.from(map['staff'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      loginCount: map['loginCount'] ?? 0,
      subscriptionType: map['subscriptionType'] ?? 'free',
      totalPaid: map['totalPaid'] ?? 0.0,
      paymentHistory:
          List<Map<String, dynamic>>.from(map['paymentHistory'] ?? []),
      isActive: map['isActive'] ?? true,
      lastLogin:
          map['lastLogin'] != null ? DateTime.parse(map['lastLogin']) : null,
      userSettings: map['userSettings'],
    );
  }
}
