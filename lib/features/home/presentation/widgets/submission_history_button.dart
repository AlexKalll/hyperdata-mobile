import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';
import 'package:leyu_mobile/features/home/domain/entities/micro_task_status_enum.dart';
import 'package:leyu_mobile/features/home/presentation/controllers/home_controller.dart';

class SubmissionHistoryButton extends StatelessWidget {
  const SubmissionHistoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Obx(() {
      // Get current micro task
      final microTask = controller.selectedTaskDetail.value!
          .microTasks[controller.selectedMicroTaskIndex.value!];

      // Only show button if micro task has been started (has previous submissions)
      if (microTask.acceptanceStatus == MicroTaskStatus.NOT_STARTED) {
        return const SizedBox.shrink();
      }

      return InkWell(
        onTap: () {
          controller.showSubmissionHistoryBottomSheet(microTask.id);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history_rounded,
                color: AppColors.primary,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                'History',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
