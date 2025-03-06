import 'package:hive/hive.dart';
import 'package:taskati/core/models/task_model.dart';

class AppLocalStorage {
  static Box? userBox;
  static Box? taskBox;
  static String kName = "name";
  static String kImage = "image";
  static String isUploaded = "isUploaded";
  static String isDarkTheme = "isDarkTheme";

  static init() {
    userBox = Hive.box("userBox");
    taskBox = Hive.box<TaskModel>("taskBox");
  }

  static cacheData(String key, dynamic value) async {
    await userBox?.put(key, value);
  }
  

  static getCachedData(String key) {
    return userBox?.get(key);
  }

  static cacheTask(String key, TaskModel value) async {
    await taskBox?.put(key, value);
  }
  
  static TaskModel getTaskCached(String key) {
    return taskBox?.get(key);
  }
}