import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../navigation/app_routes.dart';
import '../../api/authentication_api.dart';
import '../../widgets/error_snackbar_widget.dart';

enum UserRegistrationState { login, signUp, providingDetails }

class RegistrationController extends GetxController {
  Rx<UserRegistrationState> userRegistrationState =
      UserRegistrationState.login.obs;

  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController =
      TextEditingController().obs;
  Rx<TextEditingController> usernameController = TextEditingController().obs;

  RxString gender = "".obs;
  Rx<DateTime?> birthdate = Rx<DateTime?>(null);

  RxBool isBirthdateSelected = false.obs;

  void onSelectGender(String value) {
    if (value == gender.value) return;
    gender.value = value;
  }

  void onSwitchRegistrationMethod() {
    if (userRegistrationState.value == UserRegistrationState.signUp) {
      userRegistrationState.value = UserRegistrationState.login;
    } else {
      userRegistrationState.value = UserRegistrationState.signUp;
    }

    emailController.value.text = "";
    passwordController.value.text = "";
    confirmPasswordController.value.text = "";
  }

  void onLogin() async {
    List<String> errorMessages = [];

    errorMessages.addAll(checkEmailAndPasswordFields());

    if (errorMessages.isNotEmpty) {
      ErrorSnackbarWidget.showSnackbar(
        title: "Login Failed",
        messages: errorMessages,
      );
      return;
    }

    final response = await AuthenticationApi.signInUser(
        email: emailController.value.text,
        password: passwordController.value.text);

    if (!response.success) {
      ErrorSnackbarWidget.showSnackbar(
        title: "Login Failed",
        messages: response.message,
      );
      return;
    }

    Get.offAllNamed(AppRoutes.home);
  }

  void onSignUp() async {
    List<String> errorMessages = [];

    errorMessages.addAll(checkEmailAndPasswordFields());

    if (confirmPasswordController.value.text.isEmpty) {
      errorMessages.add("Confirm password field is empty");
    }

    if (confirmPasswordController.value.text != passwordController.value.text) {
      errorMessages.add("Password fields do not match");
    }

    if (errorMessages.isNotEmpty) {
      ErrorSnackbarWidget.showSnackbar(
        title: "Sign Up Failed",
        messages: errorMessages,
      );
      return;
    }

    final response = await AuthenticationApi.signUpUser(
        email: emailController.value.text,
        password: passwordController.value.text);

    if (!response.success) {
      ErrorSnackbarWidget.showSnackbar(
          title: "Sign Up Failed", messages: response.message);
      return;
    }

    userRegistrationState.value = UserRegistrationState.providingDetails;
  }

  void onSubmitDetails() async {
    List<String> errorMessages = [];

    if (usernameController.value.text.isEmpty) {
      errorMessages.add("Username field is empty");
    }

    if (gender.value.isEmpty) {
      errorMessages.add("Gender field is empty");
    }

    if (birthdate.value != null) {
      if (birthdate.value!.isAfter(DateTime.now())) {
        errorMessages.add("Birhtdate selected is invalid");
      }
    } else {
      errorMessages.add("Birthdate field is empty");
    }

    if (errorMessages.isNotEmpty) {
      ErrorSnackbarWidget.showSnackbar(
          title: "Sign Up Failed", messages: errorMessages);
      return;
    }

    final response = await AuthenticationApi.updateUserProfile(
      username: usernameController.value.text,
      gender: gender.value,
      birthdate: birthdate.value!,
    );

    if (!response.success) {
      ErrorSnackbarWidget.showSnackbar(
          title: "Sign Up Failed", messages: response.message);
      return;
    }

    Get.offAllNamed(AppRoutes.home);
  }

  List<String> checkEmailAndPasswordFields() {
    List<String> errorMessages = [];

    if (emailController.value.text.isEmpty) {
      errorMessages.add("Email field is empty");
    }

    if (passwordController.value.text.isEmpty) {
      errorMessages.add("Password field is empty");
    }

    return errorMessages;
  }

  // void showErrorToast(
  //     {required String title, required List<String> errorMessages}) {
  //   Get.snackbar("", "",
  //       animationDuration: const Duration(milliseconds: 500),
  //       duration: const Duration(milliseconds: 1500),
  //       isDismissible: true,
  //       snackPosition: SnackPosition.TOP,
  //         backgroundColor: colorScheme.primaryContainer,
  //       titleText: Center(
  //           child: Text(title,
  //               style: const TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color.fromARGB(255, 118, 0, 0)))),
  //       messageText: Center(
  //           child: Text(errorMessages.join('\n'),
  //               textAlign: TextAlign.center,
  //               style: const TextStyle(color: Colors.black))),
  //       overlayBlur: 0.5);
  // }

  void onDateSelected(DateTime? date) {
    if (date == birthdate.value) return;

    birthdate.value = date;
  }
}
