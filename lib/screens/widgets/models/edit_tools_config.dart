import 'package:flutter/material.dart';

/// 编辑工具配置模型
/// 
/// 用于封装编辑工具栏中各个工具项的配置信息
class ToolConfig {
  /// 工具唯一标识符
  final String id;
  
  /// 工具显示名称
  final String label;
  
  /// 工具图标
  final IconData icon;

  const ToolConfig({
    required this.id,
    required this.label,
    required this.icon,
  });
}

/// 画布控制按钮配置模型
/// 
/// 用于封装画布操作按钮的配置信息
class CanvasButtonConfig {
  /// 按钮显示名称
  final String label;
  
  /// 按钮图标
  final IconData icon;
  
  /// 点击回调函数
  final VoidCallback onTap;

  const CanvasButtonConfig({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

/// 滤镜配置模型
/// 
/// 用于封装滤镜相关的配置信息
class FilterConfig {
  /// 滤镜列表
  final List<String> filters;
  
  /// 滤镜名称映射（英文 -> 中文）
  final Map<String, String> filterNames;
  
  /// 当前选中的滤镜
  final String currentFilter;
  
  /// 滤镜强度
  final double filterStrength;

  const FilterConfig({
    required this.filters,
    required this.filterNames,
    required this.currentFilter,
    required this.filterStrength,
  });

  /// 创建副本
  FilterConfig copyWith({
    List<String>? filters,
    Map<String, String>? filterNames,
    String? currentFilter,
    double? filterStrength,
  }) {
    return FilterConfig(
      filters: filters ?? this.filters,
      filterNames: filterNames ?? this.filterNames,
      currentFilter: currentFilter ?? this.currentFilter,
      filterStrength: filterStrength ?? this.filterStrength,
    );
  }
}

/// 文字配置模型
/// 
/// 用于封装文字相关的配置信息
class TextConfig {
  /// 主字体
  final String textFont;
  
  /// 副字体
  final String textFont2;
  
  /// 主文字位置
  final String textPosition;
  
  /// 副文字位置
  final String textPosition2;
  
  /// 主文字大小
  final double textSize;
  
  /// 副文字大小
  final double textSize2;
  
  /// 日期文字
  final String dateText;
  
  /// 副日期文字
  final String dateText2;
  
  /// 句子文字
  final String sentenceText;
  
  /// 副句子文字
  final String sentenceText2;
  
  /// 主文字颜色
  final Color textColor;
  
  /// 副文字颜色
  final Color textColor2;

  const TextConfig({
    this.textFont = 'default',
    this.textFont2 = 'default',
    this.textPosition = 'center',
    this.textPosition2 = 'center',
    this.textSize = 16.0,
    this.textSize2 = 16.0,
    this.dateText = '',
    this.dateText2 = '',
    this.sentenceText = '',
    this.sentenceText2 = '',
    this.textColor = Colors.black,
    this.textColor2 = Colors.black,
  });

  /// 创建副本
  TextConfig copyWith({
    String? textFont,
    String? textFont2,
    String? textPosition,
    String? textPosition2,
    double? textSize,
    double? textSize2,
    String? dateText,
    String? dateText2,
    String? sentenceText,
    String? sentenceText2,
    Color? textColor,
    Color? textColor2,
  }) {
    return TextConfig(
      textFont: textFont ?? this.textFont,
      textFont2: textFont2 ?? this.textFont2,
      textPosition: textPosition ?? this.textPosition,
      textPosition2: textPosition2 ?? this.textPosition2,
      textSize: textSize ?? this.textSize,
      textSize2: textSize2 ?? this.textSize2,
      dateText: dateText ?? this.dateText,
      dateText2: dateText2 ?? this.dateText2,
      sentenceText: sentenceText ?? this.sentenceText,
      sentenceText2: sentenceText2 ?? this.sentenceText2,
      textColor: textColor ?? this.textColor,
      textColor2: textColor2 ?? this.textColor2,
    );
  }
}

/// 边距配置模型
/// 
/// 用于封装边距相关的配置信息
class MarginConfig {
  /// 左边距
  final double left;
  
  /// 右边距
  final double right;
  
  /// 上边距
  final double top;
  
  /// 下边距
  final double bottom;

  const MarginConfig({
    this.left = 0.0,
    this.right = 0.0,
    this.top = 0.0,
    this.bottom = 0.0,
  });

  /// 创建副本
  MarginConfig copyWith({
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return MarginConfig(
      left: left ?? this.left,
      right: right ?? this.right,
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
    );
  }
}

/// 编辑工具栏回调接口
/// 
/// 定义了编辑工具栏中所有可能的回调方法
abstract class EditToolsCallbacks {
  // 工具切换回调
  void onToolChanged(String tool);
  
  // 滤镜相关回调
  void onFilterSelected(String filter);
  void onFilterStrengthChanged(double strength);
  
  // 调整参数相关回调
  void onAdjustmentSelected(String adjustment);
  void onAdjustmentChanged(double value);
  
  // 画布操作回调
  void onReset();
  void onCrop();
  void onFlipHorizontal();
  void onFlipVertical();
  void onZoomIn();
  void onZoomOut();
  void onCenterHorizontal();
  void onRatio34();
  void onRatio43();
  
  // 背景颜色回调
  void onBackgroundColorChanged(Color color);
  
  // 文字相关回调
  void onTextFontChanged(String font);
  void onTextFont2Changed(String font);
  void onTextPositionChanged(String position);
  void onTextPosition2Changed(String position);
  void onTextSizeChanged(double size);
  void onTextSize2Changed(double size);
  void onDateTextChanged(String text);
  void onDateText2Changed(String text);
  void onSentenceTextChanged(String text);
  void onSentenceText2Changed(String text);
  void onTextColorChanged(Color color);
  void onTextColor2Changed(Color color);
  
  // 边距相关回调
  void onMarginLeftChanged(double value);
  void onMarginRightChanged(double value);
  void onMarginTopChanged(double value);
  void onMarginBottomChanged(double value);
  void onResetMargin();
}
