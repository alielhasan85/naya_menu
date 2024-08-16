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
  final String name;
  final String email; // This will be retrieved from FirebaseAuth
  final String phoneNumber;
  final String address;
  final String country;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.country,
  });

  // Convert a UserModel into a Map. The keys must correspond to the names of the fields in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'country': country,
    };
  }

  // Create a UserModel from a Map (from Firestore).
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      country: map['country'],
    );
  }
}
