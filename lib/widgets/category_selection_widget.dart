import 'package:computing_project/pages/task_list/task_list_controller.dart';
import 'package:computing_project/widgets/action_dialog.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:computing_project/model/category.dart';

class CategorySelectionWidget extends StatelessWidget {
  final String label;
  final Category? selectedCategory;
  final Function(Category?) onChanged;
  const CategorySelectionWidget(
      {super.key,
      required this.label,
      this.selectedCategory,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Get.theme.colorScheme;
    TaskListController taskListController = Get.find();
    final categoryList =
        taskListController.taskAccordions.map((item) => item.category).toList();

    return GestureDetector(
      onTap: () {
        showPopoverSelection(context, colorScheme, categoryList);
      },
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 50,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selectedCategory != null
              ? selectedCategory!
                  .getCategoryColor(defaultColor: colorScheme.primaryContainer)
              : colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                selectedCategory?.categoryName ?? label,
                softWrap: true,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: colorScheme.onPrimaryContainer,
            ),
          ],
        ),
      ),
    );
  }

  void showPopoverSelection(BuildContext context, ColorScheme colorScheme,
      List<Category> categoryList) {
    Category? preSelectedCategory;
    if (selectedCategory != null) {
      preSelectedCategory = selectedCategory;
    }
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setDialogState) {
        return ActionDialogWidget(
          onActionPressed: () {
            if (preSelectedCategory == null) {
              onChanged(null);
              Get.back();
              return;
            }

            onChanged(preSelectedCategory);
            Get.back();
          },
          title: "Select Category",
          body: Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            height: 200,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics()
                  .applyTo(const BouncingScrollPhysics()),
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                final currentCategory = categoryList[index];
                return GestureDetector(
                  onTap: () {
                    if (preSelectedCategory?.categoryId ==
                        currentCategory.categoryId) {
                      setDialogState(() {
                        preSelectedCategory = null;
                      });
                      return;
                    }

                    setDialogState(() {
                      preSelectedCategory = currentCategory;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: currentCategory.getCategoryColor(
                          defaultColor: colorScheme.primaryContainer),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: preSelectedCategory?.categoryId ==
                                currentCategory.categoryId
                            ? colorScheme.primary
                            : Colors.transparent,
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    child: Text(currentCategory.categoryName),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
            ),
          ),
          actionText: "Select Category",
        );
      }),
    );
  }
}
