import 'package:computing_project/model/subtask.dart';
import 'package:computing_project/model/task.dart';
import 'package:computing_project/pages/task_list/task_list_controller.dart';
import 'package:computing_project/widgets/action_dialog.widget.dart';
import 'package:computing_project/widgets/app_bar_widget.dart';
import 'package:computing_project/widgets/category_selection_widget.dart';
import 'package:computing_project/widgets/confirmation_dialog.widget.dart';
import 'package:computing_project/widgets/datetime_picker_widget.dart';
import 'package:computing_project/widgets/reminder_picker_widget.dart';
import 'package:computing_project/widgets/slider_widget.dart';
import 'package:computing_project/widgets/text_field_widget.dart';
import 'package:get/get.dart';
import 'package:computing_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:computing_project/model/category.dart';
import '../../navigation/app_routes.dart';

class TaskListPage extends GetView<TaskListController> {
  final ColorScheme colorScheme;
  const TaskListPage({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Your Tasks", colorScheme: colorScheme),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Obx(() {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonWidget(
                        colorScheme: colorScheme,
                        onPressed: () => Get.toNamed(AppRoutes.addTask),
                        width: constraints.maxWidth * 0.35,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Add Task"), Icon(Icons.add)],
                        ),
                      ),
                      ButtonWidget(
                        colorScheme: colorScheme,
                        onPressed: () =>
                            showCategoryDialog(context, constraints),
                        width: constraints.maxWidth * 0.45,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Add Category"), Icon(Icons.add)],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: constraints.maxWidth,
                    alignment: Alignment.center,
                    height: 50,
                    decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10))),
                    child: Text(
                      "Task List",
                      style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ExpansionPanelList(
                              expandedHeaderPadding: EdgeInsets.zero,
                              materialGapSize: 0,
                              dividerColor: Colors.transparent,
                              expandIconColor: colorScheme.onSecondary,
                              expansionCallback: (panelIndex, isExpanded) {
                                controller.toggleAccordian(panelIndex);
                              },
                              children: controller.taskAccordions
                                  .map((taskAccordion) {
                                return ExpansionPanel(
                                  canTapOnHeader: true,
                                  backgroundColor: colorScheme.secondary,
                                  headerBuilder: (context, isExpanded) {
                                    return ListTile(
                                      title: Row(
                                        children: [
                                          if (taskAccordion.category
                                              .isCategoryColored()) ...[
                                            Container(
                                              width: 15,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: taskAccordion.category
                                                    .getCategoryColor(),
                                              ),
                                            ),
                                            const SizedBox(width: 20)
                                          ],
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                taskAccordion
                                                    .category.categoryName,
                                                softWrap: true,
                                                style: TextStyle(
                                                    color:
                                                        colorScheme.onSecondary,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                "${taskAccordion.category.tasks.where((task) => task.isCompleted).length} / ${taskAccordion.category.tasks.length}",
                                                style: TextStyle(
                                                    color:
                                                        colorScheme.onSecondary,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 32,
                                            child: IconButton(
                                              onPressed: () {
                                                showCategoryDialog(
                                                    context, constraints,
                                                    defaultCategory:
                                                        taskAccordion.category);
                                              },
                                              icon: const Icon(Icons.edit),
                                              constraints:
                                                  const BoxConstraints(),
                                              iconSize: 16,
                                              style: IconButton.styleFrom(
                                                foregroundColor:
                                                    colorScheme.onSecondary,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 32,
                                            child: IconButton(
                                              onPressed: () {
                                                Get.toNamed(AppRoutes.addTask,
                                                    arguments: {
                                                      "category": taskAccordion
                                                          .category,
                                                    });
                                              },
                                              icon: const Icon(Icons.add),
                                              iconSize: 16,
                                              constraints:
                                                  const BoxConstraints(),
                                              style: IconButton.styleFrom(
                                                foregroundColor:
                                                    colorScheme.onSecondary,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 32,
                                            child: IconButton(
                                              onPressed: () async {
                                                await showDeleteConfirmationDialog(
                                                    context,
                                                    constraints,
                                                    taskAccordion.category);
                                              },
                                              icon: const Icon(Icons.delete),
                                              constraints:
                                                  const BoxConstraints(),
                                              iconSize: 16,
                                              style: IconButton.styleFrom(
                                                foregroundColor:
                                                    colorScheme.onSecondary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  body: Column(
                                    children: [
                                      ...taskAccordion.category.tasks
                                          .map((task) => Container(
                                                color: task.isCompleted
                                                    ? colorScheme
                                                        .primaryFixedDim
                                                    : colorScheme
                                                        .primaryContainer,
                                                child: Dismissible(
                                                  key: Key(
                                                      task.taskId.toString()),
                                                  direction: DismissDirection
                                                      .startToEnd,
                                                  confirmDismiss:
                                                      (direction) async {
                                                    return await showDeleteConfirmationDialog(
                                                        context,
                                                        constraints,
                                                        task);
                                                  },
                                                  dismissThresholds: const {
                                                    DismissDirection.startToEnd:
                                                        0.4,
                                                  },
                                                  background: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    color: colorScheme.error,
                                                    child: const Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.delete,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          "Delete Task",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  child: ListTile(
                                                    dense: true,
                                                    onTap: () {
                                                      controller.onModalShown(
                                                          task,
                                                          taskAccordion
                                                              .category);
                                                      showTaskDetailModal(
                                                          context,
                                                          constraints,
                                                          colorScheme);
                                                    },
                                                    leading: Checkbox(
                                                      value: task.isCompleted,
                                                      onChanged: (value) {
                                                        controller
                                                            .toggleTaskCompletion(
                                                                task);
                                                      },
                                                    ),
                                                    title: Text(
                                                      task.taskName,
                                                      style: TextStyle(
                                                        color: colorScheme
                                                            .onPrimaryContainer,
                                                        decoration:
                                                            task.isCompleted
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : null,
                                                        decorationColor:
                                                            Colors.black,
                                                        decorationThickness: 2,
                                                      ),
                                                    ),
                                                    trailing: task
                                                            .subtasks.isNotEmpty
                                                        ? Text(
                                                            "${task.subtasks.where((subtask) => subtask.isCompleted).length} / ${task.subtasks.length}",
                                                            style: TextStyle(
                                                              color: colorScheme
                                                                  .onPrimaryContainer,
                                                            ),
                                                          )
                                                        : null,
                                                    tileColor: task.isCompleted
                                                        ? colorScheme
                                                            .primaryFixedDim
                                                        : colorScheme
                                                            .primaryContainer,
                                                  ),
                                                ),
                                              )),
                                    ],
                                  ),
                                  isExpanded: taskAccordion.isExpanded,
                                );
                              }).toList(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  void showCategoryDialog(BuildContext context, BoxConstraints constraints,
      {Category? defaultCategory}) {
    if (defaultCategory != null) {
      controller.categoryNameController.value.text =
          defaultCategory.categoryName;
      controller.selectedColorIndex.value =
          controller.colorOptions.indexOf(defaultCategory.getCategoryColor());
      controller.selectedColor = defaultCategory
          .getCategoryColor()
          .toARGB32()
          .toRadixString(16)
          .padLeft(9, '0x')
          .toUpperCase();
    }

    Get.dialog(
      ActionDialogWidget(
        title: defaultCategory != null ? "Edit Category" : "Add Category",
        body: Column(
          children: [
            TextFieldWidget(
              hintText: "Category Name",
              textController: controller.categoryNameController.value,
              isTextHidden: false,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 20),
            buildColorPicker(),
          ],
        ),
        onActionPressed: () {
          if (defaultCategory != null) {
            controller.editCategoryName(defaultCategory);
          } else {
            controller.addCategory();
          }
          Get.back();
        },
        actionText: defaultCategory != null ? "Edit Category" : "Add Category",
      ),
    );
  }

  Widget buildColorPicker() {
    return Obx(() {
      return Container(
        alignment: Alignment.center,
        width: double.maxFinite,
        height: 100,
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.0,
          children: controller.colorOptions.asMap().entries.map((entry) {
            final color = entry.value;
            final index = entry.key;
            return GestureDetector(
              onTap: () {
                controller.onColorSelected(index, color);
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  if (index == controller.selectedColorIndex.value)
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.check,
                        color: colorScheme.primary,
                        size: 20,
                        weight: 2,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Future<bool> showDeleteConfirmationDialog(
      BuildContext context, BoxConstraints constraints, dynamic item) async {
    String itemType = item.runtimeType.toString();
    Function() onConfirmPressed = () {};
    String itemName = "";

    switch (item) {
      case Category _:
        itemName = item.categoryName;
        onConfirmPressed = () {
          return controller.deleteCategory(item);
        };
        break;
      case Task _:
        itemName = item.taskName;
        onConfirmPressed = () {
          return controller.deleteTask(item);
        };
        break;
      case Subtask _:
        itemName = item.subtaskName;
        onConfirmPressed = () {
          return controller.deleteSubtask(item);
        };
        break;
    }

    return await Get.dialog(
      ConfirmationDialogWidget(
        title: "Delete $itemType",
        body: Text.rich(
          TextSpan(
            style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
            children: [
              const TextSpan(
                text: "Are you sure you want to delete ",
              ),
              TextSpan(
                text: itemName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
              const TextSpan(
                text: "? This action cannot be undone.",
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        actionText: "Delete $itemType",
      ),
    ).then((value) {
      if (value == null) {
        return false;
      }

      return onConfirmPressed();
    });
  }

  void showTaskDetailModal(BuildContext context, BoxConstraints constraints,
      ColorScheme colorScheme) {
    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        builder: (context) {
          return Obx(() {
            return SizedBox(
              height: constraints.maxHeight * 0.9,
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                    ),
                    child: Text(
                      controller.currentCategoryShownInModal.value
                              ?.categoryName ??
                          "Uncategorized",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics()
                          .applyTo(const BouncingScrollPhysics()),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Obx(() {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: controller.currentTaskShownInModal
                                        .value.isCompleted,
                                    onChanged: (value) {
                                      controller.toggleTaskCompletion(controller
                                          .currentTaskShownInModal.value);
                                    },
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        controller.currentTaskShownInModal.value
                                            .taskName,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          decoration: controller
                                                  .currentTaskShownInModal
                                                  .value
                                                  .isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          decorationColor: Colors.black,
                                          decorationThickness: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showEditTaskNameDialog(
                                          context,
                                          constraints,
                                          controller
                                              .currentTaskShownInModal.value);
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                ],
                              ),
                              Divider(
                                color: colorScheme.onPrimaryContainer,
                                thickness: 1,
                              ),
                              const SizedBox(height: 20),
                              TextFieldWidget(
                                focusNode: controller.taskDescriptionFocusNode,
                                colorScheme: colorScheme,
                                hintText: "Task Description",
                                textController:
                                    controller.taskDescriptionController.value,
                                isTextHidden: false,
                                minLines: 3,
                                maxLines: 3,
                                onChanged: (value) {
                                  if (value.trim() !=
                                      controller.currentTaskShownInModal.value
                                          .taskDescription
                                          .trim()) {
                                    controller.hasTaskDescriptionChanged.value =
                                        true;
                                    return;
                                  }
                                  controller.hasTaskDescriptionChanged.value =
                                      false;
                                },
                              ),
                              if (controller
                                  .hasTaskDescriptionChanged.value) ...[
                                const SizedBox(height: 20),
                                ButtonWidget(
                                    buttonType: ButtonType.secondary,
                                    width: double.maxFinite,
                                    colorScheme: colorScheme,
                                    onPressed: () {
                                      controller.editTaskDescription(controller
                                          .currentTaskShownInModal.value);
                                    },
                                    child: const Text("Save Task Description")),
                              ],
                              const SizedBox(height: 20),
                              CategorySelectionWidget(
                                  label: "Uncategorized",
                                  selectedCategory: controller
                                      .currentCategoryShownInModal.value,
                                  onChanged: (value) {
                                    controller.editTaskCategory(
                                        controller
                                            .currentTaskShownInModal.value,
                                        value);
                                  }),
                              const SizedBox(height: 20),
                              DateTimePickerWidget(
                                  onDateTimeSelected: (date) {
                                    controller.editTaskDueDate(
                                        controller
                                            .currentTaskShownInModal.value,
                                        date);
                                  },
                                  selectedDate: controller
                                      .currentTaskShownInModal.value.dueDate,
                                  minDate: DateTime.now(),
                                  maxDate: DateTime.now()
                                      .add(const Duration(days: 365 * 20)),
                                  helpText: "Select Due Date"),
                              const SizedBox(height: 20),
                              ReminderPickerWidget(
                                  onReminderFrequencySelected:
                                      (date, frequency) {
                                    controller.editTaskReminderDateAndFrequency(
                                        controller
                                            .currentTaskShownInModal.value,
                                        date,
                                        frequency ?? 0);
                                  },
                                  defaultSelectedDate: controller
                                      .currentTaskShownInModal.value.reminderStartDate,
                                  defaultSelectedReminderFrequency: controller
                                      .currentTaskShownInModal.value
                                      .reminderFrequency,
                                  minDate: DateTime.now(),
                                  maxDate: controller
                                      .currentTaskShownInModal.value.dueDate),
                              const SizedBox(height: 20),
                              IntrinsicHeight(
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: colorScheme.primary),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: GestureDetector(
                                              onTap: () {
                                                showEditTaskSliderDialog(
                                                    controller
                                                        .currentTaskShownInModal
                                                        .value,
                                                    "difficulty");
                                              },
                                              child: SizedBox.expand(
                                                  child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  style: TextStyle(
                                                      color:
                                                          colorScheme.onSurface,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 1.2),
                                                  children: [
                                                    const TextSpan(
                                                      text: "Difficulty:\n",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    TextSpan(
                                                      text: controller
                                                          .currentTaskShownInModal
                                                          .value
                                                          .getTaskDifficulty(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              )))),
                                      VerticalDivider(
                                        color: colorScheme.onPrimaryContainer,
                                        width: 2,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                            onTap: () {
                                              showEditTaskSliderDialog(
                                                  controller
                                                      .currentTaskShownInModal
                                                      .value,
                                                  "priority");
                                            },
                                            child: SizedBox.expand(
                                                child: RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                style: TextStyle(
                                                    color:
                                                        colorScheme.onSurface,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.2),
                                                children: [
                                                  const TextSpan(
                                                    text: "Priority: \n",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  TextSpan(
                                                    text: controller
                                                        .currentTaskShownInModal
                                                        .value
                                                        .getTaskPriority(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ))),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: constraints.maxWidth,
                                    alignment: Alignment.center,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(10))),
                                    child: Text(
                                      "SubTasks",
                                      style: TextStyle(
                                          color: colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        showAddSubtaskDialog(
                                            context,
                                            constraints,
                                            controller
                                                .currentTaskShownInModal.value);
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (controller.currentTaskShownInModal.value
                                  .subtasks.isEmpty)
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  alignment: Alignment.center,
                                  color: colorScheme.primaryContainer,
                                  child: Row(children: [
                                    Expanded(
                                      child: Divider(
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      "No Subtasks Added",
                                      style: TextStyle(
                                          color: colorScheme.onPrimaryContainer,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Divider(
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ]),
                                ),
                              if (controller.currentTaskShownInModal.value
                                  .subtasks.isNotEmpty)
                                ...controller
                                    .currentTaskShownInModal.value.subtasks
                                    .map(
                                  (subtask) => Dismissible(
                                    key: Key(
                                        "${controller.currentTaskShownInModal.value.taskId}:${subtask.subtaskId}"),
                                    direction: DismissDirection.startToEnd,
                                    confirmDismiss: (direction) async {
                                      return await showDeleteConfirmationDialog(
                                          context, constraints, subtask);
                                    },
                                    dismissThresholds: const {
                                      DismissDirection.startToEnd: 0.4,
                                    },
                                    background: Container(
                                      padding: const EdgeInsets.only(left: 20),
                                      alignment: Alignment.centerLeft,
                                      color: colorScheme.error,
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Delete SubTask",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.only(left: 20),
                                      dense: true,
                                      leading: Checkbox(
                                        value: subtask.isCompleted,
                                        onChanged: (value) {
                                          controller
                                              .toggleTaskCompletion(subtask);
                                        },
                                      ),
                                      title: Text(
                                        subtask.subtaskName,
                                        style: TextStyle(
                                          color: colorScheme.onPrimaryContainer,
                                          decoration: subtask.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          decorationColor: Colors.black,
                                          decorationThickness: 2,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          showEditTaskNameDialog(
                                              context, constraints, subtask);
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                      tileColor: subtask.isCompleted
                                          ? colorScheme.primaryFixedDim
                                          : colorScheme.primaryContainer,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        }).then((value) {
      controller.onReload(remainExpandedAccordions: true);
    });
  }

  void showEditTaskSliderDialog(Task task, String editingType) {
    String typeTitle = "";
    Map<int, String> typeValues = {};
    Rx<int> selectedKey = 0.obs;
    Function(int) onSliderChanged = (value) {};
    Function() onActionPressed = () {};

    switch (editingType) {
      case "difficulty":
        typeTitle = "Difficulty";
        typeValues = controller.difficultyValues;
        selectedKey = controller.selectedTaskDifficulty;
        onSliderChanged = (value) {
          controller.selectedTaskDifficulty.value = value;
        };
        onActionPressed = () {
          controller
              .editTaskDifficulty(controller.currentTaskShownInModal.value);
        };
        break;
      case "priority":
        typeTitle = "Priority";
        typeValues = controller.priorityValues;
        selectedKey = controller.selectedTaskPriority;
        onSliderChanged = (value) {
          controller.selectedTaskPriority.value = value;
        };
        onActionPressed = () {
          controller.editTaskPriority(controller.currentTaskShownInModal.value);
        };
        break;
    }

    Get.dialog(Obx(() {
      return ActionDialogWidget(
          title: "Edit Task $typeTitle",
          body: SliderWidget(
              colorScheme: colorScheme,
              values: typeValues,
              selectedKey: selectedKey.value,
              onChanged: onSliderChanged,
              label: typeTitle),
          actionText: "Edit $typeTitle",
          onActionPressed: () {
            onActionPressed();
          });
    }));
  }

  void showAddSubtaskDialog(
      BuildContext context, BoxConstraints constraints, Task task) {
    Get.dialog(ActionDialogWidget(
        title: "Add Subtask",
        body: TextFieldWidget(
            colorScheme: colorScheme,
            hintText: "Subtask Name",
            textController: controller.subtaskNameController.value,
            isTextHidden: false),
        actionText: "Add Subtask",
        onActionPressed: () {
          controller.addSubtask(task);
        })).then((value) {
      controller.subtaskNameController.value.clear();
    });
  }

  void showEditTaskNameDialog(
      BuildContext context, BoxConstraints constraints, dynamic task) {
    String typeTitle = "";
    late Rx<TextEditingController> textController;
    Function() onActionPressed = () {};

    switch (task) {
      case Task _:
        typeTitle = "Task";
        textController = controller.taskNameController;
        onActionPressed = () {
          controller.editTaskName(task);
        };
        break;
      case Subtask _:
        typeTitle = "Subtask";
        textController = controller.subtaskNameController;
        onActionPressed = () {
          controller.editSubtaskName(task);
        };
        break;
    }

    Get.dialog(ActionDialogWidget(
        title: "Edit $typeTitle",
        body: TextFieldWidget(
            colorScheme: colorScheme,
            hintText: "$typeTitle Name",
            textController: textController.value,
            isTextHidden: false),
        actionText: "Edit $typeTitle",
        onActionPressed: () {
          onActionPressed();
        }));
  }
}
