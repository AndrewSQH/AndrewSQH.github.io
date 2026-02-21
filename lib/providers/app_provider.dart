import 'package:flutter/material.dart';
import '../models/template.dart';
import '../templates/template_data.dart';
import '../utils/storage_manager.dart';

enum FontSize { small, medium, large }

/// 应用状态管理类
/// 
/// 负责管理应用的全局状态，包括模板、选中的图片路径和加载状态
class AppProvider extends ChangeNotifier {
  /// 模板列表
  final List<Template> _templates;
  
  /// 当前选中的模板
  late Template _currentTemplate;
  
  /// 选中的图片路径
  String? _selectedImagePath;
  
  /// 是否正在加载
  bool _isLoading = false;
  
  /// 文字大小
  FontSize _fontSize = FontSize.medium;

  /// 构造函数
  AppProvider() : _templates = TemplateData.getTemplates() {
    // 初始化存储管理器
    _initializeStorage();
    
    // 安全地设置当前模板
    if (_templates.isNotEmpty) {
      _currentTemplate = _templates[0];
    } else {
      _currentTemplate = Template(
        id: 'default',
        name: '默认模板',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 0.0,
        borderRadius: 0.0,
        filterName: 'original',
        imagePath: '',
      );
    }
  }

  /// 初始化存储管理器
  Future<void> _initializeStorage() async {
    await StorageManager.initialize();
  }

  /// 获取模板列表
  List<Template> get templates => _templates;
  
  /// 获取当前选中的模板
  Template get currentTemplate => _currentTemplate;
  
  /// 获取选中的图片路径
  String? get selectedImagePath => _selectedImagePath;
  
  /// 获取是否正在加载
  bool get isLoading => _isLoading;
  
  /// 获取文字大小
  FontSize get fontSize => _fontSize;
  
  /// 获取文字大小数值
  double get fontSizeValue {
    switch (_fontSize) {
      case FontSize.small:
        return 14.0;
      case FontSize.medium:
        return 16.0;
      case FontSize.large:
        return 18.0;
    }
  }

  /// 设置当前选中的模板
  /// 
  /// [template] - 要设置的模板
  void setCurrentTemplate(Template template) {
    _currentTemplate = template;
    notifyListeners();
  }
  
  /// 设置文字大小
  /// 
  /// [size] - 要设置的文字大小
  void setFontSize(FontSize size) {
    _fontSize = size;
    notifyListeners();
  }

  /// 设置选中的图片路径
  /// 
  /// [path] - 要设置的图片路径
  void setSelectedImagePath(String? path) {
    _selectedImagePath = path;
    notifyListeners();
  }

  /// 设置加载状态
  /// 
  /// [loading] - 加载状态
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    // 清理资源
    StorageManager.close();
    super.dispose();
  }
}

