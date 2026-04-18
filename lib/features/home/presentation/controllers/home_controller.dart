import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/cache/cache_manager.dart';
import 'package:leyu_mobile/core/utils/message.dart';
import 'package:leyu_mobile/core/utils/storage_logger.dart';
import 'package:leyu_mobile/core/utils/storage_error_handler.dart';
import 'package:leyu_mobile/features/home/domain/entities/task_detail_entity.dart';
import 'package:leyu_mobile/features/home/domain/entities/task_entity.dart';
import 'package:leyu_mobile/features/home/presentation/widgets/submission_history_bottom_sheet.dart';
import 'package:leyu_mobile/features/notification/domain/usecases/notification_usecase.dart';
import 'package:leyu_mobile/features/profile/domain/usecases/profile_usecase.dart';
import '../../../../core/cache/local_storage.dart';
import '../../../auth/data/models/user.dart';
import '../../data/services/file_storage_service.dart';
import '../../data/services/task_storage_service.dart';
import '../../domain/entities/micro_task_status_enum.dart';
import '../../domain/usecases/task_usecase.dart';

class HomeController extends GetxController {
  final LocalStorage _localStorage;
  final TaskUsecase _taskUseCase;
  final TaskStorageService _taskStorageService;
  final FileStorageService _fileStorageService;
  final NotificationUsecase _notificationUsecase;
  final ProfileUseCase _profileUseCase;

  HomeController(
    this._localStorage,
    this._taskUseCase,
    this._taskStorageService,
    this._fileStorageService,
    this._notificationUsecase,
    this._profileUseCase,
  );

  RxString userFirstName = "".obs;
  RxString userMiddleName = "".obs;
  RxnString userProfilePic = RxnString(null);

  RxBool isBalanceLoading = false.obs;
  RxDouble userBalance = 0.0.obs;

  RxInt notificationCount = 0.obs;

  final int pageSize = 10;

  RxList<TaskEntity> tasks = <TaskEntity>[].obs;
  RxBool isTasksLoading = false.obs;
  RxBool isLoadingMoreTasks = false.obs;
  RxBool hasMoreTasks = true.obs;
  RxInt tasksCurrentPage = 1.obs;
  RxString currentFilter = 'all'.obs;

  RxBool isTaskDetailLoading = false.obs;
  Rxn<TaskDetailEntity> selectedTaskDetail = Rxn<TaskDetailEntity>(null);
  RxnInt selectedMicroTaskIndex = RxnInt(null);
  RxBool hasReadInstructions = false.obs;
  RxBool hasStartedTest = false.obs;
  RxBool isSubmittingTask = false.obs;
  RxBool showShowRecordingOnBoarding = true.obs;

  Map<String, File> recordedAudioFiles = {};
  Map<String, String> savedTextOutputs = {};

  // Track current task loading to allow cancellation
  String? _currentLoadingTaskId;

  @override
  void onInit() {
    _initializeStorage();
    fetchUserBalance();
    fetchTasks();
    fetchNotificationCount();
    _refreshUserProfile();
    super.onInit();
  }

  void _refreshUserProfile() async {
    try {
      User? user = await _profileUseCase.getUserProfile();
      if (user != null) {
        userFirstName.value = user.firstName ?? '';
        userMiddleName.value = user.middleName ?? '';
        userProfilePic.value = user.profilePicture;
        await _localStorage.saveUser(user);
      }
    } catch (e) {
      // Silently fail - don't show error to user
      print('Failed to refresh user profile: $e');
    }
  }

  void fetchNotificationCount() async {
    int count = await _notificationUsecase.getUnreadCount();
    print(count);
    notificationCount.value = count;
  }

  void refreshNotificationCount() {
    fetchNotificationCount();
  }

  void getUserProfile() async {
    User? user = await _localStorage.getUserDetail();
    if (user != null) {
      userFirstName.value = user.firstName ?? '';
      userMiddleName.value = user.middleName ?? '';
      userProfilePic.value = user.profilePicture;
    }
  }

  void fetchUserBalance() async {
    isBalanceLoading.value = true;
    double balance = await _taskUseCase.getBalance();
    userBalance.value = balance;
    isBalanceLoading.value = false;
  }

  Future<void> fetchTasks({bool nextPage = false, String? filter}) async {
    try {
      if (nextPage && !hasMoreTasks.value) return;

      if (nextPage) {
        isLoadingMoreTasks.value = true;
      } else {
        isTasksLoading.value = true;
        tasksCurrentPage.value = 1;
        this.tasks.clear();
      }

      final filterToUse = filter ?? currentFilter.value;
      if (!nextPage) {
        currentFilter.value = filterToUse;
      }

      final tasks = await _taskUseCase.getMyTasks(
        page: tasksCurrentPage.value,
        pageSize: pageSize,
        filter: filterToUse,
      );

      if (nextPage) {
        this.tasks.addAll(tasks);
      } else {
        this.tasks.value = tasks;
      }

      hasMoreTasks.value = tasks.length == pageSize;
      if (hasMoreTasks.value) tasksCurrentPage.value++;
    } catch (e) {
      print('Error fetching new tasks: $e');
    } finally {
      isTasksLoading.value = false;
      isLoadingMoreTasks.value = false;
    }
  }

  void changeTaskFilter(String filter) {
    fetchTasks(filter: filter);
  }

  Future<void> fetchTaskDetail(String taskId) async {
    // Cancel previous loading if a new task is requested
    if (_currentLoadingTaskId != null && _currentLoadingTaskId != taskId) {
      print('Cancelling previous task load: $_currentLoadingTaskId');
    }

    _currentLoadingTaskId = taskId;
    isTaskDetailLoading.value = true;
    selectedTaskDetail.value = null;
    selectedMicroTaskIndex.value = null;

    // CRITICAL: Clear maps BEFORE fetching new task detail
    recordedAudioFiles.clear();
    savedTextOutputs.clear();

    try {
      final taskDetail = await _taskUseCase.getTaskDetail(taskId);

      // Check if this task is still the one we want (not cancelled)
      if (_currentLoadingTaskId != taskId) {
        print('Task load cancelled, ignoring result for: $taskId');
        return;
      }

      selectedTaskDetail.value = taskDetail;
      selectedMicroTaskIndex.value = 0;
      hasStartedTest.value = false;

      // Check if instructions have been shown for this specific task
      hasReadInstructions.value = await _hasShownInstructionsForTask(taskId);

      // Load any previously saved submissions from local storage
      // This will validate batch and only load matching data
      await _loadTaskSubmissions(taskId);

      // Log what was loaded for debugging
      print('Loaded task $taskId with batch ${taskDetail?.batch}');
      print('Audio files loaded: ${recordedAudioFiles.length}');
      print('Text outputs loaded: ${savedTextOutputs.length}');
    } catch (e) {
      print('Error fetching task detail: $e');
      if (_currentLoadingTaskId == taskId) {
        showErrorMessage('Failed to load task details');
      }
    } finally {
      if (_currentLoadingTaskId == taskId) {
        isTaskDetailLoading.value = false;
        _currentLoadingTaskId = null;
      }
    }
  }

  Future<bool> _hasShownInstructionsForTask(String taskId) async {
    final shownTasks = CacheManager.getData('shown_instructions_tasks');
    if (shownTasks == null) return false;
    if (shownTasks is List) {
      return shownTasks.contains(taskId);
    }
    return false;
  }

  Future<void> markInstructionsAsShown(String taskId) async {
    final shownTasks =
        CacheManager.getData('shown_instructions_tasks') as List? ?? [];
    if (!shownTasks.contains(taskId)) {
      shownTasks.add(taskId);
      await CacheManager.saveData('shown_instructions_tasks', shownTasks);
    }
    hasReadInstructions.value = true;
  }

  void startTest() {
    hasStartedTest.value = true;
  }

  bool setRecordedAudio(File audioFile) {
    if (!_isTaskAndMicroTaskSelected()) {
      showErrorMessage(
          "Please select a task and a subtask before recording audio.");
      return false;
    }

    final microTaskId = _getCurrentMicroTaskId();
    recordedAudioFiles[microTaskId] = audioFile;
    _persistAudioRecording(microTaskId, audioFile);

    final eligibleMicroTasks = _getEligibleMicroTasks();
    final lastEligibleIndex = _findLastEligibleIndex(eligibleMicroTasks);
    final allEligibleRecorded = _areAllEligibleRecorded(eligibleMicroTasks);
    final currentIndex = selectedMicroTaskIndex.value!;

    if (currentIndex == lastEligibleIndex && allEligibleRecorded) {
      submitAudioTask();
      return false;
    }

    final nextEligibleIndex = _findNextEligibleIndex(currentIndex);
    if (nextEligibleIndex == null) {
      showErrorMessage("Please complete all eligible tasks before submitting.");
      return false;
    }

    selectedMicroTaskIndex.value = nextEligibleIndex;
    print("Recorded audio files: $recordedAudioFiles");
    return true;
  }

  Future<void> submitAudioTask() async {
    if (!_isTaskAndMicroTaskSelected()) {
      showErrorMessage("Please select a task and a subtask before submitting.");
      return;
    }

    final eligibleAudioFiles = _getEligibleAudioFiles();
    if (eligibleAudioFiles.isEmpty) {
      showErrorMessage("No eligible tasks to submit.");
      return;
    }

    isSubmittingTask.value = true;
    final taskId = selectedTaskDetail.value!.task.id;
    final batch = selectedTaskDetail.value!.batch;
    final isTest = selectedTaskDetail.value!.isTest;

    final isSuccess = await _taskUseCase.submitAudioTask(
        taskId, batch, isTest, eligibleAudioFiles);

    if (isSuccess) {
      await _handleSuccessfulSubmission(taskId);
    } else {
      StorageLogger.logApiSubmissionFailed(taskId);
    }

    isSubmittingTask.value = false;
  }

  Map<String, File> _getEligibleAudioFiles() {
    final eligibleMicroTaskIds = _getEligibleMicroTaskIds();
    return Map<String, File>.fromEntries(recordedAudioFiles.entries
        .where((entry) => eligibleMicroTaskIds.contains(entry.key)));
  }

  Set<String> _getEligibleMicroTaskIds() {
    return selectedTaskDetail.value!.microTasks
        .where((microTask) =>
            microTask.acceptanceStatus == MicroTaskStatus.NOT_STARTED ||
            (microTask.acceptanceStatus == MicroTaskStatus.REJECTED &&
                microTask.canRetry == true))
        .map((microTask) => microTask.id)
        .toSet();
  }

  bool saveTextOutput(String output) {
    if (!_isTaskAndMicroTaskSelected()) {
      showErrorMessage(
          "Please select a task and a subtask before saving text output.");
      return false;
    }

    final microTaskId = _getCurrentMicroTaskId();
    savedTextOutputs[microTaskId] = output;
    persistTextOutput(microTaskId, output);

    final eligibleMicroTasks = _getEligibleMicroTasks();
    final lastEligibleIndex = _findLastEligibleIndex(eligibleMicroTasks);
    final allEligibleOutputsSaved =
        _areAllEligibleTextOutputsSaved(eligibleMicroTasks);
    final currentIndex = selectedMicroTaskIndex.value!;

    if (currentIndex == lastEligibleIndex && allEligibleOutputsSaved) {
      submitTextOutput();
      return false;
    }

    final nextEligibleIndex = _findNextEligibleIndex(currentIndex);
    if (nextEligibleIndex == null) {
      showErrorMessage("Please complete all eligible tasks before submitting.");
      return false;
    }

    selectedMicroTaskIndex.value = nextEligibleIndex;
    print("Saved text outputs: $savedTextOutputs");
    return true;
  }

  Future<void> submitTextOutput() async {
    if (!_isTaskAndMicroTaskSelected()) {
      showErrorMessage("Please select a task and a subtask before submitting.");
      return;
    }

    final eligibleMicroTasks = _getEligibleMicroTasks();
    final eligibleTextOutputs = _getEligibleTextOutputs(eligibleMicroTasks);

    if (eligibleTextOutputs.isEmpty) {
      showErrorMessage("No eligible tasks to submit.");
      return;
    }

    if (!_validateTextOutputs(eligibleMicroTasks)) {
      return;
    }

    isSubmittingTask.value = true;
    final taskId = selectedTaskDetail.value!.task.id;
    final batch = selectedTaskDetail.value!.batch;
    final isTest = selectedTaskDetail.value!.isTest;

    final isSuccess = await _taskUseCase.submitTextTask(
        taskId, batch, isTest, eligibleTextOutputs);

    if (isSuccess) {
      await _handleSuccessfulSubmission(taskId);
    } else {
      StorageLogger.logApiSubmissionFailed(taskId);
    }

    isSubmittingTask.value = false;
  }

  Map<String, String> _getEligibleTextOutputs(
      List<MapEntry<int, dynamic>> eligibleMicroTasks) {
    final eligibleMicroTaskIds =
        eligibleMicroTasks.map((entry) => entry.value.id).toSet();

    return Map<String, String>.fromEntries(savedTextOutputs.entries
        .where((entry) => eligibleMicroTaskIds.contains(entry.key)));
  }

  bool _validateTextOutputs(List<MapEntry<int, dynamic>> eligibleMicroTasks) {
    final minChars = selectedTaskDetail.value!.minCharacters;
    final maxChars = selectedTaskDetail.value!.maxCharacters;

    if (minChars == null && maxChars == null) {
      return true;
    }

    for (var entry in eligibleMicroTasks) {
      final microTaskId = entry.value.id;
      final microTaskIndex = entry.key + 1;
      final text = savedTextOutputs[microTaskId];

      if (text != null) {
        final textLength = text.trim().length;

        if (minChars != null && textLength < minChars) {
          showErrorMessage(
              'Task $microTaskIndex: Text is too short. Minimum $minChars characters required.');
          return false;
        }

        if (maxChars != null && textLength > maxChars) {
          showErrorMessage(
              'Task $microTaskIndex: Text is too long. Maximum $maxChars characters allowed.');
          return false;
        }
      }
    }

    return true;
  }

  Future<void> _handleSuccessfulSubmission(String taskId) async {
    // Clean up storage FIRST (before clearing in-memory)
    await _cleanupTaskStorage(taskId);

    // Clear in-memory cache after storage cleanup
    recordedAudioFiles.clear();
    savedTextOutputs.clear();

    // Clear selected task detail to prevent reloading old data
    selectedTaskDetail.value = null;
    selectedMicroTaskIndex.value = null;

    // Refresh and navigate
    fetchTasks();
    Get.back();
    showSuccessMessage("Task submitted successfully!");
  }

  String? getRecordedAudioPath() {
    if (!_isTaskAndMicroTaskSelected()) {
      return null;
    }
    final microTaskId = _getCurrentMicroTaskId();
    return recordedAudioFiles[microTaskId]?.path;
  }

  /// Get the proper file path for recording
  /// Returns the path where the recording should be saved
  Future<String?> getRecordingFilePath() async {
    try {
      if (selectedTaskDetail.value == null ||
          selectedMicroTaskIndex.value == null) {
        StorageLogger.logNoTaskSelected('get recording file path');
        return null;
      }

      final taskId = selectedTaskDetail.value!.task.id;
      final microTaskId = selectedTaskDetail
          .value!.microTasks[selectedMicroTaskIndex.value!].id;

      // Get task directory
      final taskDir = await _fileStorageService.getTaskDirectory(taskId);
      final filePath = '${taskDir.path}/$microTaskId.aac';

      return filePath;
    } catch (e) {
      StorageLogger.logRecordingFilePathError(e);
      return null;
    }
  }

  void deleteRecordedAudioForCurrentMicroTask() async {
    if (!_isTaskAndMicroTaskSelected()) {
      return;
    }

    final microTaskId = _getCurrentMicroTaskId();
    final taskId = selectedTaskDetail.value!.task.id;
    final audioFile = recordedAudioFiles[microTaskId];

    // Remove from in-memory map
    recordedAudioFiles.remove(microTaskId);

    // Delete from storage
    try {
      if (audioFile != null) {
        await _fileStorageService.deleteAudioFile(audioFile.path);
      }
      await _taskStorageService.deleteAudioRecording(taskId, microTaskId);
    } catch (e) {
      StorageLogger.logAudioRecordingDeleteError(taskId, microTaskId, e);
    }
  }

  /// Initialize storage services
  /// Falls back to in-memory storage if initialization fails
  Future<void> _initializeStorage() async {
    try {
      StorageLogger.logStorageInitStarted();
      await _taskStorageService.init();
      StorageLogger.logStorageInitSuccess();
    } catch (e) {
      // Error handler already called in TaskStorageService.init()
      // Continue with in-memory storage - no need to rethrow
    }
  }

  /// Load task submissions from local storage
  /// Validates audio file paths and populates in-memory maps
  Future<void> _loadTaskSubmissions(String taskId) async {
    try {
      StorageLogger.logTaskSubmissionsLoadStarted(taskId);
      final submission = await _taskStorageService.getSubmission(taskId);
      if (submission == null) {
        print('No stored submission found for task $taskId');
        return;
      }

      // CRITICAL: Validate batch number matches current batch
      final currentBatch = selectedTaskDetail.value?.batch;
      if (currentBatch == null) {
        print('Warning: Current batch is null, skipping submission load');
        return;
      }

      print('Stored batch: ${submission.batch}, Current batch: $currentBatch');

      if (submission.batch != currentBatch) {
        print(
            'Warning: Stored batch (${submission.batch}) does not match current batch ($currentBatch)');
        print('Deleting stale data from previous batch...');
        // Delete stale data from previous batch
        await _cleanupTaskStorage(taskId);
        // Ensure maps stay cleared after cleanup
        recordedAudioFiles.clear();
        savedTextOutputs.clear();
        print('Stale data cleaned up successfully');
        return;
      }

      // CRITICAL: Only load data for ELIGIBLE micro tasks
      // Eligible = NOT_STARTED or (REJECTED with canRetry = true)
      final eligibleMicroTaskIds = selectedTaskDetail.value!.microTasks
          .where((mt) =>
              mt.acceptanceStatus == MicroTaskStatus.NOT_STARTED ||
              (mt.acceptanceStatus == MicroTaskStatus.REJECTED &&
                  mt.canRetry == true))
          .map((mt) => mt.id)
          .toSet();

      print('Eligible micro task IDs: $eligibleMicroTaskIds');

      // Load and validate audio file paths (only for eligible micro tasks)
      int skippedAudioCount = 0;
      for (final entry in submission.audioFilePaths.entries) {
        final microTaskId = entry.key;
        final filePath = entry.value;

        // Check if micro task is eligible
        if (!eligibleMicroTaskIds.contains(microTaskId)) {
          print('Skipping audio for non-eligible micro task: $microTaskId');
          skippedAudioCount++;
          // Delete from storage since it's no longer needed
          await _taskStorageService.deleteAudioRecording(taskId, microTaskId);
          continue;
        }

        // Validate file existence
        final exists = await _fileStorageService.fileExists(filePath);
        if (exists) {
          recordedAudioFiles[microTaskId] = File(filePath);
          print('Loaded audio for eligible micro task: $microTaskId');
        } else {
          StorageLogger.logInvalidFilePathRemoved(
              taskId, microTaskId, filePath);
          // Remove invalid entry from storage
          await _taskStorageService.deleteAudioRecording(taskId, microTaskId);
        }
      }

      // Load text outputs with validation (only for eligible micro tasks)
      int skippedTextCount = 0;
      for (final entry in submission.textOutputs.entries) {
        final microTaskId = entry.key;

        // Check if micro task is eligible
        if (!eligibleMicroTaskIds.contains(microTaskId)) {
          print(
              'Skipping text output for non-eligible micro task: $microTaskId');
          skippedTextCount++;
          // Note: Text outputs are stored in the same submission object,
          // they'll be cleaned up when the whole submission is deleted
          continue;
        }

        savedTextOutputs[microTaskId] = entry.value;
        print('Loaded text output for eligible micro task: $microTaskId');
      }

      if (skippedAudioCount > 0 || skippedTextCount > 0) {
        print(
            'Skipped $skippedAudioCount audio files and $skippedTextCount text outputs for non-eligible micro tasks');
      }

      final audioCount = recordedAudioFiles.length;
      final textCount = savedTextOutputs.length;
      StorageLogger.logTaskSubmissionsLoaded(taskId, audioCount, textCount);

      // Show recovery message to user if data was recovered
      if (audioCount > 0 || textCount > 0) {
        StorageErrorHandler.handleDataRecovery(audioCount, textCount);
      }
    } catch (e) {
      StorageLogger.logTaskSubmissionsLoadError(taskId, e);
      // Clear maps on error to prevent loading corrupted data
      recordedAudioFiles.clear();
      savedTextOutputs.clear();
    }
  }

  /// Persist audio recording to storage
  /// Saves file to proper location and stores metadata in Hive
  Future<void> _persistAudioRecording(
      String microTaskId, File audioFile) async {
    try {
      if (selectedTaskDetail.value == null) {
        StorageLogger.logNoTaskSelected('persist audio');
        return;
      }

      StorageLogger.logAudioPersistStarted(microTaskId);
      final taskId = selectedTaskDetail.value!.task.id;
      final batch = selectedTaskDetail.value!.batch;
      final isTest = selectedTaskDetail.value!.isTest;

      // Save file to proper location
      final savedFilePath = await _fileStorageService.saveAudioFile(
        taskId,
        microTaskId,
        audioFile,
      );

      // Save metadata to Hive
      await _taskStorageService.saveAudioRecording(
        taskId,
        microTaskId,
        savedFilePath,
        batch,
        isTest,
      );

      // Update in-memory map with the new file path
      recordedAudioFiles[microTaskId] = File(savedFilePath);

      StorageLogger.logAudioPersistSuccess(microTaskId);
    } catch (e) {
      StorageLogger.logAudioPersistError(microTaskId, e);
      StorageErrorHandler.handleAudioSaveError(e, showToUser: true);
      // Continue with in-memory storage only
    }
  }

  /// Persist text output to storage
  /// Saves text to Hive database
  /// Public method for widgets to call directly
  Future<void> persistTextOutput(String microTaskId, String text) async {
    try {
      if (selectedTaskDetail.value == null) {
        StorageLogger.logNoTaskSelected('persist text');
        return;
      }

      StorageLogger.logTextPersistStarted(microTaskId);
      final taskId = selectedTaskDetail.value!.task.id;
      final batch = selectedTaskDetail.value!.batch;
      final isTest = selectedTaskDetail.value!.isTest;

      // Save text to Hive
      await _taskStorageService.saveTextOutput(
        taskId,
        microTaskId,
        text,
        batch,
        isTest,
      );

      StorageLogger.logTextPersistSuccess(microTaskId);
    } catch (e) {
      StorageLogger.logTextPersistError(microTaskId, e);
      StorageErrorHandler.handleTextSaveError(e, showToUser: true);
      // Continue with in-memory storage only
    }
  }

  /// Clean up task storage after successful submission
  /// Deletes files and database entries
  Future<void> _cleanupTaskStorage(String taskId) async {
    try {
      StorageLogger.logStorageCleanupStarted(taskId);

      // Delete all files for the task
      await _fileStorageService.deleteTaskFiles(taskId);

      // Delete submission from Hive
      await _taskStorageService.deleteTaskSubmission(taskId);

      StorageLogger.logStorageCleanupSuccess(taskId);
    } catch (e) {
      StorageLogger.logStorageCleanupError(taskId, e);
      StorageErrorHandler.handleSubmissionCleanupError(e);
      // Don't rethrow - cleanup failure shouldn't block the user
    }
  }

  // Submission History
  RxBool isLoadingSubmissionHistory = false.obs;
  RxList<dynamic> submissionHistory = <dynamic>[].obs;

  Future<void> fetchSubmissionHistory(String microTaskId) async {
    try {
      isLoadingSubmissionHistory.value = true;
      final submissions = await _taskUseCase.getSubmissionHistory(microTaskId);
      submissionHistory.value = submissions;
    } catch (e) {
      print('Error fetching submission history: $e');
      showErrorMessage('Failed to fetch submission history');
    } finally {
      isLoadingSubmissionHistory.value = false;
    }
  }

  void showSubmissionHistoryBottomSheet(String microTaskId) {
    fetchSubmissionHistory(microTaskId);
    Get.bottomSheet(
      SubmissionHistoryBottomSheet(microTaskId: microTaskId),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ========== Helper Methods ==========

  bool _isTaskAndMicroTaskSelected() {
    return selectedTaskDetail.value != null &&
        selectedMicroTaskIndex.value != null;
  }

  String _getCurrentMicroTaskId() {
    return selectedTaskDetail
        .value!.microTasks[selectedMicroTaskIndex.value!].id;
  }

  List<MapEntry<int, dynamic>> _getEligibleMicroTasks() {
    return selectedTaskDetail.value!.microTasks.asMap().entries.where((entry) {
      final microTask = entry.value;
      return microTask.acceptanceStatus == MicroTaskStatus.NOT_STARTED ||
          (microTask.acceptanceStatus == MicroTaskStatus.REJECTED &&
              microTask.canRetry == true);
    }).toList();
  }

  int? _findLastEligibleIndex(List<MapEntry<int, dynamic>> eligibleMicroTasks) {
    int? lastEligibleIndex;
    for (var entry in eligibleMicroTasks) {
      if (lastEligibleIndex == null || entry.key > lastEligibleIndex) {
        lastEligibleIndex = entry.key;
      }
    }
    return lastEligibleIndex;
  }

  bool _areAllEligibleRecorded(
      List<MapEntry<int, dynamic>> eligibleMicroTasks) {
    final recordedCount = eligibleMicroTasks
        .where((entry) => recordedAudioFiles.containsKey(entry.value.id))
        .length;
    return recordedCount == eligibleMicroTasks.length;
  }

  bool _areAllEligibleTextOutputsSaved(
      List<MapEntry<int, dynamic>> eligibleMicroTasks) {
    final outputCount = eligibleMicroTasks
        .where((entry) => savedTextOutputs.containsKey(entry.value.id))
        .length;
    return outputCount == eligibleMicroTasks.length;
  }

  int? _findNextEligibleIndex(int currentIndex) {
    for (int i = currentIndex + 1;
        i < selectedTaskDetail.value!.microTasks.length;
        i++) {
      final microTask = selectedTaskDetail.value!.microTasks[i];
      if (microTask.acceptanceStatus == MicroTaskStatus.NOT_STARTED ||
          (microTask.acceptanceStatus == MicroTaskStatus.REJECTED &&
              microTask.canRetry == true)) {
        return i;
      }
    }
    return null;
  }
}
