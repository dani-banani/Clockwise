import 'package:computing_project/model/api_response.dart';
import 'package:get/get.dart';

import '../navigation/app_routes.dart';
import '../widgets/error_snackbar_widget.dart';

class ApiResponseHandler {
  static bool handleProtectedApiResponse(ApiResponse response, {String errorTitle = "Error"}) {
    if (response.statusCode == 401) {
      Get.offAllNamed(AppRoutes.registration);
      ErrorSnackbarWidget.showSnackbar(
          title: "Unauthenticated", messages: ["Your login session has expired, please login again"]);
      return false;
    }

    if (!response.success) {
      ErrorSnackbarWidget.showSnackbar(
          title: errorTitle, messages: response.message);
      return false;
    }

    return true;
  }

  static bool handleUnprotectedApiResponse(ApiResponse response, {String errorTitle = "Error"}) {
    if (!response.success) {
      ErrorSnackbarWidget.showSnackbar(
          title: errorTitle, messages: response.message);
      return false;
    }

    return true;
  }
}
