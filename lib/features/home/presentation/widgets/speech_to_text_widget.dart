import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/constants/screen_constants.dart';
import 'package:leyu_mobile/core/services/audio_manager_service.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';
import 'package:leyu_mobile/core/utils/message.dart';
import 'package:leyu_mobile/core/widgets/button.dart';
import 'package:leyu_mobile/features/home/domain/entities/micro_task_entity.dart';
import 'package:leyu_mobile/features/home/domain/entities/task_detail_entity.dart';
import 'package:leyu_mobile/features/home/presentation/controllers/home_controller.dart';
import 'package:leyu_mobile/features/home/presentation/widgets/managed_audio_player_widget.dart';
import 'package:leyu_mobile/features/home/presentation/widgets/submission_widget.dart';
import 'package:leyu_mobile/features/home/presentation/widgets/task_navigation_bar.dart';
import 'package:leyu_mobile/features/home/presentation/widgets/validated_text_input_widget.dart';
import 'package:leyu_mobile/core/utils/screen_size.dart';
import 'package:leyu_mobile/features/home/domain/entities/micro_task_status_enum.dart';

class SpeechToTextWidget extends StatefulWidget {
  final GlobalKey? audioPlayerKey;
  final GlobalKey? textInputKey;
  final GlobalKey? submitButtonKey;
  final GlobalKey? navigationKey;

  const SpeechToTextWidget({
    super.key,
    this.audioPlayerKey,
    this.textInputKey,
    this.submitButtonKey,
    this.navigationKey,
  });

  @override
  _SpeechToTextWidgetState createState() => _SpeechToTextWidgetState();
}

class _SpeechToTextWidgetState extends State<SpeechToTextWidget> {
  final HomeController _controller = Get.find();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  final PageController _pageController = PageController();
  bool _isNavigating = false;
  bool _isTextValid = true;

  @override
  void initState() {
    super.initState();
    _initializeTextForCurrentMicroTask();
    _setupPageControllerListener();
  }

  @override
  void dispose() {
    // Stop all audio when leaving the page
    _stopAllAudio();
    _saveCurrentTextBeforeDispose();
    _textFocusNode.dispose();
    _pageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _initializeTextForCurrentMicroTask() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final microTaskId = _getCurrentMicroTaskId();
      _textController.text = _controller.savedTextOutputs[microTaskId] ?? '';
      setState(() {});
    });
  }

  void _setupPageControllerListener() {
    _pageController.addListener(() {
      if (_isNavigating) return;

      final newIndex = _pageController.page?.round() ?? 0;
      if (_controller.selectedMicroTaskIndex.value != newIndex) {
        // CRITICAL: Stop all audio when navigating between micro tasks
        _stopAllAudio();
        _saveCurrentTextIfEligible();
        _updateToNewMicroTask(newIndex);
        setState(() {}); // Force rebuild for audio player
      }
    });
  }

  void _stopAllAudio() {
    try {
      final audioManager = Get.find<AudioManagerService>();
      audioManager.stopAllAudio();
      print('Stopped all audio during micro task navigation');
    } catch (e) {
      print('Error stopping audio during navigation: $e');
    }
  }

  void _saveCurrentTextBeforeDispose() {
    final currentMicroTask = _getCurrentMicroTask();
    if (_isMicroTaskEligible(currentMicroTask)) {
      final currentText = _textController.text.trim();
      if (currentText.isNotEmpty) {
        _controller.saveTextOutput(currentText);
        print(
            'Saved text for microtask ${currentMicroTask.id} on dispose: $currentText');
      }
    }
  }

  void _saveCurrentTextIfEligible() {
    final currentMicroTask = _getCurrentMicroTask();
    if (_isMicroTaskEligible(currentMicroTask)) {
      final currentText = _textController.text.trim();
      if (currentText.isNotEmpty) {
        _controller.saveTextOutput(currentText);
        print('Saved text for microtask ${currentMicroTask.id}: $currentText');
      }
    }
  }

  void _updateToNewMicroTask(int newIndex) {
    _controller.selectedMicroTaskIndex.value = newIndex;
    final newMicroTaskId =
        _controller.selectedTaskDetail.value!.microTasks[newIndex].id;
    setState(() {
      _textController.text = _controller.savedTextOutputs[newMicroTaskId] ?? '';
    });
  }

  bool _shouldAllowNavigationNext() {
    final task = _controller.selectedTaskDetail.value!;
    final currentMicroTask = _getCurrentMicroTask();

    if (!_isMicroTaskEligible(currentMicroTask)) {
      return true;
    }

    return _isTextValidForNavigation(task);
  }

  bool _shouldAllowNavigationPrevious() {
    // Always allow going back
    return true;
  }

  bool _isTextValidForNavigation(TaskDetailEntity task) {
    final hasValidation =
        task.minCharacters != null || task.maxCharacters != null;

    if (!hasValidation) {
      return true;
    }

    final currentLength = _textController.text.trim().length;

    if (currentLength == 0) return false;
    if (task.minCharacters != null && currentLength < task.minCharacters!) {
      return false;
    }
    if (task.maxCharacters != null && currentLength > task.maxCharacters!) {
      return false;
    }

    return true;
  }

  bool _isMicroTaskEligible(MicroTaskEntity microTask) {
    return microTask.acceptanceStatus == MicroTaskStatus.NOT_STARTED ||
        (microTask.acceptanceStatus == MicroTaskStatus.REJECTED &&
            microTask.canRetry);
  }

  MicroTaskEntity _getCurrentMicroTask() {
    return _controller.selectedTaskDetail.value!
        .microTasks[_controller.selectedMicroTaskIndex.value!];
  }

  String _getCurrentMicroTaskId() {
    return _getCurrentMicroTask().id;
  }

  @override
  Widget build(BuildContext context) {
    final task = _controller.selectedTaskDetail.value!;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = ScreenConstants.isSmallScreen(screenHeight);

    return Obx(() {
      final currentIndex = _controller.selectedMicroTaskIndex.value ?? 0;
      final currentMicroTask = task.microTasks[currentIndex];
      final isCurrentTaskEligible = _isMicroTaskEligible(currentMicroTask);

      if (isSmallScreen) {
        // Small screen: Single page with scrollable content and floating navigation
        return _buildSmallScreenLayout(context, task, currentIndex);
      } else {
        // Normal screen: Vertical PageView with swipe
        // Disable forward swipe if navigation is not allowed
        final canSwipeForward = currentIndex < task.microTasks.length - 1 &&
            _shouldAllowNavigationNext();
        final canSwipeBackward =
            currentIndex > 0 && _shouldAllowNavigationPrevious();

        return Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              physics: canSwipeForward || canSwipeBackward
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: task.microTasks.length,
              onPageChanged: (index) {
                // Prevent navigation if not allowed
                if (index > currentIndex && !canSwipeForward) {
                  _pageController.jumpToPage(currentIndex);
                } else if (index < currentIndex && !canSwipeBackward) {
                  _pageController.jumpToPage(currentIndex);
                }
              },
              itemBuilder: (context, index) =>
                  _buildMicroTaskPage(context, task, index),
            ),
            // Floating navigation - hide on large screens when task is eligible
            if (task.microTasks.length > 1 && !isCurrentTaskEligible)
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _buildNavigationButtons(task, currentIndex,
                      useGlobalKey: true),
                ),
              ),
          ],
        );
      }
    });
  }

  Widget _buildSmallScreenLayout(
      BuildContext context, TaskDetailEntity task, int currentIndex) {
    final microTask = task.microTasks[currentIndex];
    final isEligible = _isMicroTaskEligible(microTask);

    return Stack(
      children: [
        // Main scrollable content
        SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              _buildAudioPlayer(microTask, useGlobalKey: true),
              _buildSubmissionInfo(),
              if (isEligible)
                _buildInputForm(context, task, microTask, useGlobalKeys: true),
              const SizedBox(height: 20),
            ],
          ),
        ),
        // Floating navigation buttons on the right
        if (task.microTasks.length > 1)
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: _buildNavigationButtons(task, currentIndex,
                  useGlobalKey: true),
            ),
          ),
      ],
    );
  }

  Widget _buildNavigationButtons(TaskDetailEntity task, int currentIndex,
      {bool useGlobalKey = true}) {
    final microTask = task.microTasks[currentIndex];
    final showHistory =
        microTask.acceptanceStatus != MicroTaskStatus.NOT_STARTED;

    return TaskNavigationBar(
      navigationKey: useGlobalKey ? widget.navigationKey : null,
      currentIndex: currentIndex,
      totalCount: task.microTasks.length,
      canNavigatePrevious: currentIndex > 0 && _shouldAllowNavigationPrevious(),
      canNavigateNext: currentIndex < task.microTasks.length - 1 &&
          _shouldAllowNavigationNext(),
      onPrevious: () => _navigateToIndex(currentIndex - 1, task),
      onNext: () => _navigateToIndex(currentIndex + 1, task),
      onHistory: showHistory
          ? () => _controller.showSubmissionHistoryBottomSheet(microTask.id)
          : null,
    );
  }

  void _navigateToIndex(int targetIndex, TaskDetailEntity task) {
    // Stop all audio before navigation
    _stopAllAudio();

    // Save current text if eligible
    _saveCurrentTextIfEligible();

    // Hide keyboard and properly manage focus
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    // Detach FocusNode and temporarily disable it
    if (_textFocusNode.hasFocus) {
      _textFocusNode.unfocus();
    }
    _textFocusNode.canRequestFocus = false;

    // Check if we're on a normal screen (using PageController)
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = ScreenConstants.isSmallScreen(screenHeight);

    if (!isSmallScreen && _pageController.hasClients) {
      // Animate PageController for normal screens
      _pageController.animateToPage(
        targetIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    // Update index
    _controller.selectedMicroTaskIndex.value = targetIndex;
    final newMicroTaskId = task.microTasks[targetIndex].id;
    setState(() {
      _textController.text = _controller.savedTextOutputs[newMicroTaskId] ?? '';
    });

    // Re-enable focus after page transition
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _textFocusNode.canRequestFocus = true;
        setState(() {});
      }
    });
  }

  Widget _buildMicroTaskPage(
      BuildContext context, TaskDetailEntity task, int index) {
    final microTask = task.microTasks[index];
    final isEligible = _isMicroTaskEligible(microTask);
    final isCurrentPage = index == _controller.selectedMicroTaskIndex.value;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildAudioPlayer(microTask, useGlobalKey: isCurrentPage),
        _buildSubmissionInfo(),
        const Spacer(),
        if (isEligible)
          _buildInputForm(context, task, microTask,
              useGlobalKeys: isCurrentPage),
      ],
    );
  }

  Widget _buildAudioPlayer(MicroTaskEntity microTask,
      {bool useGlobalKey = true}) {
    return SizedBox(
      key: useGlobalKey ? widget.audioPlayerKey : null,
      height: 70,
      child: ManagedAudioPlayerWidget(
        audioUrl: microTask.audioUrl ?? '',
        microTaskId: microTask.id,
      ),
    );
  }

  Widget _buildSubmissionInfo() {
    return SubmissionWidget();
  }

  Widget _buildInputForm(
      BuildContext context, TaskDetailEntity task, MicroTaskEntity microTask,
      {bool useGlobalKeys = true}) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (microTask.acceptanceStatus == MicroTaskStatus.REJECTED)
            _buildAttemptsLeftText(microTask),
          SizedBox(height: getScreenHeight(context) * 0.005),
          _buildTextInput(task, useGlobalKey: useGlobalKeys),
          SizedBox(height: getScreenHeight(context) * 0.03),
          _buildActionButtons(context, task, useGlobalKey: useGlobalKeys),
          SizedBox(height: getScreenHeight(context) * 0.03),
        ],
      ),
    );
  }

  Widget _buildAttemptsLeftText(MicroTaskEntity microTask) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'home.tasks.attempts_left'.trParams({
          'count': (microTask.allowedRetry - microTask.currentRetry).toString()
        }),
        style: const TextStyle(fontSize: 12, color: AppColors.primary),
      ),
    );
  }

  Widget _buildTextInput(TaskDetailEntity task, {bool useGlobalKey = true}) {
    return ValidatedTextInputWidget(
      key: useGlobalKey ? widget.textInputKey : null,
      label: 'common.text'.tr,
      controller: _textController,
      focus: _textFocusNode,
      placeHolder: 'home.tasks.type_text_placeholder'.tr,
      maxLines: 10,
      minCharacters: task.minCharacters,
      maxCharacters: task.maxCharacters,
      textInputAction: TextInputAction.done,
      onValidationChanged: (isValid) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _isTextValid != isValid) {
            setState(() => _isTextValid = isValid);
          }
        });
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, TaskDetailEntity task,
      {bool useGlobalKey = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCancelButton(context),
        const SizedBox(width: 10),
        _buildSubmitButton(context, task, useGlobalKey: useGlobalKey),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return ButtonWidget(
      width: getScreenWidth(context) * 0.4,
      text: 'common.cancel'.tr,
      fontSize: 14,
      color: AppColors.darkGray,
      fill: false,
      onPressed: () => _textController.clear(),
    );
  }

  Widget _buildSubmitButton(BuildContext context, TaskDetailEntity task,
      {bool useGlobalKey = true}) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _textController,
      builder: (context, value, child) {
        final isButtonEnabled = _isSubmitButtonEnabled(task, value);

        return Obx(() => ButtonWidget(
              key: useGlobalKey ? widget.submitButtonKey : null,
              isLoading: _controller.isSubmittingTask.value,
              width: getScreenWidth(context) * 0.4,
              text: _getSubmitButtonText(task),
              loadingText: 'home.tasks.submitting'.tr,
              fontSize: 14,
              color: isButtonEnabled ? AppColors.primary : AppColors.darkGray,
              onPressed:
                  !isButtonEnabled ? null : () => _handleSubmit(context, task),
            ));
      },
    );
  }

  bool _isSubmitButtonEnabled(TaskDetailEntity task, TextEditingValue value) {
    final hasValidation =
        task.minCharacters != null || task.maxCharacters != null;
    return hasValidation
        ? (_isTextValid && value.text.trim().isNotEmpty)
        : value.text.trim().isNotEmpty;
  }

  String _getSubmitButtonText(TaskDetailEntity task) {
    final isLastTask =
        _controller.selectedMicroTaskIndex.value! < task.microTasks.length - 1;
    return isLastTask ? 'common.continue'.tr : 'common.submit'.tr;
  }

  Future<void> _handleSubmit(
      BuildContext context, TaskDetailEntity task) async {
    final inputText = _textController.text.trim();

    if (!_validateTextInput(inputText, task)) {
      return;
    }

    await _saveAndNavigate(context, task, inputText);
  }

  bool _validateTextInput(String inputText, TaskDetailEntity task) {
    if (inputText.isEmpty) {
      showErrorMessage('home.tasks.enter_text_error'.tr);
      return false;
    }

    if (task.minCharacters != null && inputText.length < task.minCharacters!) {
      showErrorMessage('home.tasks.text_too_short'
          .trParams({'min': task.minCharacters.toString()}));
      return false;
    }

    if (task.maxCharacters != null && inputText.length > task.maxCharacters!) {
      showErrorMessage('home.tasks.text_too_long'
          .trParams({'max': task.maxCharacters.toString()}));
      return false;
    }

    return true;
  }

  Future<void> _saveAndNavigate(
      BuildContext context, TaskDetailEntity task, String inputText) async {
    final currentIndex = _controller.selectedMicroTaskIndex.value!;
    final microTaskId = task.microTasks[currentIndex].id;

    _controller.savedTextOutputs[microTaskId] = inputText;
    await _controller.persistTextOutput(microTaskId, inputText);

    final nextEligibleIndex = _findNextEligibleIndex(task, currentIndex);

    if (nextEligibleIndex != null) {
      await _navigateToNextTask(context, task, nextEligibleIndex);
    } else {
      _submitFinalTask(inputText);
    }
  }

  int? _findNextEligibleIndex(TaskDetailEntity task, int currentIndex) {
    for (int i = currentIndex + 1; i < task.microTasks.length; i++) {
      final microTask = task.microTasks[i];
      if (_isMicroTaskEligible(microTask)) {
        return i;
      }
    }
    return null;
  }

  Future<void> _navigateToNextTask(
      BuildContext context, TaskDetailEntity task, int nextIndex) async {
    _textController.clear();

    // Hide keyboard using system method
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    await Future.delayed(const Duration(milliseconds: 300));

    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = ScreenConstants.isSmallScreen(screenHeight);

    if (isSmallScreen) {
      // Small screen: Direct state update (no PageController)
      _controller.selectedMicroTaskIndex.value = nextIndex;
      final newMicroTaskId = task.microTasks[nextIndex].id;
      setState(() {
        _textController.text =
            _controller.savedTextOutputs[newMicroTaskId] ?? '';
      });
    } else {
      // Normal screen: Use PageController animation
      _isNavigating = true;

      await _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      _controller.selectedMicroTaskIndex.value = nextIndex;
      final newMicroTaskId = task.microTasks[nextIndex].id;
      setState(() {
        _textController.text =
            _controller.savedTextOutputs[newMicroTaskId] ?? '';
      });

      _isNavigating = false;
    }
  }

  void _submitFinalTask(String inputText) {
    final isSuccess = _controller.saveTextOutput(inputText);
    if (!isSuccess) {
      _textController.clear();
    }
  }
}
