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
  final String email;
  final String phoneNumber;
  final String country;
  final String jobTitle;
  final String businessName;
  final bool emailNotification;
  final bool smsNotification;
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
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.businessName,
    this.jobTitle = '',
    this.emailNotification = true,
    this.smsNotification = true,
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

  // Add this copyWith method
  UserModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? country,
    String? jobTitle,
    String? businessName,
    bool? emailNotification,
    bool? smsNotification,
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
      userId: this.userId, // id is not changeable
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      jobTitle: jobTitle ?? this.jobTitle,
      businessName: businessName ?? this.businessName,
      emailNotification: emailNotification ?? this.emailNotification,
      smsNotification: smsNotification ?? this.smsNotification,
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

  // Convert a UserModel into a Map. The keys must correspond to the names of the fields in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
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
  factory UserModel.fromMap(Map<String, dynamic> map, String userId) {
    return UserModel(
      userId: userId,
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
