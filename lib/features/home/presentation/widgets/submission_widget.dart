import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';
import 'package:leyu_mobile/features/home/domain/entities/micro_task_entity.dart';
import 'package:leyu_mobile/features/home/domain/entities/micro_task_status_enum.dart';
import 'package:leyu_mobile/features/home/presentation/controllers/home_controller.dart';
import 'package:leyu_mobile/features/home/presentation/widgets/audio_player_widget.dart';

class SubmissionWidget extends StatelessWidget {
  SubmissionWidget({super.key});

  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      MicroTaskEntity microTask = _homeController.selectedTaskDetail.value!
          .microTasks[_homeController.selectedMicroTaskIndex.value!];
      if (microTask.acceptanceStatus == MicroTaskStatus.NOT_STARTED) {
        return const SizedBox.shrink();
      }
      if (microTask.submissionAudioUrl != null &&
          microTask.submissionAudioUrl!.isNotEmpty) {
        return Column(children: [
          const SizedBox(height: 20),
          AudioPlayerWidget(audioUrl: microTask.submissionAudioUrl!),
          if (microTask.acceptanceStatus == MicroTaskStatus.REJECTED)
            Container(
              margin: const EdgeInsets.only(top: 12.0),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.red.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cancel, size: 14, color: AppColors.red),
                  SizedBox(width: 4),
                  Text(
                    'Rejected',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
        ]);
      }
      if (microTask.submissionText != null &&
          microTask.submissionText!.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.inputBgColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                microTask.submissionText ?? 'home.tasks.no_submission_text'.tr,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            if (microTask.acceptanceStatus == MicroTaskStatus.REJECTED)
              Container(
                margin: const EdgeInsets.only(top: 12.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.red.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cancel, size: 14, color: AppColors.red),
                    SizedBox(width: 4),
                    Text(
                      'Rejected',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      }
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColors.inputBgColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          'home.tasks.no_submission'.tr,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      );
    });
  }
}
