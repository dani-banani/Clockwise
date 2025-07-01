import 'package:computing_project/api/category_api.dart';
import 'package:computing_project/widgets/action_dialog.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:computing_project/model/category.dart';

class CategorySelectionWidget extends StatefulWidget {
  final String label;
  final int? defaultCategoryId;
  final Function(int) onChanged;
  const CategorySelectionWidget(
      {super.key,
      required this.label,
      this.defaultCategoryId,
      required this.onChanged});

  @override
  State<CategorySelectionWidget> createState() =>
      _CategorySelectionWidgetState();
}

class _CategorySelectionWidgetState extends State<CategorySelectionWidget> {
  final ColorScheme colorScheme = Get.theme.colorScheme;
  List<Category> categoryList = [];
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
    CategoryApi.getUserCategories().then((response) {
      if (!response.success) {
        Get.back();
        return;
      }

      setState(() {
        categoryList = response.data;
        if (widget.defaultCategoryId != null) {
          selectedCategory = categoryList.firstWhereOrNull(
              (category) => category.categoryId == widget.defaultCategoryId);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPopoverSelection(context);
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
                selectedCategory?.categoryName ?? widget.label,
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

  void showPopoverSelection(BuildContext context) {
    Category? preSelectedCategory;
    if (selectedCategory != null) {
      preSelectedCategory = selectedCategory;
    }
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setDialogState) {
        return ActionDialogWidget(
          onActionPressed: () {
            setState(() {
              selectedCategory = preSelectedCategory;
            });

            if (preSelectedCategory == null) {
              widget.onChanged(0);
              return;
            }

            widget.onChanged(selectedCategory!.categoryId);
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
                        strokeAlign: BorderSide.strokeAlignCenter,
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
