import 'dart:convert';
import '../utils/storage_manager.dart';

class AppConstants {
  static const String contactEmail = 'support@example.com';
}

class AppConfig {
  String selectedFont = 'Roboto';
  bool autoSave = true;
  bool showTips = true;
  String language = 'zh';

  AppConfig({
    this.selectedFont = 'Roboto',
    this.autoSave = true,
    this.showTips = true,
    this.language = 'zh',
  });

  Map<String, dynamic> toMap() {
    return {
      'selectedFont': selectedFont,
      'autoSave': autoSave,
      'showTips': showTips,
      'language': language,
    };
  }

  factory AppConfig.fromMap(Map<String, dynamic> map) {
    return AppConfig(
      selectedFont: map['selectedFont'] ?? 'Roboto',
      autoSave: map['autoSave'] ?? true,
      showTips: map['showTips'] ?? true,
      language: map['language'] ?? 'zh',
    );
  }
}

class ConfigManager {
  static const String _configKey = 'app_config';

  // 初始化配置
  static Future<void> initialize() async {
    await StorageManager.initialize();
    // 如果配置不存在，创建默认配置
    final config = await getConfig();
    if (config == null) {
      await saveConfig(AppConfig());
    }
  }

  // 获取配置
  static Future<AppConfig?> getConfig() async {
    try {
      final String? configJson = await StorageManager.getString(_configKey);
      if (configJson == null) return null;
      
      final Map<String, dynamic> configMap = jsonDecode(configJson);
      return AppConfig.fromMap(configMap);
    } catch (e) {
      print('获取配置失败: $e');
      return null;
    }
  }

  // 保存配置
  static Future<bool> saveConfig(AppConfig config) async {
    try {
      final String configJson = jsonEncode(config.toMap());
      await StorageManager.setString(_configKey, configJson);
      return true;
    } catch (e) {
      print('保存配置失败: $e');
      return false;
    }
  }

  // 更新字体设置
  static Future<bool> updateFont(String font) async {
    try {
      final config = await getConfig() ?? AppConfig();
      config.selectedFont = font;
      return await saveConfig(config);
    } catch (e) {
      print('更新字体设置失败: $e');
      return false;
    }
  }

  // 更新自动保存设置
  static Future<bool> updateAutoSave(bool autoSave) async {
    try {
      final config = await getConfig() ?? AppConfig();
      config.autoSave = autoSave;
      return await saveConfig(config);
    } catch (e) {
      print('更新自动保存设置失败: $e');
      return false;
    }
  }

  // 更新显示提示设置
  static Future<bool> updateShowTips(bool showTips) async {
    try {
      final config = await getConfig() ?? AppConfig();
      config.showTips = showTips;
      return await saveConfig(config);
    } catch (e) {
      print('更新显示提示设置失败: $e');
      return false;
    }
  }

  // 更新语言设置
  static Future<bool> updateLanguage(String language) async {
    try {
      final config = await getConfig() ?? AppConfig();
      config.language = language;
      return await saveConfig(config);
    } catch (e) {
      print('更新语言设置失败: $e');
      return false;
    }
  }
}
