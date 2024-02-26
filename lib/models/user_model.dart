class User {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final List<String> roles;
  final String? image;
  final String? nationality;
  final String? address;
  final String gender;
  final String? department;
  final String? company;
  final bool isEnabled;
  final int experience;
  final String title;
  final DateTime hiringDate;

  User({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.roles,
    this.image,
    this.nationality,
    this.address,
    required this.gender,
    this.department,
    this.company,
    required this.isEnabled,
    required this.experience,
    required this.title,
    required this.hiringDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullName: json['fullName'],
      phone: json['phone'],
      email: json['email'],
      roles: List<String>.from(json['roles']),
      image: json['image'],
      nationality: json['nationality'],
      address: json['address'],
      gender: json['gender'],
      department: json['department'],
      company: json['company'],
      isEnabled: json['isEnabled'],
      experience: json['experience'],
      title: json['title'],
      hiringDate: DateTime.parse(json['hiringDate']),
    );
  }
}
