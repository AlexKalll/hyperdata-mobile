import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:leyu_mobile/core/services/onboarding_service.dart';
import 'package:leyu_mobile/core/services/onesignal_service.dart';
import 'package:leyu_mobile/core/utils/message.dart';

import '../../../../../core/cache/local_storage.dart';
import '../../../../../routes/app_routes.dart';
import '../../data/models/new_user.dart';
import '../repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _authRepository;
  final LocalStorage _localStorage;

  AuthUseCase(this._authRepository, this._localStorage);

  Future<String?> register(String phone) async {
    final result = await _authRepository.register("+251$phone");
    return result.fold(
      (failure) {
        showErrorMessage("Registration failed: ${failure.message}");
        return null;
      },
      (response) {
        print(response);
        showSuccessMessage(
          "Registration successful! Please check your phone for the verification code.",
        );
        Get.toNamed(AppRoutes.activateAccount);
        return response;
      },
    );
  }

  Future<bool> activateAccount(
    String verificationId,
    String phone,
    String otp,
  ) async {
    final result = await _authRepository.activateAccount(
      verificationId,
      '+251$phone',
      otp,
    );
    return result.fold(
      (failure) {
        showErrorMessage("Activating account failed: ${failure.message}");
        return false;
      },
      (verificationResponse) {
        _localStorage.saveAccessToken(
          accessToken: verificationResponse.accessToken,
        );
        showSuccessMessage("Account activated successfully!");
        Get.offAllNamed(AppRoutes.registerProfile);
        return true;
      },
    );
  }

  Future<void> registerProfile(NewUser newUser) async {
    final result = await _authRepository.registerProfile(newUser);
    result.fold(
      (failure) =>
          showErrorMessage("Registering profile failed: ${failure.message}"),
      (_) {
        showSuccessMessage("Profile registered successfully!");
        Get.offAllNamed(AppRoutes.login);
      },
    );
  }

  Future<void> login(String phone, String password) async {
    final result = await _authRepository.login('+251$phone', password);
    result.fold(
      (failure) => {showErrorMessage("Login failed: ${failure.message}")},
      (authResponse) async {
        if (checkUserRoleAndRedirect(authResponse.user.role?.name)) {
          showSuccessMessage("Login successful!");
          await _localStorage.saveTokens(
            accessToken: authResponse.accessToken,
            refreshToken: authResponse.refreshToken,
          );
          await _localStorage.saveUser(authResponse.user);

          // Login user to OneSignal
          final userId = authResponse.user.id.toString();
          await OneSignalService.loginUser(userId);

          // Set user tags for segmentation
          await OneSignalService.setUserTags({
            'role': authResponse.user.role?.name ?? 'unknown',
            'phone': authResponse.user.phoneNumber ?? '',
          });

          Get.offAllNamed(AppRoutes.home);
        }
      },
    );
  }

  Future<bool> requestOtp(String phone) async {
    final result = await _authRepository.requestOtp('+251$phone');
    return result.fold(
      (failure) {
        showErrorMessage("Requesting OTP failed: ${failure.message}");
        return false;
      },
      (_) {
        return true;
      },
    );
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    final result = await _authRepository.verifyOtp('+251$phone', otp);
    return result.fold(
      (failure) {
        showErrorMessage("Verifying OTP failed: ${failure.message}");
        return false;
      },
      (_) {
        return true;
      },
    );
  }

  Future<bool> resetPassword(
    String phone,
    String otp,
    String newPassword,
  ) async {
    final result = await _authRepository.resetPassword(
      '+251$phone',
      otp,
      newPassword,
    );
    return result.fold(
      (failure) {
        showErrorMessage("Resetting password failed: ${failure.message}");
        return false;
      },
      (_) {
        return true;
      },
    );
  }

  /// Refresh Token
  Future<void> checkToken() async {
    String? accessToken = await _localStorage.getAccessToken();
    String? refreshToken = await _localStorage.getRefreshToken();

    print(accessToken);

    if (refreshToken != null &&
        refreshToken.isNotEmpty &&
        accessToken != null &&
        accessToken.isNotEmpty) {
      if (_shouldRefreshToken(accessToken)) {
        final result = await _authRepository.refreshAccessToken(refreshToken);
        result.fold(
          (failure) {
            print("Refreshing Token failed: ${failure.message}");
            Get.offAllNamed(AppRoutes.login);
          },
          (tokens) async {
            print("Access token refreshed successfully");
            await _localStorage.saveTokens(
              accessToken: tokens["accessToken"],
              refreshToken: tokens["refreshToken"],
            );
            Get.offAllNamed(AppRoutes.home);
          },
        );
      } else {
        print("Access token is still valid");
        Get.offAllNamed(AppRoutes.home);
      }
    } else {
      print("Either refresh or access token not found");
      // Check if user has seen introduction
      if (OnboardingService.hasSeenIntroduction()) {
        // User has seen introduction, go to login
        Get.offAllNamed(AppRoutes.login);
      } else {
        // First time user, show introduction
        Get.offAllNamed(AppRoutes.introduction);
      }
    }
  }

  Future<void> refreshToken() async {
    String? accessToken = await _localStorage.getAccessToken();
    String? refreshToken = await _localStorage.getRefreshToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final result = await _authRepository.refreshAccessToken(refreshToken);
        result.fold(
          (failure) {
            print("Refreshing Token failed: ${failure.message}");
            Get.offAllNamed(AppRoutes.login);
          },
          (tokens) async {
            print("Access token refreshed successfully");
            await _localStorage.saveTokens(
              accessToken: tokens["accessToken"],
              refreshToken: tokens["refreshToken"],
            );

            // Re-login user to OneSignal after token refresh
            final user = await _localStorage.getUserDetail();
            if (user != null && user.id != null) {
              await OneSignalService.loginUser(user.id!);
            }
          },
        );
      } else {
        print("No Refresh Token found");
        Get.offAllNamed(AppRoutes.login);
      }
    } else {
      print("No Access Token found");
      Get.offAllNamed(AppRoutes.login);
    }
  }

  /// Checks if the token should be refreshed (expires in <= 3 minutes)
  bool _shouldRefreshToken(String token) {
    try {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      if (decodedToken.containsKey("exp")) {
        int expiryTimestamp = decodedToken["exp"] * 1000;
        int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
        int remainingTimeMs = expiryTimestamp - currentTimestamp;
        int remainingTimeMinutes = (remainingTimeMs / (60 * 1000)).floor();
        print("Access token expires in: $remainingTimeMinutes minutes");
        return remainingTimeMinutes <= 3;
      }
    } catch (e) {
      print("Error decoding access token: $e");
    }
    return true;
  }

  bool checkUserRoleAndRedirect(String? role) {
    return role == "Contributor";
  }
}
