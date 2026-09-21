import 'package:flutter/material.dart';
import 'package:mahder_mobile/core/theme/app_colors.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String? profilePictureUrl;
  final double size;
  final String? firstName;
  final String? lastName;

  const ProfilePictureWidget({
    this.profilePictureUrl,
    this.size = 35.0,
    this.firstName,
    this.lastName,
    super.key});

  @override
  Widget build(BuildContext context) {
    final hasProfilePicture = profilePictureUrl?.isNotEmpty == true;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: hasProfilePicture
            ? DecorationImage(
                image: NetworkImage(profilePictureUrl!),
                fit: BoxFit.cover,
              )
            : null,
        color: hasProfilePicture ? null : AppColors.primary,
        border: Border.all(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
      child: !hasProfilePicture
          ? Center(
              child: Text(
                '${firstName?.substring(0, 1) ?? ''}${lastName?.substring(0, 1) ?? ''}',
                style: TextStyle(fontSize: size / 2.2, color: Colors.white),),
            )
          : null,
    );
  }
}
