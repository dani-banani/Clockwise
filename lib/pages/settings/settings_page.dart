import 'package:computing_project/widgets/app_bar_widget.dart';
import 'package:computing_project/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import 'package:computing_project/pages/settings/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBarWidget(
            title: "Settings", colorScheme: Theme.of(context).colorScheme),
        body: SingleChildScrollView(
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    controller.onLogout();
                  },
                  child: Text("Logout")),
              ElevatedButton(
                  onPressed: () {
                    controller.number.value++;
                  },
                  child: Text("Increment")),
              Text(controller.number.toString()),
              TextFieldWidget(
                hintText: "Enter a number",
                textController: controller.numberController.value,
                isTextHidden: false,
                colorScheme: Theme.of(context).colorScheme,
              )
            ],
          ),
        ),
      );
    });
  }
}
