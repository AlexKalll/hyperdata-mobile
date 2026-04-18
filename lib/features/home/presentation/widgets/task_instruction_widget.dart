import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/features/home/presentation/widgets/audio_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/message.dart';
import '../../../../core/utils/screen_size.dart';
import '../../data/models/task_detail.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_type_enum.dart';

class TaskInstructionBottomSheet extends StatefulWidget {
  final TaskEntity task;
  final TaskInstruction? taskInstruction;

  const TaskInstructionBottomSheet({
    required this.task,
    this.taskInstruction,
    super.key,
  });

  @override
  State<TaskInstructionBottomSheet> createState() => _TaskInstructionBottomSheetState();

  static void show(BuildContext context, TaskEntity task, TaskInstruction? taskInstruction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskInstructionBottomSheet(
        task: task,
        taskInstruction: taskInstruction,
      ),
    );
  }
}

class _TaskInstructionBottomSheetState extends State<TaskInstructionBottomSheet> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isVideoPlaying = false;
  bool _hasVideoError = false;
  String? _videoErrorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
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
    final videoUrl = widget.taskInstruction?.videoInstructionUrl;

    if (videoUrl != null && videoUrl.isNotEmpty) {
      // Check if it's an external video platform
      if (_isExternalUrl(videoUrl)) {
        setState(() {
          _hasVideoError = true;
          _videoErrorMessage = 'External video. Tap to open in browser.';
        });
        return;
      }

      // Try to load as direct video URL
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

  @override
  Widget build(BuildContext context) {
    final instruction = widget.taskInstruction;
    final hasImage = instruction?.imageInstructionUrl != null &&
        instruction!.imageInstructionUrl!.isNotEmpty;
    final hasVideo = instruction?.videoInstructionUrl != null &&
        instruction!.videoInstructionUrl!.isNotEmpty;
    final hasAudio = instruction?.audioInstructionUrl != null &&
        instruction!.audioInstructionUrl!.isNotEmpty;

    return Container(
      height: getScreenHeight(context) * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.task.name.capitalize!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGray,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.darkGray,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.category_outlined,
                          label: 'home.tasks.type.speech_to_text'.tr
                              .split(' ')
                              .first, // "Type"
                          child: _taskTypeBadgeWidget(widget.task.type),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.access_time_rounded,
                          label: 'home.tasks.average_time_label'.tr,
                          value: 'home.tasks.average_time'.trParams(
                              {'time': widget.task.averageTime.toString()}),
                          valueColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.calendar_today_outlined,
                    label: 'home.tasks.deadline'.tr,
                    value: widget.task.dueDate == null
                        ? 'N/A'
                        : formatDate(widget.task.dueDate!),
                  ),

                  // Earning Information
                  if (widget.task.estimatedEarning != null ||
                      widget.task.earningPerTask != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (widget.task.estimatedEarning != null)
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.monetization_on,
                              label: 'home.tasks.estimated_earning'.tr,
                              value: '${widget.task.estimatedEarning!
                                  .toStringAsFixed(2)} ETB',
                              valueColor: const Color(0xFF02C27D),
                            ),
                          ),
                        if (widget.task.estimatedEarning != null &&
                            widget.task.earningPerTask != null)
                          const SizedBox(width: 12),
                        if (widget.task.earningPerTask != null)
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.attach_money,
                              label: 'home.tasks.earning_per_task'.tr,
                              value: '${widget.task.earningPerTask!
                                  .toStringAsFixed(2)} ETB',
                              valueColor: const Color(0xFF02C27D),
                            ),
                          ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Description Section
                  _buildSectionHeader(
                    icon: Icons.description_outlined,
                    title: 'home.tasks.description'.tr,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.inputBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.task.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.darkGray,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Instructions Section
                  _buildSectionHeader(
                    icon: Icons.list_alt_rounded,
                    title: 'home.tasks.instructions'.tr,
                  ),
                  const SizedBox(height: 12),

                  if (instruction == null || instruction.content.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'home.tasks.no_instructions'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...[
                      // Text Instructions
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.inputBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          instruction.content,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.darkGray,
                            height: 1.5,
                          ),
                        ),
                      ),

                      // Media Instructions
                      if (hasImage || hasVideo || hasAudio) ...[
                        const SizedBox(height: 16),
                        _buildSectionHeader(
                          icon: Icons.perm_media_outlined,
                          title: 'home.tasks.instructions'.tr,
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Image Instruction
                      if (hasImage) ...[
                        _buildMediaCard(
                          icon: Icons.image_outlined,
                          title: 'home.tasks.image_guide'.tr,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: instruction.imageInstructionUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(
                                    height: 200,
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primary,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                              errorWidget: (context, url, error) =>
                                  Container(
                                    height: 200,
                                    color: Colors.grey[100],
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Icon(
                                          Icons.broken_image_outlined,
                                          size: 48,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Failed to load image',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Video Instruction
                      if (hasVideo) ...[
                        _buildMediaCard(
                          icon: Icons.play_circle_outline,
                          title: 'home.tasks.video_guide'.tr,
                          child: _hasVideoError
                              ? _buildVideoError(instruction
                              .videoInstructionUrl!)
                              : _isVideoInitialized
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: _videoController!.value
                                      .aspectRatio,
                                  child: VideoPlayer(_videoController!),
                                ),
                                if (!_isVideoPlaying)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.play_arrow_rounded,
                                        size: 48,
                                        color: Colors.white,
                                      ),
                                      onPressed: _toggleVideoPlayback,
                                    ),
                                  ),
                                if (_isVideoPlaying)
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.pause_rounded,
                                          color: Colors.white,
                                        ),
                                        onPressed: _toggleVideoPlayback,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                              : Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Audio Instruction
                      if (hasAudio) ...[
                        _buildMediaCard(
                          icon: Icons.headphones_outlined,
                          title: 'home.tasks.audio_guide'.tr,
                          child: _buildAudioPlayer(instruction
                              .audioInstructionUrl!),
                        ),
                      ],
                    ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    String? value,
    Color? valueColor,
    Widget? child,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (child != null)
            child
          else
            if (value != null)
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.darkGray,
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(child: child),
        ],
      ),
    );
  }

  Widget _buildVideoError(String videoUrl) {
    return Center(
      child: InkWell(
        onTap: () => _openInBrowser(videoUrl),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isYouTubeUrl(videoUrl) ? Icons.play_circle_outline : Icons
                    .open_in_browser,
                size: 48,
                color: AppColors.primary,
              ),
              const SizedBox(height: 20),
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
            borderRadius: BorderRadius.circular(12),
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
              const Icon(Icons.launch, size: 20, color: AppColors.primary),
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

  String _getLocalizedTaskType(TaskType taskType) {
    switch (taskType) {
      case TaskType.Speech_to_Text:
        return 'home.tasks.type.speech_to_text'.tr;
      case TaskType.Text_to_Speech:
        return 'home.tasks.type.text_to_speech'.tr;
      case TaskType.Text_to_Text:
        return 'home.tasks.type.text_to_text'.tr;
      default:
        return taskType
            .toString()
            .split('.')
            .last
            .replaceAll('_', ' ');
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
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
