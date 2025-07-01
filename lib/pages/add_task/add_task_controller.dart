import 'package:computing_project/api/task_api.dart';
import 'package:computing_project/pages/home_page/home_controller.dart';
import 'package:computing_project/pages/task_list/task_list_controller.dart';
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
  Rx<int> priority = 1.obs;
  Rx<int> daysBeforeReminder = 0.obs;
  Rx<int> reminderFrequency = 0.obs;
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
    DateTime? dueDate;
    List<String> errorMessages = [];

    if (taskNameController.value.text.isEmpty) {
      errorMessages.add("Task name is empty");
    }

    if (taskDueDate.value == null && taskDueTime.value != null) {
      errorMessages.add("Due date must be selected if time is selected");
    }

    if (taskDueDate.value != null) {
      dueDate = DateTime(
          taskDueDate.value!.year,
          taskDueDate.value!.month,
          taskDueDate.value!.day,
          taskDueTime.value?.hour ?? 0,
          taskDueTime.value?.minute ?? 0);
    }

    if (errorMessages.isNotEmpty) {
      ErrorSnackbarWidget.showSnackbar(
          title: "Failed to Add Task", messages: errorMessages);
      return;
    }

    final response = await TaskApi.createTask(
      name: taskNameController.value.text,
      description: taskDescriptionController.value.text,
      dueDate: dueDate?.toIso8601String(),
      category: categoryId.value,
      difficulty: difficulty.value,
      priority: priority.value,
    );

    if (!response.success) {
      ErrorSnackbarWidget.showSnackbar(
          title: "Failed to Add Task", messages: response.message);
      return;
    }

    taskListController.onRefresh();
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

  void onDatePickerTap(BuildContext context, ColorScheme colorScheme) {
    // showDatePicker(

    //   context: Get.context!,
    //   firstDate: DateTime.now().subtract(Duration(days: 365 * 20)),
    //   lastDate: DateTime.now().add(Duration(days: 365 * 20)),
    //   initialDatePickerMode: DatePickerMode.day,
    //   initialEntryMode: DatePickerEntryMode.calendarOnly,
    //   helpText: "Select Due Date",

    // ).then((date) {
    //   if (date == null) return;
    //   if (date == taskDueDate.value) return;

    //   taskDueDate.value = date;
    //   isDueDateSelected.value = true;
    // });
    // Navigator.of(context).push(
    // showPicker(
    //   context: context,
    //   value: Time(hour: 12, minute: 0),
    //   iosStylePicker: true,
    //   pmLabel: "PM",
    //   amLabel: "AM",
    //   hourLabel: "Hours",
    //   minuteLabel: "Minutes",

    //   accentColor: colorScheme.primary,
    //   backgroundColor: colorScheme.surface,
    //   focusMinutePicker: false,

    //   onChange: (value) {
    //     // taskDueDate.value = value;
    //     isDueDateSelected.value = true;
    //   },
    // ),);
  }

  //Category (Fetch from category table)

  //Dropdown days before reminder (Choose a date)
  //Reminder frequency (Daily, Weekly, Biweekly and Custom)
}
