import 'package:computing_project/widgets/dropdown_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:computing_project/widgets/text_field_widget.dart';
import 'package:computing_project/widgets/datetime_picker_widget.dart';
import 'package:computing_project/widgets/button_widget.dart';

import './registration_controller.dart';

class RegistrationPage extends GetView<RegistrationController> {
  final ColorScheme colorScheme;
  const RegistrationPage({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    String userRegistrationStateLabel;
    List<Widget> activeForm;

    return Obx(() {
      switch (controller.userRegistrationState.value) {
        case UserRegistrationState.login:
          userRegistrationStateLabel = "Login";
          activeForm = buildLoginForm(controller);
          break;
        case UserRegistrationState.signUp:
          userRegistrationStateLabel = "Sign Up";
          activeForm = buildSignUpForm(controller);
          break;
        case UserRegistrationState.providingDetails:
          userRegistrationStateLabel = "Tell us about yourself";
          activeForm = buildProvideDetailsForm(controller, context);
          break;
      }

      return LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(color: Colors.white),
                ),
                Expanded(child: Container(color: colorScheme.surface))
              ],
            ),
            CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                slivers: [
                  SliverAppBar(
                    elevation: 0,
                    backgroundColor: colorScheme.surface,
                    stretch: true,
                    toolbarHeight: constraints.maxHeight * 0.2,
                    // pinned: true,
                    // floating: true,
                    // expandedHeight: constraints.maxHeight * 0.2,
                    flexibleSpace: const Center(
                        child: Text(
                      "Clockwise App",
                      style: TextStyle(color: Colors.black),
                    )),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          child: Container(
                              height: 50,
                              color: colorScheme.primary,
                              child: Center(
                                  child: Text(
                                userRegistrationStateLabel,
                                style: TextStyle(
                                    color: colorScheme.onPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ))),
                        ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: colorScheme.surface,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: activeForm,
                          ),
                        ))
                      ],
                    ),
                  )
                ]),
          ],
        );
      });
    });
  }

  List<Widget> buildFormFooterTexts(RegistrationController controller,
      {required String questionText,
      required String actionText,
      String additionalText = ""}) {
    return [
      RichText(
          text: TextSpan(
              style: TextStyle(color: colorScheme.onSurface),
              children: [
            TextSpan(text: questionText),
            TextSpan(
                text: actionText,
                style: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    controller.onSwitchRegistrationMethod();
                  })
          ])),
      if (additionalText.isNotEmpty) ...[
        const SizedBox(
          height: 10,
        ),
        RichText(
            text: TextSpan(
                text: additionalText,
                style: const TextStyle(
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    debugPrint("Bro forgot password");
                  }))
      ]
    ];
  }

  List<Widget> buildLoginForm(RegistrationController controller) {
    return [
      TextFieldWidget(
          colorScheme: colorScheme,
          hintText: "Email",
          textController: controller.emailController.value,
          isTextHidden: false),
      const SizedBox(height: 20),
      TextFieldWidget(
          colorScheme: colorScheme,
          hintText: "Password",
          textController: controller.passwordController.value,
          isTextHidden: true),
      const SizedBox(height: 40),
      ButtonWidget(
          colorScheme: colorScheme,
          child: Text("Login"),
          onPressed: controller.onLogin,
          width: Get.width * 0.4,
          height: 50),
      const SizedBox(height: 20),
      ...buildFormFooterTexts(controller,
          questionText: "Don't have an account? ",
          actionText: "Sign Up",
          additionalText: "Forgot your password?")
    ];
  }

  List<Widget> buildSignUpForm(RegistrationController controller) {
    return [
      TextFieldWidget(
          colorScheme: colorScheme,
          hintText: "Email",
          textController: controller.emailController.value,
          isTextHidden: false),
      const SizedBox(height: 20),
      TextFieldWidget(
          colorScheme: colorScheme,
          hintText: "Password",
          textController: controller.passwordController.value,
          isTextHidden: true),
      const SizedBox(height: 20),
      TextFieldWidget(
          colorScheme: colorScheme,
          hintText: "Confirm Password",
          textController: controller.confirmPasswordController.value,
          isTextHidden: true),
      const SizedBox(height: 40),
      ButtonWidget(
          colorScheme: colorScheme,
          child: Text("Sign Up"),
          onPressed: controller.onSignUp,
          width: Get.width * 0.4,
          height: 50),
      const SizedBox(height: 20),
      ...buildFormFooterTexts(
        controller,
        questionText: "Already have an account? ",
        actionText: "Login",
      )
    ];
  }

  List<Widget> buildProvideDetailsForm(
      RegistrationController controller, BuildContext context) {
    List<String> genderDropdownValues = ["Male", "Female"];

    return [
      TextFieldWidget(
        colorScheme: colorScheme,
        hintText: "Username",
        textController: controller.usernameController.value,
        isTextHidden: false,
      ),
      const SizedBox(height: 20),
      DropdownWidget(
          colorScheme: colorScheme,
          hintText: "Select Gender",
          value: controller.gender.value,
          dropdownItems: genderDropdownValues,
          onChanged: controller.onSelectGender),
      const SizedBox(height: 20),
      DateTimePickerWidget(
          onDateOrTimeSelected: (date) {
            controller.onDateSelected(date);
          },
          maxDate: DateTime.now(),
          minDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
          helpText: "Select Birthdate"),
      const SizedBox(height: 40),
      ButtonWidget(
          colorScheme: colorScheme,
          child: Text("Submit"),
          onPressed: controller.onSubmitDetails,
          width: Get.width * 0.4,
          height: 50)
    ];
  }
}
