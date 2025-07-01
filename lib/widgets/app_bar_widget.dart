import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ColorScheme colorScheme;

  const AppBarWidget(
      {super.key, required this.title, required this.colorScheme});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.arrow_back,
          color: colorScheme.onPrimary,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onPrimary),
      ),
      backgroundColor: colorScheme.primary,
    );
  }
}
