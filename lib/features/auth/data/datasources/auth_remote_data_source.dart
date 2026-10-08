import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:mahder_mobile/core/utils/message.dart';
import 'package:mahder_mobile/features/auth/data/models/new_user.dart';

import '../../../../../core/api/api_client.dart';
import '../models/login_response.dart';
import '../models/verification_response.dart';
class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<String> register(String phone) async {
    try {
      final response = await _apiClient.post('/iam/users/sign-up', data: {
        'phone_number': phone,
      });
      return response.data["data"]["verification_id"];
    }
    catch (e) {
      rethrow;
    }
  }

  Future<VerificationResponse> activateAccount(String verificationId , String phoneNumber , String otp) async {
    try {
      final response = await _apiClient.post(
          '/iam/users/verify/$verificationId',
          data: {
            'phone': phoneNumber,
            'code': otp,
          }
      );
      return VerificationResponse.fromJson(response.data["data"]);
    }
    catch (e) {
      rethrow;
    }
  }

  Future<void> registerProfile(NewUser newUser) async {
    try {
      await _apiClient.patch('/iam/users', data: newUser.toJson());
    }
    catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse> login(String phone, String password) async {
    try{
    final response = await _apiClient.post('/iam/auth/mobile_login', data: {
      'username': phone,
      'password': password,
      "device_token": "string",
      "device_type": "android",
    });
    return LoginResponse.fromJson(response.data);
    }
    catch (e) {
      rethrow;
    }
  }

  Future<Map<String , dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post(
          '/iam/auth/refresh-token',
          data: {'refresh_token': refreshToken}
      );
      return {
        "accessToken": response.data["data"]["access_token"],
        "refreshToken": response.data["data"]["refresh_token"]
      };
    }
    catch (e) {
      rethrow;
    }
  }

  Future<void> requestOtp(String phoneNumber) async {
    try {
      final response = await _apiClient.post('/iam/auth/forgot-password' , data: {
        'username': phoneNumber,
      });
    }
    catch (e) {
      rethrow;
    }
  }

  Future<void> verifyOtp(String phoneNumber , String otp) async {
    try {
      final response = await _apiClient.post('/iam/auth/verify-otp', data: {
        'username': phoneNumber,
        'code': otp,
      });
    }
    catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String phone, String otp , String newPassword) async {
    try{
    final response = await _apiClient.post('/iam/auth/reset-password', data: {
      'username': phone,
      'code': otp,
      'password': newPassword,
    });
  }
    catch (e) {
      rethrow;
    }
  }

}
