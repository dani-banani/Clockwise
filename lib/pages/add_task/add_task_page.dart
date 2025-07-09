import 'package:computing_project/pages/add_task/add_task_controller.dart';
import 'package:computing_project/widgets/app_bar_widget.dart';
import 'package:computing_project/widgets/datetime_picker_widget.dart';
import 'package:computing_project/widgets/category_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:computing_project/widgets/text_field_widget.dart';
import 'package:computing_project/widgets/slider_widget.dart';
import 'package:computing_project/widgets/button_widget.dart';
import 'package:computing_project/model/category.dart';

class AddTaskPage extends GetView<AddTaskController> {
  final ColorScheme colorScheme;
  const AddTaskPage({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments = Get.arguments;
    final Category? defaultCategory = arguments?["category"];
    if (defaultCategory != null) {
      controller.onCategoryChange(defaultCategory.categoryId);
    }

    return Scaffold(
      appBar: AppBarWidget(title: "Add Task", colorScheme: colorScheme),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Obx(() {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics()
                  .applyTo(const BouncingScrollPhysics()),
              child: Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    TextFieldWidget(
                        colorScheme: colorScheme,
                        hintText: "Task Name",
                        textController: controller.taskNameController.value,
                        isTextHidden: false),
                    const SizedBox(height: 20),
                    TextFieldWidget(
                        colorScheme: colorScheme,
                        hintText: "Task Description",
                        textController:
                            controller.taskDescriptionController.value,
                        isTextHidden: false,
                        minLines: 3,
                        maxLines: 5),
                    const SizedBox(height: 20),
                    CategorySelectionWidget(
                        label: "Select Task Category",
                        onChanged: (value) {
                          controller.onCategoryChange(value?.categoryId ?? 0);
                        },
                        selectedCategory: controller.categories.firstWhereOrNull((element) => element.categoryId == controller.categoryId.value)),
                    const SizedBox(height: 20),
                    SliderWidget(
                        label: "Difficulty",
                        colorScheme: colorScheme,
                        values: controller.difficultyValues,
                        selectedKey: controller.difficulty.value,
                        onChanged: (value) {
                          controller.difficulty.value = value;
                        }),
                    const SizedBox(height: 20),
                    SliderWidget(
                        label: "Priority",
                        colorScheme: colorScheme,
                        values: controller.priorityValues,
                        selectedKey: controller.priority.value,
                        onChanged: (value) {
                          controller.priority.value = value;
                        }),
                    const SizedBox(height: 20),
                    DateTimePickerWidget(
                        onDateTimeSelected: (date) {
                          controller.onDateSelected(date);
                        },
                        selectedDate: controller.taskDueDate.value,
                        helpText: "Select Task Due Date"),
                    const SizedBox(height: 40),
                    ButtonWidget(
                        colorScheme: colorScheme,
                        onPressed: controller.onAddTask,
                        width: Get.width * 0.4,
                        height: 50,
                        child: const Text("Submit")),
                  ],
                ),
              ),
            );
          });
        }),
      ),
    );
  }
}
