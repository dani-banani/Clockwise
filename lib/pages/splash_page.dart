import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../api/authentication_api.dart';
import '../navigation/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> authenticateUser() async {
    final userAuthResponse = await AuthenticationApi.authenticateUser();
    if (!userAuthResponse.success) {
      Get.offAllNamed(AppRoutes.registration);
      return;
    }

    Get.offAllNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) async{
      await Future.delayed(const Duration(seconds: 2));
      await authenticateUser();
    });

    return const Center(
      child: Text("I am a splash page"),
    );
  }
}
