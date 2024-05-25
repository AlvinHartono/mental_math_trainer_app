class User {
  final String username;
  final String email;

  User({
    required this.username,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
    );
  }
}
