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
  final String id; // Firebase UID
  final String name; // Required
  final String email; // Retrieved from FirebaseAuth
  final String phoneNumber; // Required
  final String country;
  final String jobTitle; // Required
  final String businessName; // Required
  final bool emailNotification; // Optional, default true
  final bool smsNotification; // Optional, default true

  final List<String> staff; // List of staff/team members, could be empty
  final DateTime createdAt; // Date of account creation
  final int loginCount; // Number of times the user has logged in
  final String
      subscriptionType; // Type of subscription (e.g., free, basic, premium)
  final double
      totalPaid; // Total amount the user has paid since account creation
  final List<Map<String, dynamic>> paymentHistory; // List of payment records
  final bool isActive; // Whether the user account is active
  final DateTime? lastLogin; // Date and time of the last login
  final Map<String, dynamic>? userSettings; // Any user-specific settings

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.businessName,
    this.jobTitle = '',
    this.emailNotification = true, // Default to true
    this.smsNotification = true, // Default to true
    this.staff = const [], // Default to an empty list
    DateTime? createdAt, // Optional, will default to now
    this.loginCount = 0, // Default to 0
    this.subscriptionType = 'free', // Default to 'free'
    this.totalPaid = 0.0, // Default to 0.0
    this.paymentHistory = const [], // Default to an empty list
    this.isActive = true, // Default to active
    this.lastLogin, // Can be null if the user hasn't logged in yet
    this.userSettings, // Optional user settings
  }) : createdAt = createdAt ?? DateTime.now(); // Set to now if not provided

  // Convert a UserModel into a Map. The keys must correspond to the names of the fields in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'country': country,
      'businessName': businessName,
      'jobTitle': jobTitle,
      'emailNotification': emailNotification,
      'smsNotification': smsNotification,
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
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      country: map['country'],
      businessName: map['businessName'],
      jobTitle: map['jobTitle'],
      emailNotification: map['emailNotification'] ?? true,
      smsNotification: map['smsNotification'] ?? true,
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
