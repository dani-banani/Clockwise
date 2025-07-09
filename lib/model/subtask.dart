class Subtask {
  int subtaskId;
  String subtaskName;
  bool isCompleted;

  Subtask({
    required this.subtaskId,
    required this.subtaskName,
    required this.isCompleted,
  });

  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      subtaskId: json['cw_subtask_id'],
      subtaskName: json['cw_subtask_name'],
      isCompleted: json['cw_subtask_completion_status'] ?? false,
    );
  }
}
