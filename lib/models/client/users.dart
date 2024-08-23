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

//part of user profile setting
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
  });

  // Convert a UserModel into a Map. The keys must correspond to the names of the fields in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'country': country,
      'businesName': businessName,
      'jobTitle': jobTitle,
      'emailNotification': emailNotification,
      'smsNotification': smsNotification,
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
      businessName: map['businesName'],
      jobTitle: map['jobTitle'],
      emailNotification: map['emailNotification'] ?? true,
      smsNotification: map['smsNotification'] ?? true,
    );
  }
}
