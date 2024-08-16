class Country {
  final String name;
  final String dialCode;

  Country({required this.name, required this.dialCode});
}

final List<Country> countries = [
  Country(name: "Afghanistan", dialCode: "+93"),
  Country(name: "Albania", dialCode: "+355"),
  Country(name: "Algeria", dialCode: "+213"),
  Country(name: "Andorra", dialCode: "+376"),
  Country(name: "Angola", dialCode: "+244"),
  // Add all other countries here...
];
