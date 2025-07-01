import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'navigation/app_routes.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://sfdvrbbsjbmbkjbnmbes.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNmZHZyYmJzamJtYmtqYm5tYmVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU4OTM2NzEsImV4cCI6MjA2MTQ2OTY3MX0.KGD6Dt2kWrtwTvjhgY65rcRMYuG7GrCEWeq0z1iZvNs',
  );

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final supabase = Supabase.instance.client;

  final List<String> noFooterRoutes = [
    AppRoutes.registration,
    AppRoutes.splash,
    AppRoutes.studyMethod,
    AppRoutes.taskList,
    AppRoutes.home
  ];

  @override
  Widget build(BuildContext context) {
    String currentRoute = Get.currentRoute;

    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xff3D2914),
          onPrimary: Color(0xffFFFFFF),
          surface: Color(0xffE8E8E8),
          onSurface: Color(0xff2C2C2C),
          primaryContainer: Color(0xffF5F5F5),
          onPrimaryContainer: Color(0xff3D2914),
          secondary: Color(0xff8B7355),
          onSecondary: Color(0xffFFFFFF),
          error: Color(0xffB3261E),
          onError: Color(0xffFFFFFF),
          primaryFixedDim: Color(0xffE1E1E1),
        ),
        fontFamily: "Arial",
        // textTheme: const TextTheme(

        //   bodyLarge: const TextStyle(fontSize: 36),
        //   bodyMedium: const TextStyle(fontSize: 14),
        //   bodySmall: const TextStyle(fontSize: 12),
        // ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
      navigatorKey: Get.key,
      navigatorObservers: [
        GetObserver((routing) => {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  currentRoute = Get.currentRoute;
                });
              })
            })
      ],
      builder: (context, child) {
        return Scaffold(
          body: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
