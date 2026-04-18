import 'package:leyu_mobile/features/home/domain/entities/task_entity.dart';

import '../../data/models/task_detail.dart';
import 'micro_task_entity.dart';

class TaskDetailEntity {
  final bool isTest;
  final TestStatus? testStatus;
  final int batch;
  final TaskEntity task;
  final List<MicroTaskEntity> microTasks;
  final TaskInstruction? taskInstruction;
  final int? minSeconds;
  final int? maxSeconds;
  final int? minCharacters;
  final int? maxCharacters;

  TaskDetailEntity({
    this.isTest = false,
    this.testStatus,
    this.batch = 0,
    required this.task,
    this.microTasks = const [],
    this.taskInstruction,
    this.minSeconds,
    this.maxSeconds,
    this.minCharacters,
    this.maxCharacters,
  });

  static TaskDetailEntity fromModel(TaskDetail model) {
    // Map microTasks to MicroTaskEntity
    var microTasks = model.microTasks.map((e) => MicroTaskEntity.fromModel(e)).toList();

    // // Sort microTasks by acceptanceStatus: APPROVED, UNDER_REVIEW, REJECTED, NOT_STARTED
    // microTasks.sort((a, b) {
    //   const statusPriority = {
    //     MicroTaskStatus.APPROVED: 0,
    //     MicroTaskStatus.UNDER_REVIEW: 1,
    //     MicroTaskStatus.REJECTED: 2,
    //     MicroTaskStatus.NOT_STARTED: 3,
    //   };
    //   return statusPriority[a.acceptanceStatus]!.compareTo(statusPriority[b.acceptanceStatus]!);
    // });

    return TaskDetailEntity(
      isTest: model.isTest,
      testStatus: model.testStatus,
      batch: model.batch,
      task: TaskEntity.fromModel(model.task),
      microTasks: microTasks,
      taskInstruction: model.taskInstruction,
      minSeconds: model.minSeconds,
      maxSeconds: model.maxSeconds,
      minCharacters: model.minCharacters,
      maxCharacters: model.maxCharacters,
    );
  }
}
