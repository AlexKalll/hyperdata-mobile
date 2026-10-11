import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/models/user.dart';

class LocalStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> saveTokens(
      {required String accessToken, required String refreshToken}) async {
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<void> saveAccessToken({required String accessToken}) async {
    await storage.write(key: 'access_token', value: accessToken);
  }

  Future<void> saveUserDetail({
    required String id,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String role,
  }) async {
    await storage.write(key: 'user_id', value: id);
    await storage.write(key: 'first_name', value: firstName);
    await storage.write(key: 'last_name', value: lastName);
    await storage.write(key: 'phone_number', value: phoneNumber);
  }

  Future<void> saveUser(User user) async {
    await storage.write(key: 'user_id', value: user.id);
    await storage.write(key: 'first_name', value: user.firstName);
    await storage.write(key: "middle_name", value: user.middleName);
    await storage.write(key: 'last_name', value: user.lastName);
    await storage.write(key: 'phone_number', value: user.phoneNumber);
    await storage.write(key: 'profile_picture', value: user.profilePicture);
    await storage.write(
        key: 'must_change_password', value: user.mustChangePassword.toString());
  }

  Future<String?> getAccessToken() async {
    try {
      return await storage.read(key: 'access_token');
    } catch (e) {
      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await storage.read(key: 'refresh_token');
    } catch (e) {
      return null;
    }
  }

  Future<User?> getUserDetail() async {
    try {
      Map<String, dynamic> userJson = {
        "id": await storage.read(key: 'user_id'),
        "first_name": await storage.read(key: 'first_name'),
        "middle_name": await storage.read(key: 'middle_name'),
        "last_name": await storage.read(key: 'last_name'),
        "phone_number": await storage.read(key: 'phone_number'),
        "profile_picture": await storage.read(key: 'profile_picture'),
        "must_change_password":
            await storage.read(key: 'must_change_password') == 'true',
      };
      return User.fromJson(userJson);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserName(
      {required String firstName,
      required String middleName,
      required String lastName}) async {
    await storage.write(key: 'first_name', value: firstName);
    await storage.write(key: 'middle_name', value: middleName);
    await storage.write(key: 'last_name', value: lastName);
  }

  Future<void> clearStorage() async {
    await storage.deleteAll();
  }
}
