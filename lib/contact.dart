class Contact {
  String name;
  String email;
  String phone;
  String address;
  String date;

  Contact({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'date': date,
  };

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      date: json['date'],
    );
  }
}
