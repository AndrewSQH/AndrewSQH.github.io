import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class MonitoringManager {
  // 初始化 Firebase Crashlytics
  static Future<void> initialize() async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        print('Web平台不支持Firebase Crashlytics');
        return;
      }

      // 初始化 Firebase
      await Firebase.initializeApp();

      // 启用 Crashlytics
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

      // 设置未捕获异常处理
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

      print('Firebase Crashlytics 初始化成功');
    } catch (e) {
      print('Firebase Crashlytics 初始化失败: $e');
    }
  }

  // 报告错误
  static Future<void> reportError(dynamic error, StackTrace? stackTrace) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        print('Web平台不支持Firebase Crashlytics: $error');
        return;
      }

      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        fatal: false,
      );
    } catch (e) {
      print('报告错误失败: $e');
    }
  }

  // 报告致命错误
  static Future<void> reportFatalError(dynamic error, StackTrace? stackTrace) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        print('Web平台不支持Firebase Crashlytics: $error');
        return;
      }

      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        fatal: true,
      );
    } catch (e) {
      print('报告致命错误失败: $e');
    }
  }

  // 记录自定义日志
  static Future<void> log(String message) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        print('Log: $message');
        return;
      }

      await FirebaseCrashlytics.instance.log(message);
    } catch (e) {
      print('记录日志失败: $e');
    }
  }

  // 设置用户标识符
  static Future<void> setUserId(String userId) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        print('设置用户ID: $userId');
        return;
      }

      await FirebaseCrashlytics.instance.setUserIdentifier(userId);
    } catch (e) {
      print('设置用户ID失败: $e');
    }
  }

  // 设置自定义键值对
  static Future<void> setCustomKey(String key, dynamic value) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        print('设置自定义键值: $key = $value');
        return;
      }

      await FirebaseCrashlytics.instance.setCustomKey(key, value);
    } catch (e) {
      print('设置自定义键值失败: $e');
    }
  }
}
