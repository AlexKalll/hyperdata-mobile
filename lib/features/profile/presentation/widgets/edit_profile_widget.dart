import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';
import 'package:leyu_mobile/core/widgets/button.dart';
import 'package:leyu_mobile/core/widgets/dropdown.dart';
import 'package:leyu_mobile/core/widgets/input_box.dart';
import 'package:leyu_mobile/core/widgets/date_picker.dart';
import 'package:leyu_mobile/features/auth/domain/entities/dialect_entity.dart';
import 'package:leyu_mobile/features/auth/domain/entities/language_entity.dart';
import '../controllers/profile_controller.dart';

class EditProfileWidget extends StatelessWidget {
  const EditProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    final formKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Profile Picture Section
          _buildProfilePictureSection(controller),
          const SizedBox(height: 30),

          // Form Section
          _buildFormSection(formKey , controller),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection(ProfileController controller) {
    return Column(
      children: [
        // Profile Picture
        Stack(
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 3),
              ),
              child: Obx(()=>ClipOval(
                child: controller.profileImage.value.isNotEmpty
                    ? Image.network(
                  controller.profileImage.value,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildDefaultProfileImage(),
                )
                    : _buildDefaultProfileImage(),
              ),),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: controller.pickAndUploadProfilePicture,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: Obx(() => controller.isUploadingProfilePicture.value
                      ? const SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  )
                      : const Icon(
                    Icons.camera_alt,
                    color: AppColors.white,
                    size: 15,
                  )),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultProfileImage() {
    return Container(
      color: AppColors.lightBlue,
      child: const Icon(
        Icons.person,
        size: 60,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildFormSection(GlobalKey<FormState> formKey , ProfileController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            // First Name Field
            InputBoxWidget(
              inputType: InputType.text,
              label: 'profile.first_name'.tr,
              placeHolder: 'profile.first_name_placeholder'.tr,
              controller: controller.firstNameController,
              showLabel: true,
              isOptional: false,
            ),
            const SizedBox(height: 8),

            // Middle Name Field
            InputBoxWidget(
              inputType: InputType.text,
              label: 'profile.middle_name'.tr,
              placeHolder: 'profile.middle_name_placeholder'.tr,
              controller: controller.middleNameController,
              showLabel: true,
              isOptional: false,
            ),
            const SizedBox(height: 8),

            // Last Name Field
            InputBoxWidget(
              inputType: InputType.text,
              label: 'profile.last_name'.tr,
              placeHolder: 'profile.last_name_placeholder'.tr,
              controller: controller.lastNameController,
              showLabel: true,
              isOptional: false,
            ),
            const SizedBox(height: 8),

            // Phone Number Field (Disabled)
            PhoneInputBoxWidget(
              label: 'profile.phone'.tr,
              placeHolder: 'auth.register.phone_placeholder'.tr,
              controller: controller.phoneNumberController,
              showLabel: true,
              enabled: false,
            ),
            const SizedBox(height: 8),

            // Email Field
            InputBoxWidget(
              inputType: InputType.email,
              label: 'profile.email'.tr,
              placeHolder: 'profile.email_placeholder'.tr,
              controller: controller.emailController,
              showLabel: true,
              isOptional: true,
            ),
            const SizedBox(height: 8),

            // Gender Field (Disabled)
            InputBoxWidget(
              inputType: InputType.text,
              label: 'auth.profile.gender'.tr,
              placeHolder: 'auth.profile.gender_placeholder'.tr,
              controller: controller.genderController,
              showLabel: true,
              isOptional: false,
              enabled: false,
            ),
            const SizedBox(height: 8),

            // Birth Date Field (Disabled)
            InputBoxWidget(
              inputType: InputType.text,
              label: 'auth.profile.birth_date'.tr,
              placeHolder: 'auth.profile.birth_date_placeholder'.tr,
              controller: controller.birthDateController,
              showLabel: true,
              isOptional: false,
              enabled: false,
            ),
            const SizedBox(height: 8),

            // Language Field (Disabled)
            InputBoxWidget(
              inputType: InputType.text,
              label: 'auth.profile.language_spoken'.tr,
              placeHolder: 'auth.profile.language_placeholder'.tr,
              controller: controller.languageController,
              showLabel: true,
              isOptional: false,
              enabled: false,
            ),
            const SizedBox(height: 8),

            // Dialect Field (Disabled)
            InputBoxWidget(
              inputType: InputType.text,
              label: 'auth.profile.dialect'.tr,
              placeHolder: 'auth.profile.dialect_placeholder'.tr,
              controller: controller.dialectController,
              showLabel: true,
              isOptional: false,
              enabled: false,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonWidget(
                  text:'profile.cancel_button'.tr,
                  onPressed: (){
                    controller.cancelEdit();
                  },
                  fill: false,
                  width: 150,
                  height: 40,
                  fontSize: 15,
                ),
                const SizedBox(width: 10),
                Obx(() => ButtonWidget(
                  isLoading: controller.isEditingProfile.value,
                  text: 'profile.save_button'.tr,
                  loadingText: 'profile.saving_button'.tr,
                  onPressed: (){
                    if(formKey.currentState!.validate()){
                      controller.saveProfile();
                    }
                  },
                  width: 150,
                  height: 40,
                  fontSize: 15,
                ))
              ],
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ProfileController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
      child: Row(
        children: [
          // Cancel Button
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grayText),
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextButton(
                onPressed: controller.cancelEdit,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  'profile.cancel_button'.tr,
                  style: const TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),

          // Save Button
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: controller.saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  'profile.save_button'.tr,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
