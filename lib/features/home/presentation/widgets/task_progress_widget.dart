import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/features/home/presentation/controllers/home_controller.dart';
import 'package:leyu_mobile/features/home/domain/entities/micro_task_status_enum.dart';

import '../../../../core/theme/app_colors.dart';

class TaskProgressWidget extends StatelessWidget {
  const TaskProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    return Obx(() {
      int totalSubTasks =
          controller.selectedTaskDetail.value?.microTasks.length ?? 0;
      int currentSubtaskIndex = controller.selectedMicroTaskIndex.value ?? 0;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 8,
            child: Row(
              children: List.generate(totalSubTasks, (index) {
                return Expanded(
                  child: _singleSubTaskProgress(
                      index, currentSubtaskIndex, totalSubTasks, context),
                );
              }),
            ),
          ),
          const SizedBox(width: 8),
          _progressNumber(currentSubtaskIndex + 1, totalSubTasks),
        ],
      );
    });
  }

  Widget _singleSubTaskProgress(int index, int currentSubtaskIndex, int totalSubTasks, BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final microTask = controller.selectedTaskDetail.value?.microTasks[index];
    final status = microTask?.acceptanceStatus ?? MicroTaskStatus.NOT_STARTED;
    final hasSubmitted = controller.recordedAudioFiles.containsKey(microTask?.id ?? '') || controller.savedTextOutputs.containsKey(microTask?.id ?? '');

    Color statusColor = _getStatusColor(status, hasSubmitted);

    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: index == currentSubtaskIndex ? status == MicroTaskStatus.NOT_STARTED?AppColors.primary.withOpacity(0.4) : statusColor.withOpacity(0.4) : statusColor,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 1),
        height: 10,
      ),
    );
  }

  Color _getStatusColor(MicroTaskStatus status , bool hasSubmitted) {
    if(hasSubmitted && status == MicroTaskStatus.NOT_STARTED){
      return AppColors.primary;
    }
    switch (status) {
      case MicroTaskStatus.REJECTED:
        return AppColors.red;
      case MicroTaskStatus.NOT_STARTED:
        return const Color(0xFFDFDFDF); // Gray for not started (more visible)
      case MicroTaskStatus.APPROVED:
        return AppColors.green;
      case MicroTaskStatus.UNDER_REVIEW:
        return AppColors.yellow; // Orange-like color (using yellow from app colors)
    }
  }

  Widget _progressNumber(int index, int totalSubTasks) {
    String currentIndex = index < 10 ? '0$index' : index.toString();
    String totalIndex =
        totalSubTasks < 10 ? '0$totalSubTasks' : totalSubTasks.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          currentIndex,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary),
        ),
        const SizedBox(width: 1),
        const Text(
          '/',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary),
        ),
        const SizedBox(width: 1),
        Text(
          totalIndex,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray),
        ),
      ],
    );
  }
}
