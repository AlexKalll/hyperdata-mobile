import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mahder_mobile/features/home/domain/entities/micro_task_entity.dart';
import 'package:mahder_mobile/features/home/domain/entities/micro_task_status_enum.dart';
import 'package:mahder_mobile/features/home/domain/entities/task_detail_entity.dart';
import 'package:mahder_mobile/features/home/presentation/controllers/home_controller.dart';
import 'package:mahder_mobile/features/home/presentation/widgets/submission_widget.dart';
import 'package:mahder_mobile/features/home/presentation/widgets/task_navigation_bar.dart';
import 'package:mahder_mobile/features/home/presentation/widgets/validated_text_input_widget.dart';

class ImageToTextWidget extends StatelessWidget {
  final GlobalKey? textInputKey;
  final GlobalKey? submitButtonKey;
  final GlobalKey? navigationKey;

  const ImageToTextWidget(
      {super.key, this.textInputKey, this.submitButtonKey, this.navigationKey});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Obx(() {
      final task = controller.selectedTaskDetail.value;
      final index = controller.selectedMicroTaskIndex.value;
      if (task == null ||
          index == null ||
          index < 0 ||
          index >= task.microTasks.length) {
        return const SizedBox.shrink();
      }
      final microTask = task.microTasks[index];
      return _ImageTextEditor(
        key: ValueKey(microTask.id),
        controller: controller,
        task: task,
        microTask: microTask,
        index: index,
        textInputKey: textInputKey,
        submitButtonKey: submitButtonKey,
        navigationKey: navigationKey,
      );
    });
  }
}

class _ImageTextEditor extends StatefulWidget {
  final HomeController controller;
  final TaskDetailEntity task;
  final MicroTaskEntity microTask;
  final int index;
  final GlobalKey? textInputKey;
  final GlobalKey? submitButtonKey;
  final GlobalKey? navigationKey;

  const _ImageTextEditor(
      {super.key,
      required this.controller,
      required this.task,
      required this.microTask,
      required this.index,
      this.textInputKey,
      this.submitButtonKey,
      this.navigationKey});

  @override
  State<_ImageTextEditor> createState() => _ImageTextEditorState();
}

class _ImageTextEditorState extends State<_ImageTextEditor> {
  late final TextEditingController _text;
  Future<void> _saving = Future<void>.value();

  bool _eligible(MicroTaskEntity item) =>
      item.acceptanceStatus == MicroTaskStatus.NOT_STARTED ||
      (item.acceptanceStatus == MicroTaskStatus.REJECTED && item.canRetry);

  @override
  void initState() {
    super.initState();
    _text = TextEditingController(
        text: widget.controller.savedTextOutputs[widget.microTask.id] ?? '');
    _text.addListener(_saveDraft);
  }

  void _saveDraft() {
    if (!_eligible(widget.microTask)) return;
    final text = _text.text;
    widget.controller.savedTextOutputs[widget.microTask.id] = text;
    // Persist edits without triggering navigation or final submission.
    _saving = _saving.then((_) => widget.controller
        .persistTextOutput(widget.microTask.id, text, taskDetail: widget.task));
  }

  @override
  void dispose() {
    _text.removeListener(_saveDraft);
    _text.dispose();
    super.dispose();
  }

  bool _validText(String text) {
    final length = text.trim().length;
    return length > 0 &&
        (widget.task.minCharacters == null ||
            length >= widget.task.minCharacters!) &&
        (widget.task.maxCharacters == null ||
            length <= widget.task.maxCharacters!);
  }

  bool get _valid => _validText(_text.text);

  int? get _nextEligible {
    for (var i = widget.index + 1; i < widget.task.microTasks.length; i++) {
      if (_eligible(widget.task.microTasks[i])) return i;
    }
    return null;
  }

  Future<void> _navigate(int index) async {
    FocusScope.of(context).unfocus();
    await _saving;
    if (mounted) widget.controller.selectedMicroTaskIndex.value = index;
  }

  Future<void> _continue() async {
    if (!_valid || widget.controller.isSubmittingTask.value) return;
    final next = _nextEligible;
    await _saving;
    if (!mounted) return;
    if (next != null) {
      await _navigate(next);
    } else {
      for (var i = 0; i < widget.task.microTasks.length; i++) {
        final item = widget.task.microTasks[i];
        if (_eligible(item) &&
            !_validText(widget.controller.savedTextOutputs[item.id] ?? '')) {
          await _navigate(i);
          return;
        }
      }
      FocusScope.of(context).unfocus();
      await widget.controller.submitTextOutput();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _PromptImage(url: widget.microTask.imageUrl),
        if (widget.microTask.instruction?.isNotEmpty == true)
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(widget.microTask.instruction!)),
        SubmissionWidget(),
        if (_eligible(widget.microTask)) ...[
          if (widget.microTask.acceptanceStatus == MicroTaskStatus.REJECTED)
            Text('home.tasks.attempts_left'.trParams(
                {'count': widget.microTask.remainingRetries.toString()})),
          ValidatedTextInputWidget(
            key: widget.textInputKey,
            label: 'common.text'.tr,
            controller: _text,
            placeHolder: 'home.tasks.type_text_placeholder'.tr,
            minCharacters: widget.task.minCharacters,
            maxCharacters: widget.task.maxCharacters,
            maxLines: 6,
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<TextEditingValue>(
              valueListenable: _text,
              builder: (context, value, child) {
                return Obx(() => FilledButton(
                      key: widget.submitButtonKey,
                      onPressed:
                          _valid && !widget.controller.isSubmittingTask.value
                              ? _continue
                              : null,
                      child: Text(widget.controller.isSubmittingTask.value
                          ? 'home.tasks.submitting'.tr
                          : (_nextEligible != null
                              ? 'common.continue'.tr
                              : 'common.submit'.tr)),
                    ));
              }),
        ],
        const SizedBox(height: 12),
        Center(child: Obx(() {
          final submitting = widget.controller.isSubmittingTask.value;
          return TaskNavigationBar(
            navigationKey: widget.navigationKey,
            currentIndex: widget.index,
            totalCount: widget.task.microTasks.length,
            compact: true,
            canNavigatePrevious: widget.index > 0 && !submitting,
            canNavigateNext:
                widget.index < widget.task.microTasks.length - 1 && !submitting,
            onPrevious: () => _navigate(widget.index - 1),
            onNext: () => _navigate(widget.index + 1),
            onHistory:
                widget.microTask.acceptanceStatus != MicroTaskStatus.NOT_STARTED
                    ? () => widget.controller
                        .showSubmissionHistoryBottomSheet(widget.microTask.id)
                    : null,
          );
        })),
      ]),
    );
  }
}

class _RemotePromptImage extends StatefulWidget {
  final String? url;
  const _RemotePromptImage({required this.url});

  @override
  State<_RemotePromptImage> createState() => _RemotePromptImageState();
}

class _RemotePromptImageState extends State<_RemotePromptImage> {
  int _retry = 0;

  @override
  Widget build(BuildContext context) {
    final url = widget.url;
    if (url == null || url.isEmpty) {
      return Text('home.tasks.image_unavailable'.tr);
    }
    return Image.network(
      url,
      key: ValueKey('$url-$_retry'),
      fit: BoxFit.contain,
      semanticLabel: 'home.tasks.source_image'.tr,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : const Center(child: CircularProgressIndicator()),
      errorBuilder: (context, error, stack) => Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('home.tasks.image_unavailable'.tr),
        TextButton(
            onPressed: () async {
              await NetworkImage(url).evict();
              if (mounted) setState(() => _retry++);
            },
            child: Text('common.retry'.tr)),
      ])),
    );
  }
}

class _PromptImage extends StatelessWidget {
  final String? url;
  const _PromptImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
          height: 220,
          width: double.infinity,
          child: _RemotePromptImage(url: url)),
      TextButton.icon(
        icon: const Icon(Icons.zoom_in),
        label: Text('home.tasks.enlarge_image'.tr),
        onPressed: url == null
            ? null
            : () => showDialog<void>(
                context: context,
                builder: (context) => Dialog.fullscreen(
                      child: Scaffold(
                        appBar: AppBar(
                            title: Text('home.tasks.source_image'.tr),
                            leading: CloseButton(
                                onPressed: () => Navigator.pop(context))),
                        body: InteractiveViewer(
                            minScale: 1,
                            maxScale: 8,
                            child: SizedBox.expand(
                                child: _RemotePromptImage(url: url))),
                      ),
                    )),
      ),
    ]);
  }
}
