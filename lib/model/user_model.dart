import 'dart:convert';

class User {
  final String userId;
  User({
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
