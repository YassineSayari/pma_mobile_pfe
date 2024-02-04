class User {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final List<String> roles;
  final String image;
  final String gender;
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
    required this.image,
    required this.gender,
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
      gender: json['gender'],
      isEnabled: json['isEnabled'],
      experience: json['experience'],
      title: json['title'],
      hiringDate: DateTime.parse(json['hiringDate']),
    );
  }
}
