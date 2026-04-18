import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/services/onesignal_service.dart';
import 'package:leyu_mobile/core/utils/message.dart';
import 'package:leyu_mobile/core/cache/local_storage.dart';
import 'package:leyu_mobile/features/home/presentation/controllers/home_controller.dart';
import 'package:leyu_mobile/features/profile/domain/usecases/profile_usecase.dart';
import 'package:leyu_mobile/features/auth/data/models/user.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final LocalStorage _localStorage;
  final ProfileUseCase _profileUseCase;

  ProfileController(this._localStorage, this._profileUseCase);

  // Profile Data
  RxBool isLoadingProfile = false.obs;
  RxString profileName = ''.obs;
  RxString profileEmail = ''.obs;
  RxString profileStatus = 'Active'.obs;
  RxString profileImage = ''.obs;
  RxString profilePhone = ''.obs;
  RxBool isEditingProfile = false.obs;

  // Additional Profile Data (Read-only)
  RxString profileGender = ''.obs;
  RxString profileBirthDate = ''.obs;
  RxString profileLanguage = ''.obs;
  RxString profileDialect = ''.obs;

  // Form Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Read-only Form Controllers
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController dialectController = TextEditingController();

  // Profile Picture Upload
  final ImagePicker _imagePicker = ImagePicker();
  RxBool isUploadingProfilePicture = false.obs;

  // Change Password
  RxBool isChangingPassword = false.obs;

  HomeController get _homeController => Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      isLoadingProfile.value = true;
      User? user = await _profileUseCase.getUserProfile();
      if (user != null) {
        profileName.value =
            '${user.firstName?.capitalizeFirst ?? ''} ${user.middleName?.capitalizeFirst ?? ''} ${user.lastName?.capitalizeFirst ?? ''}'
                .trim();
        profileEmail.value = user.email ?? '';
        profilePhone.value = user.phoneNumber ?? '';
        profileImage.value = user.profilePicture ?? '';
        profileStatus.value = (user.isActive ?? true) ? 'Active' : 'Inactive';

        // Load additional read-only fields
        profileGender.value = user.gender ?? '';
        profileBirthDate.value = user.birthDate ?? '';
        profileLanguage.value = user.language?.name ?? '';
        profileDialect.value = user.dialect?.name ?? '';

        // Initialize form controllers with user data
        _initializeControllers();
      }
    } catch (e) {
      e.printError();
      print('Error loading user profile: $e');
    } finally {
      isLoadingProfile.value = false;
    }
  }

  void _initializeControllers() {
    // Split the full name into individual fields
    final nameParts = profileName.value.split(' ');
    firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
    middleNameController.text = nameParts.length > 1 ? nameParts[1] : '';
    lastNameController.text =
        nameParts.length > 2 ? nameParts.sublist(2).join(' ') : '';

    emailController.text = profileEmail.value;

    // Initialize read-only controllers
    phoneNumberController.text = profilePhone.value.substring(4);
    genderController.text = profileGender.value == 'Male'
        ? 'auth.profile.gender_male'.tr
        : profileGender.value == 'Female'
            ? 'auth.profile.gender_female'.tr
            : profileGender.value;
    birthDateController.text = profileBirthDate.value;
    languageController.text = profileLanguage.value;
    dialectController.text = profileDialect.value;
  }

  Future<void> pickAndUploadProfilePicture() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        isUploadingProfilePicture.value = true;
        String? profilePicture =
            await _profileUseCase.uploadProfilePicture(image.path);
        if (profilePicture != null) {
          profileImage.value = profilePicture;
          _homeController.userProfilePic.value = profilePicture;
          showSuccessMessage('Profile picture updated successfully');
        }
        isUploadingProfilePicture.value = false;
      }
    } catch (e) {
      isUploadingProfilePicture.value = false;
      showErrorMessage('Failed to upload profile picture');
    }
  }

  Future<void> saveProfile() async {
    try {
      // Prepare profile data for API
      final profileData = {
        'first_name': firstNameController.text,
        'middle_name': middleNameController.text,
        'last_name': lastNameController.text,
        'email': emailController.text,
      };
      isEditingProfile.value = true;
      final success = await _profileUseCase.updateUserProfile(profileData);
      isEditingProfile.value = false;
      if (success) {
        profileName.value =
            '${firstNameController.text} ${middleNameController.text} ${lastNameController.text}'
                .trim();
        profileEmail.value = emailController.text;
        _localStorage.updateUserName(
            firstName: firstNameController.text,
            middleName: middleNameController.text,
            lastName: lastNameController.text);
        _homeController.userFirstName.value = firstNameController.text;
        _homeController.userMiddleName.value = middleNameController.text;
        Get.back();
        showSuccessMessage('Profile updated successfully');
      } else {
        showErrorMessage('Failed to update profile');
      }
    } catch (e) {
      isEditingProfile.value = false;
      showErrorMessage('Failed to update profile');
    }
  }

  void cancelEdit() {
    _initializeControllers();
    Get.back();
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      isChangingPassword.value = true;
      final success =
          await _profileUseCase.changePassword(currentPassword, newPassword);
      isChangingPassword.value = false;
      if (success) {
        Get.back();
        showSuccessMessage('Password changed successfully');
      } else {
        showErrorMessage('Failed to change password');
      }
    } catch (e) {
      isChangingPassword.value = false;
      showErrorMessage('Failed to change password');
    }
  }

  void logout() async {
    // Logout from OneSignal
    await OneSignalService.logoutUser();

    // Clear local storage
    _localStorage.clearStorage();

    // Navigate to login
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    genderController.dispose();
    birthDateController.dispose();
    languageController.dispose();
    dialectController.dispose();
    super.onClose();
  }
}
