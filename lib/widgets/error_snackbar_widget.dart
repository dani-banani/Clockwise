import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorSnackbarWidget {
  static void showSnackbar({required String title, required List<String> messages}) {
    final colorScheme = Get.theme.colorScheme;
      Get.snackbar(
        "",
        "",
        borderRadius: 20,
        boxShadows: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(100),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(1, 1),
          ),
        ],
        animationDuration: const Duration(milliseconds: 500),
        duration: const Duration(milliseconds: 1500),
        isDismissible: true,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primaryContainer,
        titleText: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.error,
            ),
          ),
        ),
        messageText: Center(
          child: Text(
            messages.join('\n'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      );
  }
}
