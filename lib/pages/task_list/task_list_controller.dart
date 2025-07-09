import 'package:computing_project/api/sub_task_api.dart';
import 'package:computing_project/model/api_response.dart';
import 'package:computing_project/model/subtask.dart';
import 'package:computing_project/utils/api_response_handler.dart';
import 'package:computing_project/widgets/error_snackbar_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:computing_project/api/category_api.dart';
import 'package:computing_project/api/task_api.dart';
import 'package:computing_project/model/category.dart';
import 'package:computing_project/model/task.dart';

class ColorSelection {
  final Color color;
  bool isSelected;

  ColorSelection({required this.color, required this.isSelected});
}

class AccordionItem {
  final Category category;
  bool isExpanded;

  AccordionItem({required this.category, required this.isExpanded});
}

class TaskListController extends GetxController {
  final ColorScheme colorScheme = Get.theme.colorScheme;
  Rx<TextEditingController> categoryNameController =
      TextEditingController().obs;
  Rx<int> selectedColorIndex = (-1).obs;
  String selectedColor = "";
  RxList<AccordionItem> taskAccordions = <AccordionItem>[].obs;
  List<AccordionItem> categoryList = <AccordionItem>[];

  List<Color> colorOptions = const [
    Color(0xFFA8D8D8), // Darker sky blue (coolest)
    Color(0xFFA8D8B8), // Darker seafoam (cool)
    Color(0xFFB8D8B8), // Darker mint green (cool)
    Color(0xFFB8D8A8), // Darker lime green (neutral-cool)
    Color(0xFFB8A8D8), // Darker lavender (neutral)
    Color(0xFFD8A8B8), // Darker pink lavender (warm)
    Color(0xFFD8A8A8), // Darker peach (warm)
    Color(0xFFFFB366), // Light orange (warmest)
  ];

  //Bottom Modal
  Map<int, String> difficultyValues = {
    1: "Very Easy",
    2: "Easy",
    3: "Moderate",
    4: "Difficult",
    5: "Very Difficult",
  };
  Map<int, String> priorityValues = {
    1: "Low Priority",
    2: "Normal Priority",
    3: "High Priority",
  };
  late Rx<Task> currentTaskShownInModal;
  Rx<Category?> currentCategoryShownInModal = Rx<Category?>(null);
  Rx<TextEditingController> taskDescriptionController =
      TextEditingController().obs;
  FocusNode taskDescriptionFocusNode = FocusNode();
  Rx<bool> hasTaskDescriptionChanged = false.obs;
  Rx<int> selectedTaskDifficulty = 0.obs;
  Rx<int> selectedTaskPriority = 0.obs;
  Rx<TextEditingController> subtaskNameController = TextEditingController().obs;
  Rx<TextEditingController> taskNameController = TextEditingController().obs;
  Rx<DateTime?> reminderStartDate = Rx<DateTime?>(null);
  Rx<int> reminderFrequency = 0.obs;

  @override
  void onInit() async {
    onReload();
    super.onInit();
  }

  void onReload({bool remainExpandedAccordions = false}) async {
    List<int> expandedCategoryIds = [];
    if (remainExpandedAccordions) {
      expandedCategoryIds = taskAccordions
          .where((item) => item.isExpanded)
          .map((item) => item.category.categoryId)
          .toList();
    }

    final response = await TaskApi.getUserTasksWithCategories();
    if (!ApiResponseHandler.handleProtectedApiResponse(response)) return;

    taskAccordions.value = response.data!.map((item) {
      return AccordionItem(
        category: item,
        isExpanded: expandedCategoryIds.contains(item.categoryId),
      );
    }).toList();

    taskAccordions.refresh();
  }

  void onModalShown(Task task, Category? category) {
    currentTaskShownInModal = task.obs;
    currentCategoryShownInModal = category.obs;

    taskDescriptionController.value.text =
        currentTaskShownInModal.value.taskDescription;
    hasTaskDescriptionChanged.value = false;

    selectedTaskDifficulty.value = currentTaskShownInModal.value.difficulty;
    selectedTaskPriority.value = currentTaskShownInModal.value.priority;
  }

  void onColorSelected(int index, Color color) {
    if (index == selectedColorIndex.value) {
      selectedColorIndex.value = -1;
      selectedColor = "";
      return;
    }

    selectedColorIndex.value = index;
    selectedColor =
        color.toARGB32().toRadixString(16).padLeft(9, '0x').toUpperCase();
  }

  //Category
  void editCategoryName(Category category) async {
    List<String> errors = [];

    if (categoryNameController.value.text.isEmpty) {
      errors.add("Category name is required");
    }

    if (errors.isNotEmpty) {
      ErrorSnackbarWidget.showSnackbar(title: "Error", messages: errors);
      return;
    }

    final response = await CategoryApi.editCategory(
      categoryId: category.categoryId,
      fieldsToUpdate: {
        "cw_category_name": categoryNameController.value.text,
        "cw_category_color": selectedColor,
      },
    );

    if (!ApiResponseHandler.handleProtectedApiResponse(response,
        errorTitle: "Failed to Edit Category")) {
      return;
    }

    onReload(remainExpandedAccordions: true);
  }

  void addCategory() async {
    List<String> errors = [];

    if (categoryNameController.value.text.isEmpty) {
      errors.add("Category name is required");
    }

    if (errors.isNotEmpty) {
      ErrorSnackbarWidget.showSnackbar(title: "Error", messages: errors);
      return;
    }

    final response = await CategoryApi.createCategory(
      name: categoryNameController.value.text,
      color: selectedColor,
    );

    if (!ApiResponseHandler.handleProtectedApiResponse(response,
        errorTitle: "Failed to Add Category")) return;

    onReload(remainExpandedAccordions: true);
    Get.back();
  }

  Future<bool> deleteCategory(Category category) async {
    final response =
        await CategoryApi.deleteCategory(categoryId: category.categoryId);
    if (!ApiResponseHandler.handleProtectedApiResponse(response,
        errorTitle: "Failed to Delete Category")) return false;

    onReload(remainExpandedAccordions: true);
    return true;
  }

  //Task
  Future<bool> deleteTask(Task task) async {
    final response = await TaskApi.deleteTask(taskId: task.taskId);
    if (!ApiResponseHandler.handleProtectedApiResponse(response,
        errorTitle: "Failed to Delete Task")) {
      return false;
    }

    onReload(remainExpandedAccordions: true);
    return true;
  }

  Future<void> editTaskName(Task task) async {
    if (taskNameController.value.text == task.taskName) {
      return;
    }

    List<String> errors = [];

    if (taskNameController.value.text.isEmpty) {
      errors.add("Task name is required");
    }

    final response =
        await TaskApi.editTask(taskId: task.taskId, fieldsToUpdate: {
      "cw_task_name": taskNameController.value.text,
    });

    if (!ApiResponseHandler.handleProtectedApiResponse(response,
        errorTitle: "Failed to Edit Task Name")) {
      return;
    }

    currentTaskShownInModal.value.taskName = taskNameController.value.text;
    Get.back();
  }

  Future<void> editTaskDescription(Task task) async {
    final response =
        await TaskApi.editTask(taskId: task.taskId, fieldsToUpdate: {
      "cw_task_description": taskDescriptionController.value.text,
    });

    if (!ApiResponseHandler.handleProtectedApiResponse(response,
        errorTitle: "Failed to Edit Task Description")) {
      return;
    }

    currentTaskShownInModal.value.taskDescription =
        taskDescriptionController.value.text;
    hasTaskDescriptionChanged.value = false;
    taskDescriptionFocusNode.unfocus();
  }

  Future<void> editTaskCategory(Task task, Category? category) async {
    Category? oldCategory = currentCategoryShownInModal.value;

    currentCategoryShownInModal.value = category;

    final response =
        await TaskApi.editTask(taskId: task.taskId, fieldsToUpdate: {
      "cw_category_id": category?.categoryId == 0 ? null : category?.categoryId,
    });

    if (!ApiResponseHandler.handleProtectedApiResponse(response,
        errorTitle: "Failed to Edit Task Category")) {
      currentCategoryShownInModal.value = oldCategory;
      return;
    }
  }

  Future<void> editTaskDifficulty(Task task) async {
    if (selectedTaskDifficulty.value == task.difficulty) {
      return;
    }

    final response =
        await TaskApi.editTask(taskId: task.taskId, fieldsToUpdate: {
      "cw_task_difficulty": selectedTaskDifficulty.value,
    });

    if (!ApiResponseHandler.handleProtectedApiResponse(response,
        errorTitle: "Failed to Edit Task Difficulty")) {
      return;
    }

    currentTaskShownInModal.value.difficulty = selectedTaskDifficulty.value;
    Get.back();
  }

  Future<void> editTaskPriority(Task task) async {
    if (selectedTaskPriority.value == task.priority) {
      return;
    }

    final response =
        await TaskApi.editTask(taskId: task.taskId, fieldsToUpdate: {
      "cw_task_priority": selectedTaskPriority.value,
    });

    if (!ApiResponseHandler.handleProtectedApiResponse(response,
        errorTitle: "Failed to Edit Task Priority")) {
      return;
    }

    currentTaskShownInModal.value.priority = selectedTaskPriority.value;
    Get.back();
  }

  Future<void> editTaskDueDate(Task task, DateTime? dueDate) async {
    final response =
        await TaskApi.editTask(taskId: task.taskId, fieldsToUpdate: {
      "cw_task_due_date": dueDate?.toIso8601String(),
    });

    if (!ApiResponseHandler.handleProtectedApiResponse(response,
        errorTitle: "Failed to Edit Task Due Date")) {
      return;
    }

    currentTaskShownInModal.value.dueDate = dueDate;
  }

  Future<void> editTaskReminderDateAndFrequency(Task task, DateTime? reminderStartDate, int reminderFrequency) async {
    final response = await TaskApi.editTask(taskId: task.taskId, fieldsToUpdate: {
      "cw_task_reminder_start_date": reminderStartDate?.toIso8601String(),
      "cw_task_reminder_frequency": reminderFrequency,
    });

    if (!ApiResponseHandler.handleProtectedApiResponse(response,
        errorTitle: "Failed to Edit Task Reminder Date and Frequency")) {
      return;
    }

    currentTaskShownInModal.value.reminderStartDate = reminderStartDate;
    currentTaskShownInModal.value.reminderFrequency = reminderFrequency;
    currentTaskShownInModal.refresh();
  }
  //Subtask
  Future<void> addSubtask(Task task) async {
    List<String> errors = [];

    if (subtaskNameController.value.text.trim().isEmpty) {
      errors.add("Subtask name is required");
    }

    if (errors.isNotEmpty) {
      ErrorSnackbarWidget.showSnackbar(title: "Failed to Add Subtask", messages: errors);
      return;
    }

    final response = await SubTaskApi.createSubTask(
        taskId: task.taskId, subTaskName: subtaskNameController.value.text);

    if (!ApiResponseHandler.handleProtectedApiResponse(response,
        errorTitle: "Failed to Add Subtask")) {
      return;
    }

    currentTaskShownInModal.value.subtasks.add(response.data!);
    Get.back();
  }

  Future<void> editSubtaskName(Subtask subtask) async {
    List<String> errors = [];

    if (subtaskNameController.value.text.isEmpty) {
      errors.add("Subtask name is required");
    }

    if (errors.isNotEmpty) {
      ErrorSnackbarWidget.showSnackbar(title: "Failed to Edit Subtask Name", messages: errors);
      return;
    }

    final currentSubtaskInShownTask = currentTaskShownInModal.value.subtasks
        .firstWhere((element) => element.subtaskId == subtask.subtaskId);

    final response = await SubTaskApi.editSubTask(
        subTaskId: subtask.subtaskId,
        fieldsToUpdate: {
          "cw_subtask_name": subtaskNameController.value.text,
        });

    if (!ApiResponseHandler.handleProtectedApiResponse(response,
        errorTitle: "Failed to Add Subtask")) {
      return;
    }

    currentSubtaskInShownTask.subtaskName = subtaskNameController.value.text;
    Get.back();
  }

  Future<bool> deleteSubtask(Subtask subtask) async {
    final response =
        await SubTaskApi.deleteSubTask(subTaskId: subtask.subtaskId);

    if (!ApiResponseHandler.handleProtectedApiResponse(response,
        errorTitle: "Failed to Delete Subtask")) {
      return false;
    }

    currentTaskShownInModal.value.subtasks.remove(subtask);
    currentTaskShownInModal.refresh();
    return true;
  }

  void toggleTaskCompletion(dynamic task) async {
    late ApiResponse response;
    task.isCompleted = !task.isCompleted;

    switch (task) {
      case Task _:
        taskAccordions.refresh();
        currentTaskShownInModal.refresh();
        response = await TaskApi.editTask(taskId: task.taskId, fieldsToUpdate: {
          "cw_task_completion_status": task.isCompleted,
        });

        if (!ApiResponseHandler.handleProtectedApiResponse(response,
            errorTitle: "Failed to Toggle Task Completion")) {
          task.isCompleted = !task.isCompleted;
        }
        break;
      case Subtask _:
        currentTaskShownInModal.refresh();

        response = await SubTaskApi.editSubTask(
            subTaskId: task.subtaskId,
            fieldsToUpdate: {
              "cw_subtask_completion_status": task.isCompleted,
            });

        if (!ApiResponseHandler.handleProtectedApiResponse(response,
            errorTitle: "Failed to Toggle Subtask Completion")) {
          task.isCompleted = !task.isCompleted;
        }
        break;
    }

    currentTaskShownInModal.refresh();
    taskAccordions.refresh();
  }

  void toggleAccordian(int index) {
    taskAccordions[index].isExpanded = !taskAccordions[index].isExpanded;
    taskAccordions.refresh();
  }
}
