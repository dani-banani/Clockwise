import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/authentication_api.dart';
import '../../navigation/app_routes.dart';
import '../../widgets/error_snackbar_widget.dart';

class SettingsController extends GetxController {
  Rx<int> number = 0.obs;
  Rx<TextEditingController> numberController = TextEditingController().obs;

  void onLogout() {
    AuthenticationApi.signOutUser().then((response) {
      if (!response.success) {
        ErrorSnackbarWidget.showSnackbar(
          title: "Logout Failed",
          messages: response.message,
        );
        return;
      }

      debugPrint("Logout successful");
      Get.offAllNamed(AppRoutes.registration);
    });
  }
}
