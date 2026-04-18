import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/widgets/button.dart';
import 'package:leyu_mobile/features/home/presentation/widgets/audio_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/message.dart';
import '../../../../core/utils/screen_size.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../routes/app_routes.dart';
import '../../data/models/task_detail.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_type_enum.dart';
import '../controllers/home_controller.dart';

class TaskInstructionPage extends StatefulWidget {
  const TaskInstructionPage({super.key});

  @override
  State<TaskInstructionPage> createState() => _TaskInstructionPageState();
}

class _TaskInstructionPageState extends State<TaskInstructionPage> {
  final HomeController _controller = Get.find();
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isVideoPlaying = false;
  bool _hasVideoError = false;
  String? _videoErrorMessage;

  // Get task from arguments (passed from task card)
  late final TaskEntity task;

  // Worker to dispose
  Worker? _taskDetailWorker;

  @override
  void initState() {
    super.initState();
    // Get task from route arguments
    final args = Get.arguments as Map<String, dynamic>?;
    task = args?['task'] as TaskEntity;

    // Initialize video when task detail loads
    _taskDetailWorker = ever(_controller.selectedTaskDetail, (_) {
      if (mounted) {
        _initializeVideo();
      }
    });

    // Initialize immediately if already loaded
    if (_controller.selectedTaskDetail.value != null) {
      _initializeVideo();
    }
  }

  bool _isYouTubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  bool _isExternalUrl(String url) {
    return _isYouTubeUrl(url) ||
        url.contains('vimeo.com') ||
        url.contains('dailymotion.com');
  }

  void _initializeVideo() {
    if (!mounted) return; // Early exit if not mounted

    final taskDetail = _controller.selectedTaskDetail.value;
    final videoUrl = taskDetail?.taskInstruction?.videoInstructionUrl;

    if (videoUrl != null && videoUrl.isNotEmpty) {
      // Reset state
      if (mounted) {
        setState(() {
          _hasVideoError = false;
          _videoErrorMessage = null;
          _isVideoInitialized = false;
        });
      }

      // Check if it's an external video platform
      if (_isExternalUrl(videoUrl)) {
        if (mounted) {
          setState(() {
            _hasVideoError = true;
            _videoErrorMessage = 'External video. Tap to open in browser.';
          });
        }
        return;
      }

      // Try to load as direct video URL
      _videoController?.dispose();
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isVideoInitialized = true;
              _hasVideoError = false;
            });
          }
        }).catchError((error) {
          print('Video initialization error: $error');
          if (mounted) {
            setState(() {
              _hasVideoError = true;
              _videoErrorMessage =
                  'Unable to load video. Tap to open in browser.';
            });
          }
        });
    }
  }

  @override
  void dispose() {
    _taskDetailWorker?.dispose(); // Dispose the worker
    _videoController?.dispose();
    super.dispose();
  }

  void _toggleVideoPlayback() {
    if (_videoController == null || !_isVideoInitialized) return;

    setState(() {
      if (_isVideoPlaying) {
        _videoController!.pause();
        _isVideoPlaying = false;
      } else {
        _videoController!.play();
        _isVideoPlaying = true;
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      body: SafeArea(
        child: Obx(() {
          final taskDetail = _controller.selectedTaskDetail.value;
          final instruction = taskDetail?.taskInstruction;
          final hasImage = instruction?.imageInstructionUrl != null &&
              instruction!.imageInstructionUrl!.isNotEmpty;
          final hasVideo = instruction?.videoInstructionUrl != null &&
              instruction!.videoInstructionUrl!.isNotEmpty;
          final hasAudio = instruction?.audioInstructionUrl != null &&
              instruction!.audioInstructionUrl!.isNotEmpty;
          final hasContent =
              instruction?.content != null && instruction!.content.isNotEmpty;

          return Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.arrow_back, size: 26),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        task.name.capitalize!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task Info Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'home.tasks.task_details'.tr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _taskTypeBadge(task.type),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _infoRow(Icons.description,
                                'home.tasks.description'.tr, task.description),
                            const SizedBox(height: 8),
                            _infoRow(
                                Icons.access_time,
                                'home.tasks.average_time_label'.tr,
                                'home.tasks.average_time'.trParams(
                                    {'time': task.averageTime.toString()})),
                            const SizedBox(height: 8),
                            _infoRow(
                                Icons.calendar_today,
                                'home.tasks.deadline'.tr,
                                task.dueDate != null
                                    ? formatDate(task.dueDate!)
                                    : 'N/A'),
                            if (task.estimatedEarning != null) ...[
                              const SizedBox(height: 8),
                              _infoRow(
                                  Icons.monetization_on,
                                  'home.tasks.estimated_earning'.tr,
                                  '${task.estimatedEarning!.toStringAsFixed(2)} ETB',
                                  valueColor: const Color(0xFF02C27D)),
                            ],
                            if (task.earningPerTask != null) ...[
                              const SizedBox(height: 8),
                              _infoRow(
                                  Icons.attach_money,
                                  'home.tasks.earning_per_task'.tr,
                                  '${task.earningPerTask!.toStringAsFixed(2)} ETB',
                                  valueColor: const Color(0xFF02C27D)),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Instructions Section
                      if (_controller.isTaskDetailLoading.value) ...[
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: LoadingWidget(isTransparent: true, size: 30),
                          ),
                        ),
                      ] else if (hasContent ||
                          hasImage ||
                          hasVideo ||
                          hasAudio) ...[
                        Text(
                          'home.tasks.instructions'.tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Text Instructions
                      if (hasContent)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.article,
                                      color: AppColors.primary, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'home.tasks.text_instructions'.tr,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                instruction.content,
                                style:
                                    const TextStyle(fontSize: 14, height: 1.5),
                              ),
                            ],
                          ),
                        ),

                      // Image Instructions
                      if (hasImage)
                        _mediaCard(
                          icon: Icons.image,
                          title: 'home.tasks.image_guide'.tr,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: instruction.imageInstructionUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: 200,
                                color: Colors.grey[200],
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 200,
                                color: Colors.grey[200],
                                child: const Center(child: Icon(Icons.error)),
                              ),
                            ),
                          ),
                        ),

                      // Video Instructions
                      if (hasVideo)
                        _mediaCard(
                          icon: Icons.video_library,
                          title: 'home.tasks.video_guide'.tr,
                          child: _hasVideoError
                              ? _buildVideoError(
                                  instruction.videoInstructionUrl!)
                              : _isVideoInitialized
                                  ? Column(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: _videoController!
                                              .value.aspectRatio,
                                          child: VideoPlayer(_videoController!),
                                        ),
                                        const SizedBox(height: 8),
                                        ElevatedButton.icon(
                                          onPressed: _toggleVideoPlayback,
                                          icon: Icon(_isVideoPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow),
                                          label: Text(_isVideoPlaying
                                              ? 'Pause'
                                              : 'Play'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      height: 200,
                                      color: Colors.grey[200],
                                      child: const Center(
                                          child: CircularProgressIndicator()),
                                    ),
                        ),

                      // Audio Instructions
                      if (hasAudio)
                        _mediaCard(
                          icon: Icons.headphones,
                          title: 'home.tasks.audio_guide'.tr,
                          child: _buildAudioPlayer(
                              instruction.audioInstructionUrl!),
                        ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Bottom Button
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Obx(() => ButtonWidget(
                      onPressed: taskDetail == null
                          ? null
                          : () {
                              Get.offAndToNamed(AppRoutes.taskSubmissionPage,
                                  arguments: {
                                    'taskName': task.name,
                                    'taskType': task.type,
                                  });
                            },
                      text: 'home.tasks.start_task'.tr,
                      borderRadius: 12,
                      height: 50,
                      fontSize: 16,
                      isLoading: _controller.isTaskDetailLoading.value,
                      loadingText: 'common.loading'.tr,
                    )),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _taskTypeBadge(TaskType taskType) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 11.0,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.grayText),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(color: valueColor ?? Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _mediaCard(
      {required IconData icon, required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildVideoError(String videoUrl) {
    return InkWell(
      onTap: () => _openInBrowser(videoUrl),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isYouTubeUrl(videoUrl)
                  ? Icons.play_circle_outline
                  : Icons.open_in_browser,
              size: 48,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _videoErrorMessage ?? 'Tap to open video',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.darkGray,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.launch, size: 16, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text(
                    'Open in Browser',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayer(String audioUrl) {
    // Check if it's a direct audio file or external URL
    if (_isExternalUrl(audioUrl) ||
        (!audioUrl.endsWith('.mp3') &&
            !audioUrl.endsWith('.aac') &&
            !audioUrl.endsWith('.wav') &&
            !audioUrl.endsWith('.m4a'))) {
      return InkWell(
        onTap: () => _openInBrowser(audioUrl),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.open_in_browser, color: AppColors.primary, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'External Audio',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to open in browser',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.launch, color: AppColors.primary, size: 20),
            ],
          ),
        ),
      );
    }

    // Use regular audio player for direct audio files
    return AudioPlayerWidget(audioUrl: audioUrl);
  }

  Future<void> _openInBrowser(String url) async {
    try {
      final uri = Uri.parse(url);

      // Try to launch with external application mode
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // If launch failed, show copy dialog
        _showCopyLinkDialog(url);
      }
    } catch (e) {
      print('Error launching URL: $e');
      // Show copy dialog as fallback
      _showCopyLinkDialog(url);
    }
  }

  void _showCopyLinkDialog(String url) {
    Get.dialog(
      AlertDialog(
        title: const Text('External Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Unable to open link automatically. You can copy it:'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                url,
                style: const TextStyle(fontSize: 12),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: url));
              Get.back();
              showSuccessMessage('Link copied to clipboard');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Copy Link'),
          ),
        ],
      ),
    );
  }
}
