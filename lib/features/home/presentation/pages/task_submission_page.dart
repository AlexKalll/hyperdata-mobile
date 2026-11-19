import 'package:flutter/material.dart';
import 'package:mahder_mobile/features/home/presentation/widgets/image_to_text_widget.dart';
import 'package:get/get.dart';
import 'package:mahder_mobile/features/home/data/models/task_detail.dart';
import 'package:mahder_mobile/features/home/domain/entities/task_detail_entity.dart';
import 'package:mahder_mobile/features/home/presentation/controllers/home_controller.dart';
import 'package:mahder_mobile/features/home/presentation/widgets/speech_to_text_widget.dart';
import 'package:mahder_mobile/features/home/presentation/widgets/take_test_widget.dart';
import 'package:mahder_mobile/features/home/presentation/widgets/task_progress_widget.dart';
import 'package:mahder_mobile/features/home/presentation/widgets/test_rejected_widget.dart';
import 'package:mahder_mobile/features/home/presentation/widgets/text_to_speech_widget.dart';
import 'package:mahder_mobile/features/home/presentation/widgets/task_submission_onboarding.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/screen_size.dart';
import '../../../../core/widgets/loading.dart';
import '../../domain/entities/task_type_enum.dart';
import '../widgets/task_instruction_widget.dart';
import '../widgets/test_under_review_widget.dart';
import '../widgets/text_to_text_widget.dart';

class TaskSubmissionPage extends StatefulWidget {
  final String taskName;
  final TaskType taskType;

  const TaskSubmissionPage({
    super.key,
    required this.taskName,
    required this.taskType,
  });

  @override
  State<TaskSubmissionPage> createState() => _TaskSubmissionPageState();
}

class _TaskSubmissionPageState extends State<TaskSubmissionPage> {
  final HomeController _controller = Get.find<HomeController>();

  // GlobalKeys for onboarding targets
  final GlobalKey _backButtonKey = GlobalKey();
  final GlobalKey _titleKey = GlobalKey();
  final GlobalKey _infoButtonKey = GlobalKey();
  final GlobalKey _progressKey = GlobalKey();
  final GlobalKey _contentKey = GlobalKey();
  final GlobalKey _navigationKey = GlobalKey();

  // Task-specific widget keys
  final GlobalKey _taskKey1 = GlobalKey();
  final GlobalKey _taskKey2 = GlobalKey();
  final GlobalKey _taskKey3 = GlobalKey();

  TaskSubmissionOnboarding? _onboarding;
  bool _hasInitializedOnboarding = false;

  @override
  void initState() {
    super.initState();
    _setupOnboardingListener();
    // Also check immediately if task detail is already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.selectedTaskDetail.value != null &&
          !_hasInitializedOnboarding) {
        _hasInitializedOnboarding = true;
        _initializeOnboarding();
      }
    });
  }

  void _setupOnboardingListener() {
    // Listen for task detail changes to initialize onboarding
    ever(_controller.selectedTaskDetail, (taskDetail) {
      if (taskDetail != null && !_hasInitializedOnboarding && mounted) {
        _hasInitializedOnboarding = true;
        _initializeOnboarding();
      }
    });
  }

  void _initializeOnboarding() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _onboarding = TaskSubmissionOnboarding(
          context: context,
          taskType: widget.taskType,
          backButtonKey: _backButtonKey,
          titleKey: _titleKey,
          infoButtonKey: _infoButtonKey,
          progressKey: _progressKey,
          navigationKey: _navigationKey,
          taskSpecificKey1: _taskKey1,
          taskSpecificKey2: _taskKey2,
          taskSpecificKey3: _taskKey3,
        );
        _onboarding?.showIfNeeded();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
          canPop: !_controller.isSubmittingTask.value,
          child: Scaffold(
            backgroundColor: AppColors.appBgColor,
            resizeToAvoidBottomInset: true,
            // Floating help button - always visible
            floatingActionButton: FloatingActionButton(
              mini: true,
              backgroundColor: AppColors.primary,
              onPressed: () {
                if (_onboarding == null) {
                  // Initialize onboarding if not already done
                  _initializeOnboarding();
                  // Wait a bit for initialization then show
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _onboarding?.show();
                  });
                } else {
                  _onboarding?.show();
                }
              },
              child: const Icon(Icons.help_outline, color: Colors.white),
            ),
            body: SafeArea(
              child: LoadingOverlayWidget(
                isLoading: [_controller.isSubmittingTask],
                reason: 'home.tasks.submitting'.tr.obs,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: getScreenHeight(context) * 0.015),
                      _buildAppBar(context),
                      SizedBox(height: getScreenHeight(context) * 0.02),
                      Expanded(child: _buildBody(context)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBackButton(),
        _buildTitle(),
        _buildInstructionButton(context),
      ],
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        key: _backButtonKey,
        onTap: () => Get.back(),
        child: const Icon(Icons.arrow_back, size: 26),
      ),
    );
  }

  Widget _buildTitle() {
    return Expanded(
      child: Center(
        child: Text(
          key: _titleKey,
          widget.taskName.capitalize!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildInstructionButton(BuildContext context) {
    return Obx(() {
      final taskDetail = _controller.selectedTaskDetail.value;

      // Show button if task detail is loaded (always show for task info)
      if (taskDetail == null) return const SizedBox(width: 36);

      return IconButton(
        key: _infoButtonKey,
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        onPressed: () {
          TaskInstructionBottomSheet.show(
            context,
            taskDetail.task,
            taskDetail.taskInstruction,
          );
        },
      );
    });
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (_controller.isTaskDetailLoading.value) {
        return _buildLoadingState();
      }

      final taskDetail = _controller.selectedTaskDetail.value;
      if (taskDetail == null) {
        return _buildErrorState();
      }

      _showInstructionsIfNeeded(context, taskDetail);

      return _buildTaskContent(context, taskDetail);
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: LoadingWidget(
        isTransparent: true,
        reason: 'home.tasks.loading_details'.tr,
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Text(
        'home.tasks.error_loading'.tr,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  void _showInstructionsIfNeeded(
    BuildContext context,
    TaskDetailEntity taskDetail,
  ) {
    // Auto-popup removed - instructions now shown on dedicated page
    // Users can access instructions via the info button if needed
  }

  Widget _buildTaskContent(BuildContext context, TaskDetailEntity taskDetail) {
    // Show test-related widgets
    if (_shouldShowTestWidget(taskDetail)) {
      return _buildTestWidget(taskDetail);
    }

    // Show main task content
    if (taskDetail.microTasks.isEmpty) {
      return _buildEmptyMicroTasksState(context);
    }

    return _buildMicroTasksContent(context);
  }

  bool _shouldShowTestWidget(TaskDetailEntity taskDetail) {
    return taskDetail.isTest &&
        taskDetail.testStatus != TestStatus.Passed &&
        !_controller.hasStartedTest.value;
  }

  Widget _buildTestWidget(TaskDetailEntity taskDetail) {
    switch (taskDetail.testStatus) {
      case TestStatus.Under_Review:
        return const TestUnderReviewWidget();
      case TestStatus.Failed:
        return TestRejectedWidget(
          onStart: () => _controller.startTest(),
        );
      case TestStatus.Not_Taken:
        return TakeTestWidget(
          onStart: () => _controller.startTest(),
        );
      default:
        return _buildInvalidStateError();
    }
  }

  Widget _buildEmptyMicroTasksState(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: getScreenHeight(context) * 0.02),
        Center(
          child: Text(
            'home.tasks.no_micro_tasks'.tr,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildMicroTasksContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TaskProgressWidget(key: _progressKey),
        SizedBox(height: getScreenHeight(context) * 0.02),
        Expanded(
          child: Container(
            key: _contentKey,
            child: _buildTaskTypeWidget(),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskTypeWidget() {
    switch (widget.taskType) {
      case TaskType.Image_to_Text:
        return ImageToTextWidget(
          textInputKey: _taskKey1,
          submitButtonKey: _taskKey2,
          navigationKey: _navigationKey,
        );
      case TaskType.Text_to_Speech:
        return TextToSpeechWidget(
          micButtonKey: _taskKey1,
          submitButtonKey: _taskKey2,
          restartButtonKey: _taskKey3,
          navigationKey: _navigationKey,
        );
      case TaskType.Text_to_Text:
        return TextToTextWidget(
          textInputKey: _taskKey1,
          submitButtonKey: _taskKey2,
          cancelButtonKey: _taskKey3,
          navigationKey: _navigationKey,
        );
      case TaskType.Speech_to_Text:
        return SpeechToTextWidget(
          audioPlayerKey: _taskKey1,
          textInputKey: _taskKey2,
          submitButtonKey: _taskKey3,
          navigationKey: _navigationKey,
        );
      default:
        return Center(
          child: Text(
            'home.tasks.invalid_task_type'.tr,
            style: const TextStyle(color: Colors.red),
          ),
        );
    }
  }

  Widget _buildInvalidStateError() {
    return Center(
      child: Text(
        'home.tasks.invalid_task_detail'.tr,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
