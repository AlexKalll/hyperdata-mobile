class Task {
  String? id;
  String? name;
  String? description;
  String? type;
  bool? requireContributorTest;
  bool? isPublic;
  bool? isClosed;
  bool? isArchived;
  bool? distributionStarted;
  DateTime? dueDate;
  int? averageTime;
  int? doneCount;
  int? totalCount;
  int? rejectedCount;
  int? approvedCount;
  int? pendingCount;
  String? status;
  int? minSeconds;
  int? maxSeconds;
  double? estimatedEarning;
  double? earningPerTask;

  Task({
    this.id,
    this.name,
    this.description,
    this.type,
    this.requireContributorTest,
    this.isPublic,
    this.isClosed,
    this.isArchived,
    this.distributionStarted,
    this.dueDate,
    this.averageTime,
    this.doneCount,
    this.totalCount,
    this.rejectedCount,
    this.approvedCount,
    this.pendingCount,
    this.status,
    this.minSeconds,
    this.maxSeconds,
    this.estimatedEarning,
    this.earningPerTask,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    print(json);
    // Detail responses use deadline; task lists use dead_line.
    final deadline = json['deadline'] ?? json['dead_line'];
    return Task(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      type: json['task_type'] as String?,
      requireContributorTest: json['require_contributor_test'] as bool?,
      dueDate: deadline != null
          ? DateTime.tryParse(deadline as String)
          : null,
      averageTime: json['average_time'] as int?,
      doneCount: json['done_count'] as int?,
      totalCount: json['total_count'] as int?,
      rejectedCount: json['rejected_count'] as int?,
      approvedCount: json['approved_count'] as int?,
      pendingCount: json['pending_count'] as int?,
      status: json['status'] as String?,
      minSeconds: json['taskRequirement']?['min_seconds'] as int?,
      maxSeconds: json['taskRequirement']?['max_seconds'] as int?,
      estimatedEarning: json['estimated_earning'] != null
          ? (json['estimated_earning'] as num).toDouble()
          : null,
      earningPerTask: json['earning_per_task'] != null
          ? (json['earning_per_task'] as num).toDouble()
          : null,
    );
  }
}
