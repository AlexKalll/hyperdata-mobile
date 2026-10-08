import 'package:mahder_mobile/features/auth/data/models/dialect.dart';
import 'package:mahder_mobile/features/auth/data/models/language.dart';

int? _parseScore(dynamic value) {
  if (value is num) {
    return value.toInt();
  }
  if (value is Map) {
    return _parseScore(value['score']);
  }
  return value == null ? null : int.tryParse(value.toString());
}

class User {
  final String? id;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? profilePicture;
  final String? gender;
  final String? birthDate;
  final bool? isActive;
  final String? roleId;
  final Role? role;
  final Language? language;
  final Dialect? dialect;
  final int? score;

  User({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.profilePicture,
    this.gender,
    this.birthDate,
    this.isActive,
    this.roleId,
    this.role,
    this.language,
    this.dialect,
    this.score,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      profilePicture: json['profile_picture'],
      gender: json['gender'],
      birthDate: json['birth_date'] != null ? json['birth_date'].toString().split("T")[0] : null,
      isActive: json['is_active'],
      roleId: json['role_id'],
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      language: json['language'] != null ? Language.fromJson(json['language']) : null,
      dialect: json['dialect'] != null ? Dialect.fromJson(json['dialect']) : null,
      score: _parseScore(json['score'])
    );
  }
}

class Role {
  final String? id;
  final String? name;

  Role({
    this.id,
    this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }
}