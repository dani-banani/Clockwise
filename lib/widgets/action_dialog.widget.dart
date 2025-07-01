import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:computing_project/widgets/button_widget.dart';

class ActionDialogWidget extends StatelessWidget {
  final String title;
  final Widget body;
  final String actionText;
  final double gap;
  final Function() onActionPressed;
  const ActionDialogWidget(
      {super.key,
      required this.title,
      required this.body,
      required this.actionText,
      required this.onActionPressed,
      this.gap = 20});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Get.theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(20),
      actionsPadding:
          const EdgeInsets.only(bottom: 20, right: 20, left: 20, top: 0),
      clipBehavior: Clip.hardEdge,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                title,
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
          SizedBox(height: gap),
          body,
          SizedBox(height: gap),
        ],
      ),
      actions: [
        ButtonWidget(
          colorScheme: colorScheme,
          onPressed: () {
            onActionPressed();
            Get.back();
          },
          child: Text(actionText),
        ),
      ],
    );
  }
}
