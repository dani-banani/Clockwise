import 'package:computing_project/model/task.dart';
import 'package:computing_project/pages/task_list/task_list_controller.dart';
import 'package:computing_project/widgets/app_bar_widget.dart';
import 'package:computing_project/widgets/confirmation_dialog.widget.dart';
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
                        onPressed: controller.onAddTask,
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
                                          Container(
                                            width: 32,
                                            child: IconButton(
                                              onPressed: () {
                                                showCategoryDialog(
                                                    context, constraints,
                                                    defaultCategory:
                                                        taskAccordion.category);
                                              },
                                              icon: Icon(Icons.edit),
                                              constraints: BoxConstraints(),
                                              iconSize: 16,
                                              style: IconButton.styleFrom(
                                                foregroundColor:
                                                    colorScheme.onSecondary,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 32,
                                            child: IconButton(
                                              onPressed: () {
                                                Get.toNamed(AppRoutes.addTask,
                                                    arguments: {
                                                      "category": taskAccordion
                                                          .category,
                                                    });
                                              },
                                              icon: Icon(Icons.add),
                                              iconSize: 16,
                                              constraints: BoxConstraints(),
                                              style: IconButton.styleFrom(
                                                foregroundColor:
                                                    colorScheme.onSecondary,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 32,
                                            child: IconButton(
                                              onPressed: () async {
                                                await showDeleteConfirmationDialog(
                                                    context,
                                                    constraints,
                                                    taskAccordion.category);
                                              },
                                              icon: Icon(Icons.delete),
                                              constraints: BoxConstraints(),
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
                                                      showTaskDetailModal(
                                                          context,
                                                          constraints,
                                                          colorScheme,
                                                          taskAccordion
                                                              .category,
                                                          task);
                                                    },
                                                    leading: Checkbox(
                                                      value: task.isCompleted,
                                                      onChanged: (value) {
                                                        task.isCompleted =
                                                            !task.isCompleted;
                                                        controller
                                                            .taskAccordions
                                                            .refresh();

                                                        print("check!");
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

    showDialog(
      context: context,
      builder: (context) => Obx(
        () => AlertDialog(
          contentPadding: EdgeInsets.all(20),
          actionsPadding:
              EdgeInsets.only(bottom: 20, right: 20, left: 20, top: 0),
          clipBehavior: Clip.hardEdge,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    defaultCategory != null ? "Edit Category" : "Add Category",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            size: 20,
                            color: colorScheme.onSurface,
                          )),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
          actions: [
            ButtonWidget(
              colorScheme: colorScheme,
              onPressed: () {
                if (defaultCategory != null) {
                  controller.editCategory(defaultCategory);
                } else {
                  controller.addCategory();
                }
              },
              child: Text(
                  defaultCategory != null ? "Edit Category" : "Add Category"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildColorPicker() {
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
  }

  Future<bool> showDeleteConfirmationDialog(
      BuildContext context, BoxConstraints constraints, dynamic item) {
    Type itemType = item.runtimeType;
    String itemName = itemType == Category ? item.categoryName : item.taskName;
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialogWidget(
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

      if (itemType == Category) {
        return controller.deleteCategory(item);
      }
      return controller.deleteTask(item);
    });
  }

  void showTaskDetailModal(BuildContext context, BoxConstraints constraints,
      ColorScheme colorScheme, Category listItem, Task task) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) => SizedBox(
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
                "${listItem.categoryName} : ${task.taskName}",
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
                  child: Column(
                    children: [
                      TextFieldWidget(
                        colorScheme: colorScheme,
                        hintText: "Task Description",
                        textController:
                            TextEditingController(text: task.taskDescription),
                        isTextHidden: false,
                        minLines: 3,
                        maxLines: 7,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: constraints.maxWidth,
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10))),
                        child: Text(
                          "SubTasks",
                          style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(task.dueDate?.toString() ?? "No due date"),
            // Text(task.taskDescription),
          ],
        ),
      ),
    );
  }
}
