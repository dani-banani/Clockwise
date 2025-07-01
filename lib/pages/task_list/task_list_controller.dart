import 'package:computing_project/navigation/app_routes.dart';
import 'package:computing_project/pages/home_page/home_controller.dart';
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
  HomeController homeController = Get.find();

  final ColorScheme colorScheme = Get.theme.colorScheme;

  Rx<TextEditingController> categoryNameController =
      TextEditingController().obs;

  Rx<int> selectedColorIndex = (-1).obs;
  String selectedColor = "";

  RxList<AccordionItem> taskAccordions = <AccordionItem>[].obs;

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

  @override
  void onInit() async {
    onRefresh();
    super.onInit();
  }

  void onRefresh({bool remainExpandedAccordions = false}) async {
    List<int> expandedCategoryIds = [];
    if (remainExpandedAccordions) {
      expandedCategoryIds = taskAccordions
          .where((item) => item.isExpanded)
          .map((item) => item.category.categoryId)
          .toList();
    }

    final response = await TaskApi.getUserTasksWithCategories();
    if (!response.success) {
      ErrorSnackbarWidget.showSnackbar(
          title: "Error", messages: response.message);
      return;
    }

    taskAccordions.value = response.data!
        .map((item) => AccordionItem(
            category: item,
            isExpanded: expandedCategoryIds.contains(item.categoryId)))
        .toList();

    taskAccordions.refresh();
  }

  void onAddTask() async {
    Get.toNamed(AppRoutes.addTask);
    return;
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

  void editCategory(Category category) async {
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

    if (!response.success) {
      ErrorSnackbarWidget.showSnackbar(
          title: "Error", messages: response.message);
      return;
    }

    onRefresh(remainExpandedAccordions: true);
    Get.back();
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

    if (!response.success) {
      if (response.statusCode == 401) {
        Get.offAllNamed(AppRoutes.registration);
        ErrorSnackbarWidget.showSnackbar(
            title: "Error", messages: response.message);
        return;
      }
      ErrorSnackbarWidget.showSnackbar(
          title: "Error", messages: response.message);
      return;
    }

    onRefresh(remainExpandedAccordions: true);
    Get.back();
  }

  Future<bool> deleteCategory(Category category) async {
    final response =
        await CategoryApi.deleteCategory(categoryId: category.categoryId);
    if (!response.success) {
      ErrorSnackbarWidget.showSnackbar(
          title: "Error", messages: response.message);
      return false;
    }

    onRefresh(remainExpandedAccordions: true);
    return true;
  }

  Future<bool> deleteTask(Task task) async {
    final response = await TaskApi.deleteTask(taskId: task.taskId);
    if (!response.success) {
      ErrorSnackbarWidget.showSnackbar(
          title: "Error", messages: response.message);
      return false;
    }

    onRefresh(remainExpandedAccordions: true);
    return true;
  }

  void toggleAccordian(int index) {
    taskAccordions[index].isExpanded = !taskAccordions[index].isExpanded;
    taskAccordions.refresh();
  }
}
