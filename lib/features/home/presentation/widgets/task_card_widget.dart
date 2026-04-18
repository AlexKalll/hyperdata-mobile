import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/widgets/button.dart';
import 'package:leyu_mobile/features/home/domain/entities/task_status_enum.dart';
import 'package:leyu_mobile/features/home/presentation/widgets/progress_circle_widget.dart';
import 'package:leyu_mobile/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/screen_size.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_type_enum.dart';
import '../controllers/home_controller.dart';

class TaskCardWidget extends StatelessWidget {
  final TaskEntity task;
  final bool isRecent;
  final bool isCompleted;
  final VoidCallback? onTap;

  TaskCardWidget({super.key, required this.task,this.isRecent = false,this.isCompleted=false,this.onTap});

  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: onTap ?? () {
          homeController.fetchTaskDetail(task.id);
          // Skip instruction page if user has already started submissions
          if (task.doneCount > 0) {
            Get.toNamed(AppRoutes.taskSubmissionPage, arguments: {
              'taskName': task.name,
              'taskType': task.type,
            });
          } else {
            Get.toNamed(AppRoutes.taskInstructionPage, arguments: {
              'task': task,
            });
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProgressCircleWidget(done: task.doneCount, total: task.totalCount ,size: 40,),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Wrap(
                              children: [
                                Container(
                                  constraints: BoxConstraints(maxWidth: getScreenWidth(context) * 0.35),
                                  child: Text(
                                    task.name.capitalize??'',
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(width: getScreenWidth(context) * 0.02),
                               _taskTypeBadgeWidget(task.type)
                              ],
                            ),
                          ),
                          isCompleted? const SizedBox(width: 5,) : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.access_time, size: 12.0,color: AppColors.primary,),
                              const SizedBox(width: 1.0),
                              Text(
                                '${task.averageTime} min',
                                style: const TextStyle(fontSize: 11.0,color: AppColors.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _taskStatusBadgeWidget(task.status, task.pendingCount, task.rejectedCount, task.approvedCount),
                      const SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                isCompleted ? '${'home.tasks.submitted_on'.tr} ' : '${'home.tasks.deadline_on'.tr} ',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: AppColors.grayText,
                                ),
                              ),
                              Text(
                                task.dueDate == null ? 'N/A': formatDate(task.dueDate!),
                                style: const TextStyle(
                                  fontSize: 11.0,
                                ),
                              ),
                            ],
                          ),
                          if (task.estimatedEarning != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FBF7),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.monetization_on, size: 12.0, color: Color(0xFF02C27D)),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    '${task.estimatedEarning!.toStringAsFixed(2)} ETB',
                                    style: const TextStyle(
                                      fontSize: 11.0,
                                      color: Color(0xFF02C27D),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 14.0),
            ButtonWidget(
              onPressed: onTap ?? () {
                homeController.fetchTaskDetail(task.id);
                // Skip instruction page if user has already started submissions
                if (task.doneCount > 0) {
                  Get.toNamed(AppRoutes.taskSubmissionPage, arguments: {
                    'taskName': task.name,
                    'taskType': task.type,
                  });
                } else {
                  Get.toNamed(AppRoutes.taskInstructionPage, arguments: {
                    'task': task,
                  });
                }
              },
              text: isCompleted? 'home.tasks.view_submissions'.tr : isRecent? 'home.tasks.continue'.tr : 'home.tasks.get_started'.tr,
              borderRadius: 12,
              height: 40,
              fontSize: 14,
              color: isRecent? AppColors.green : AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedTaskType(TaskType taskType) {
    switch (taskType) {
      case TaskType.Speech_to_Text:
        return 'home.tasks.type.speech_to_text'.tr;
      case TaskType.Text_to_Speech:
        return 'home.tasks.type.text_to_speech'.tr;
      case TaskType.Text_to_Text:
        return 'home.tasks.type.text_to_text'.tr;
      default:
        return taskType.toString().split('.').last.replaceAll('_', ' ');
    }
  }

  Widget _taskTypeBadgeWidget(TaskType taskType) {
    String type = _getLocalizedTaskType(taskType);
    Color bgColor = taskType == TaskType.Speech_to_Text
        ? const Color(0xFFE6EFF7)
        : taskType == TaskType.Text_to_Speech
            ? const Color(0xFFF0FBF7)
            : const Color(0xFFFCF5FE);
    Color textColor = taskType == TaskType.Speech_to_Text
        ? const Color(0xFF095FAF)
        : taskType == TaskType.Text_to_Speech
        ? const Color(0xFF02C27D)
        : const Color(0xFFAD09E4);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 10.0,
          color: textColor,
        ),
      ),
    );
  }
  Widget _taskStatusBadgeWidget(TaskStatus? status, int pendingCount,int rejectedCount, int approvalCount) {
    if (status == TaskStatus.NOT_STARTED) {
      return _singleBadge('home.tasks.status.no_test_required'.tr,
          bg: const Color(0xFFE6EFF7), text: const Color(0xFF667085));
    }
    if (status == TaskStatus.TEST_NOT_STARTED) {
      return _singleBadge('home.tasks.status.test_required'.tr,
          bg: const Color(0xFFE6EFF7), text: const Color(0xFF095FAF));
    }
    final List<Widget> badges = [];

    if (rejectedCount > 0) {
      badges.add(_singleBadge('home.tasks.status.task_rejected'.trParams({'count': rejectedCount.toString()}),
          bg: const Color(0xFFFDF0F0), text: AppColors.red));
    }

    if (pendingCount > 0) {
      badges.add(_singleBadge('home.tasks.status.task_under_review'.trParams({'count': pendingCount.toString()}),
          bg: const Color(0xFFFFF8F0), text: const Color(0xFFFF8A00)));
    }

    if (approvalCount > 0) {
      badges.add(_singleBadge('home.tasks.status.task_approved'.trParams({'count': approvalCount.toString()}),
          bg: const Color(0xFFF0FBF7), text: const Color(0xFF02C27D)));
    }

    // -----------------------------------------------------------------
    // 3. If nothing to show → empty container
    // -----------------------------------------------------------------
    if (badges.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: badges,
    );
  }
  Widget _singleBadge(String label, {required Color bg, required Color text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10.0, color: text),
      ),
    );
  }

}