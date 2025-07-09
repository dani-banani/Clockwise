import 'package:computing_project/model/subtask.dart';

class Task {
  int taskId;
  String taskName;
  String taskDescription;
  int difficulty;
  int priority;
  int categoryId;
  int reminderFrequency;
  DateTime? reminderStartDate;
  DateTime? dueDate;
  DateTime createdDate;
  bool isCompleted;
  List<Subtask> subtasks;

  Task({
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.difficulty,
    required this.priority,
    required this.categoryId,
    required this.reminderFrequency,
    required this.reminderStartDate,
    required this.dueDate,
    required this.createdDate,
    required this.isCompleted,
    required this.subtasks,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['cw_task_id'],
      categoryId: json['cw_category_id'] == null ? 0 : json['cw_category_id'] as int,
      taskName: json['cw_task_name'],
      taskDescription: json['cw_task_description'],
      difficulty: json['cw_task_difficulty'],
      priority: json['cw_task_priority'],
      reminderFrequency: json['cw_task_reminder_frequency'],
      reminderStartDate: json['cw_task_reminder_start_date'] != null
          ? DateTime.parse(json['cw_task_reminder_start_date'])
          : null,
      dueDate: json['cw_task_due_date'] != null
          ? DateTime.parse(json['cw_task_due_date'])
          : null,
      createdDate: DateTime.parse(json['cw_task_created_date']),
      isCompleted: json['cw_task_completion_status'] ?? false,
      subtasks: json['subtasks'] != null
          ? (json['subtasks'] as List<dynamic>)
              .map((subtaskJson) => Subtask.fromJson(subtaskJson))
              .toList()
          : [],
    );
  }

  String getTaskDifficulty() {
    switch (difficulty) {
      case 1:
        return "Very Easy";
      case 2:
        return "Easy";
      case 3:
        return "Moderate";
      case 4:
        return "Difficult";
      case 5:
        return "Very Difficult";
      default:
        return "Unknown";
    }
  }

  String getTaskPriority() {
    switch (priority) {
      case 1:
        return "Low Priority";
      case 2:
        return "Normal Priority";
      case 3:
        return "High Priority";
      default:
        return "Unknown";
    }
  }
}
