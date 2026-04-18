import 'package:leyu_mobile/core/utils/message.dart';
import 'package:leyu_mobile/features/auth/data/models/user.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileUseCase {
  final ProfileRepository _profileRepository;

  ProfileUseCase(this._profileRepository);

  Future<User?> getUserProfile() async {
    final result = await _profileRepository.getUserProfile();
    return result.fold(
      (failure) {
        showErrorMessage("Failed to fetch profile: ${failure.message}");
        return null;
      },
      (user) => user,
    );
  }

  Future<bool> updateUserProfile(Map<String, dynamic> profileData) async {
    final result = await _profileRepository.updateUserProfile(profileData);
    return result.fold(
      (failure) {
        showErrorMessage("Failed to update profile: ${failure.message}");
        return false;
      },
      (success) => success,
    );
  }

  Future<String?> uploadProfilePicture(String imagePath) async {
    final result = await _profileRepository.uploadProfilePicture(imagePath);
    return result.fold(
      (failure) {
        showErrorMessage("Failed to upload profile picture: ${failure.message}");
        return null;
      },
      (imageUrl) => imageUrl,
    );
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    final result = await _profileRepository.changePassword(currentPassword, newPassword);
    return result.fold(
      (failure) {
        showErrorMessage("Failed to change password: ${failure.message}");
        return false;
      },
      (success) => success,
    );
  }
}
