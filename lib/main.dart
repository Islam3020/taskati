import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskati/core/models/task_model.dart';
import 'package:taskati/core/services/local_helper.dart';
import 'package:taskati/core/services/notification.dart';
import 'package:taskati/core/utils/themes.dart';

import 'package:taskati/features/splash/splash_view.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("userBox");
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>("taskBox");

  AppLocalStorage.init();
  await NotificationService.init();
  await NotificationService.scheduleDailyTaskNotification();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppLocalStorage.userBox!.listenable(),
      builder: (context, box, child) {
        bool isDarkTheme =
            AppLocalStorage.getCachedData(AppLocalStorage.isDarkTheme) ?? false;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          theme: AppThemes.lightTheme,
          darkTheme:AppThemes.darkTheme,
          home: const SplashView(),
        );
      },
    );
  }
}
