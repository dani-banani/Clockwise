import 'package:computing_project/api/task_api.dart';
import 'package:computing_project/pages/home_page/home_controller.dart';
import 'package:computing_project/pages/task_list/task_list_controller.dart';
import 'package:computing_project/utils/api_response_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../navigation/app_routes.dart';
import '../../model/category.dart';
import '../../widgets/error_snackbar_widget.dart';

class AddTaskController extends GetxController {
  HomeController homeController = Get.find();
  TaskListController taskListController = Get.find();

  Rx<TextEditingController> taskNameController = TextEditingController().obs;
  Rx<TextEditingController> taskDescriptionController =
      TextEditingController().obs;
  Rx<DateTime?> taskDueDate = Rx<DateTime?>(null);
  Rx<DateTime?> taskDueTime = Rx<DateTime?>(null);
  Rx<int> difficulty = 1.obs;
  Map<int, String> difficultyValues = {
    1: "Very Easy",
    2: "Easy",
    3: "Moderate",
    4: "Difficult",
    5: "Very Difficult",
  };
  Rx<int> priority = 2.obs;
  Map<int, String> priorityValues = {
    1: "Low Priority",
    2: "Normal Priority",
    3: "High Priority",
  };
  Rx<int> reminderFrequency = 1.obs;
  Rx<int> categoryId = 0.obs;

  RxList<Category> categories = <Category>[].obs;

  @override
  void onInit() async {
    super.onInit();
    onReload();
  }

  void onReload() async {
    final response = await TaskApi.getUserTasksWithCategories();
    if (!response.success) {
      if (response.statusCode == 401) {
        Get.offAllNamed(AppRoutes.registration);
        return;
      }

      ErrorSnackbarWidget.showSnackbar(
          title: "Error", messages: response.message);
      return;
    }

    categories.value = response.data!;
  }

  void onCategoryChange(int selectedCategoryId) {
    if (selectedCategoryId == categoryId.value) {
      return;
    }

    categoryId.value = selectedCategoryId;
  }

  void onAddTask() async {
    List<String> errorMessages = [];

    if (taskNameController.value.text.isEmpty) {
      errorMessages.add("Task name is empty");
    }

    if (errorMessages.isNotEmpty) {
      ErrorSnackbarWidget.showSnackbar(
          title: "Failed to Add Task", messages: errorMessages);
      return;
    }

    final response = await TaskApi.createTask(
      name: taskNameController.value.text,
      description: taskDescriptionController.value.text,
      dueDate: taskDueDate.value?.toIso8601String(),
      reminderStartDate: taskDueDate.value?.toIso8601String(),
      reminderFrequency: reminderFrequency.value,
      category: categoryId.value == 0 ? null : categoryId.value,
      difficulty: difficulty.value,
      priority: priority.value,
    );

    if (!ApiResponseHandler.handleProtectedApiResponse(response)) return;

    taskListController.onReload();
    Get.offAllNamed(AppRoutes.taskList);
  }

  void onDateSelected(DateTime? dateTime) {
    if (dateTime == taskDueDate.value) return;

    taskDueDate.value = dateTime;
  }

  void onTimeSelected(DateTime? time) {
    if (time == taskDueTime.value) return;

    taskDueTime.value = time;
  }
}
