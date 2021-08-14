// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.phone,
    this.identificationCard,
    this.created,
    this.modified,
    this.status,
  });

  String id;
  String firstName;
  String lastName;
  String email;
  String password;
  String phone;
  String identificationCard;
  DateTime created;
  DateTime modified;
  String status;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        identificationCard: json["IdentificationCard"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "phone": phone,
        "IdentificationCard": identificationCard,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
        "status": status,
      };
}
