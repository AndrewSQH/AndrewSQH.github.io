import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'canvas_controls.dart';
import 'filter_selector.dart';
import 'parameter_adjustments.dart';
import 'text_controls.dart';
import 'color_controls.dart';
import 'margin_controls.dart';
import 'models/edit_tools_config.dart';

/// 编辑工具栏组件
/// 
/// 提供图像编辑的主要工具入口，包括：
/// - 图像操作：重置、缩放、裁剪、翻转、比例调整
/// - 滤镜：滤镜选择和强度调整
/// - 调整：参数调整（亮度、对比度等）
/// - 文字：文字样式和内容编辑
/// - 颜色：背景颜色选择
/// - 留白：边距调整
/// 
/// 该组件采用模块化设计，每个工具面板作为独立子组件
class EditTools extends StatefulWidget {
  // ==================== 基础配置 ====================
  
  /// 当前选中的工具
  final String currentTool;
  
  /// 工具切换回调
  final ValueChanged<String> onToolChanged;

  // ==================== 滤镜配置 ====================
  
  /// 滤镜列表
  final List<String> filters;
  
  /// 滤镜名称映射（英文 -> 中文）
  final Map<String, String> filterNames;
  
  /// 当前选中的滤镜
  final String currentFilter;
  
  /// 滤镜强度
  final double filterStrength;
  
  /// 滤镜选择回调
  final ValueChanged<String> onFilterSelected;
  
  /// 滤镜强度变化回调
  final ValueChanged<double> onFilterStrengthChanged;

  // ==================== 调整参数配置 ====================
  
  /// 调整参数列表
  final List<Map<String, dynamic>> adjustments;
  
  /// 当前选中的调整参数
  final String? selectedAdjustment;
  
  /// 调整参数选择回调
  final ValueChanged<String> onAdjustmentSelected;
  
  /// 调整参数值变化回调
  final ValueChanged<double> onAdjustmentChanged;

  // ==================== 画布操作回调 ====================
  
  /// 重置回调
  final VoidCallback onReset;
  
  /// 裁剪回调
  final VoidCallback onCrop;
  
  /// 水平翻转回调
  final VoidCallback onFlipHorizontal;
  
  /// 垂直翻转回调
  final VoidCallback onFlipVertical;
  
  /// 放大回调
  final VoidCallback onZoomIn;
  
  /// 缩小回调
  final VoidCallback onZoomOut;
  
  /// 水平居中回调
  final VoidCallback onCenterHorizontal;
  
  /// 3:4比例回调
  final VoidCallback onRatio34;
  
  /// 4:3比例回调
  final VoidCallback onRatio43;

  // ==================== 颜色配置 ====================
  
  /// 当前背景颜色
  final Color currentBackgroundColor;
  
  /// 背景颜色变化回调
  final ValueChanged<Color> onBackgroundColorChanged;

  // ==================== 文字配置 ====================
  
  /// 主字体
  final String textFont;
  
  /// 主字体变化回调
  final ValueChanged<String> onTextFontChanged;
  
  /// 副字体
  final String textFont2;
  
  /// 副字体变化回调
  final ValueChanged<String> onTextFont2Changed;
  
  /// 字体列表
  final List<String> fonts;
  
  /// 字体名称映射
  final Map<String, String> fontNames;
  
  /// 主文字位置
  final String textPosition;
  
  /// 主文字位置变化回调
  final ValueChanged<String> onTextPositionChanged;
  
  /// 副文字位置
  final String textPosition2;
  
  /// 副文字位置变化回调
  final ValueChanged<String> onTextPosition2Changed;
  
  /// 主文字大小
  final double textSize;
  
  /// 主文字大小变化回调
  final ValueChanged<double> onTextSizeChanged;
  
  /// 副文字大小
  final double textSize2;
  
  /// 副文字大小变化回调
  final ValueChanged<double> onTextSize2Changed;
  
  /// 日期文字
  final String dateText;
  
  /// 日期文字变化回调
  final ValueChanged<String> onDateTextChanged;
  
  /// 副日期文字
  final String dateText2;
  
  /// 副日期文字变化回调
  final ValueChanged<String> onDateText2Changed;
  
  /// 句子文字
  final String sentenceText;
  
  /// 句子文字变化回调
  final ValueChanged<String> onSentenceTextChanged;
  
  /// 副句子文字
  final String sentenceText2;
  
  /// 副句子文字变化回调
  final ValueChanged<String> onSentenceText2Changed;
  
  /// 主文字颜色
  final Color textColor;
  
  /// 主文字颜色变化回调
  final ValueChanged<Color> onTextColorChanged;
  
  /// 副文字颜色
  final Color textColor2;
  
  /// 副文字颜色变化回调
  final ValueChanged<Color> onTextColor2Changed;
  
  /// 主文字方向
  final String textDirection;
  
  /// 主文字方向变化回调
  final ValueChanged<String> onTextDirectionChanged;
  
  /// 副文字方向
  final String textDirection2;
  
  /// 副文字方向变化回调
  final ValueChanged<String> onTextDirection2Changed;

  // ==================== 边距配置 ====================
  
  /// 左边距
  final double marginLeft;
  
  /// 左边距变化回调
  final ValueChanged<double> onMarginLeftChanged;
  
  /// 右边距
  final double marginRight;
  
  /// 右边距变化回调
  final ValueChanged<double> onMarginRightChanged;
  
  /// 上边距
  final double marginTop;
  
  /// 上边距变化回调
  final ValueChanged<double> onMarginTopChanged;
  
  /// 下边距
  final double marginBottom;
  
  /// 下边距变化回调
  final ValueChanged<double> onMarginBottomChanged;
  
  /// 重置边距回调
  final VoidCallback onResetMargin;

  const EditTools({
    super.key,
    required this.currentTool,
    required this.onToolChanged,
    required this.filters,
    required this.filterNames,
    required this.currentFilter,
    required this.filterStrength,
    required this.onFilterSelected,
    required this.onFilterStrengthChanged,
    required this.adjustments,
    required this.selectedAdjustment,
    required this.onAdjustmentSelected,
    required this.onAdjustmentChanged,
    required this.onReset,
    required this.onCrop,
    required this.onFlipHorizontal,
    required this.onFlipVertical,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onCenterHorizontal,
    required this.onRatio34,
    required this.onRatio43,
    required this.currentBackgroundColor,
    required this.onBackgroundColorChanged,
    this.textFont = 'default',
    required this.onTextFontChanged,
    this.textFont2 = 'default',
    required this.onTextFont2Changed,
    required this.fonts,
    required this.fontNames,
    this.textPosition = 'center',
    required this.onTextPositionChanged,
    this.textPosition2 = 'center',
    required this.onTextPosition2Changed,
    this.textSize = 16.0,
    required this.onTextSizeChanged,
    this.textSize2 = 16.0,
    required this.onTextSize2Changed,
    required this.dateText,
    required this.onDateTextChanged,
    this.dateText2 = '',
    required this.onDateText2Changed,
    required this.sentenceText,
    required this.onSentenceTextChanged,
    this.sentenceText2 = '',
    required this.onSentenceText2Changed,
    required this.textColor,
    required this.onTextColorChanged,
    this.textColor2 = Colors.black,
    required this.onTextColor2Changed,
    this.textDirection = 'horizontal',
    required this.onTextDirectionChanged,
    this.textDirection2 = 'horizontal',
    required this.onTextDirection2Changed,
    this.marginLeft = 0.0,
    required this.onMarginLeftChanged,
    this.marginRight = 0.0,
    required this.onMarginRightChanged,
    this.marginTop = 0.0,
    required this.onMarginTopChanged,
    this.marginBottom = 0.0,
    required this.onMarginBottomChanged,
    required this.onResetMargin,
  });

  @override
  State<EditTools> createState() => _EditToolsState();
}

class _EditToolsState extends State<EditTools> {
  /// 工具按钮配置列表
  /// 
  /// 定义了工具栏中所有可用的工具项
  static const List<ToolConfig> _toolConfigs = [
    ToolConfig(id: 'canvas', label: '图像', icon: Icons.crop_rotate),
    ToolConfig(id: 'filter', label: '滤镜', icon: Icons.filter),
    ToolConfig(id: 'adjust', label: '调整', icon: Icons.tune),
    ToolConfig(id: 'text', label: '文字', icon: Icons.text_fields),
    ToolConfig(id: 'color', label: '颜色', icon: Icons.color_lens),
    ToolConfig(id: 'margin', label: '留白', icon: Icons.margin),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildContainerDecoration(),
      child: Column(
        children: [
          _buildToolBar(),
          _buildToolPanel(),
        ],
      ),
    );
  }

  /// 构建容器装饰
  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, -5),
        ),
      ],
    );
  }

  /// 构建工具栏
  /// 
  /// 显示所有工具按钮，用户点击切换不同的编辑面板
  Widget _buildToolBar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _toolConfigs.map(_buildToolButton).toList(),
      ),
    );
  }

  /// 构建单个工具按钮
  /// 
  /// [config] 工具配置信息
  Widget _buildToolButton(ToolConfig config) {
    final isSelected = widget.currentTool == config.id;
    
    return GestureDetector(
      onTap: () => widget.onToolChanged(config.id),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildToolIcon(config.icon, isSelected),
          const SizedBox(height: 4),
          _buildToolLabel(config.label, isSelected),
        ],
      ),
    );
  }

  /// 构建工具图标
  Widget _buildToolIcon(IconData icon, bool isSelected) {
    return Icon(
      icon,
      size: 28,
      color: isSelected ? AppColors.iconSelected : AppColors.iconUnselected,
    );
  }

  /// 构建工具标签
  Widget _buildToolLabel(String label, bool isSelected) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        color: isSelected ? AppColors.iconSelected : AppColors.iconUnselected,
      ),
    );
  }

  /// 构建工具面板
  /// 
  /// 根据当前选中的工具显示对应的面板内容
  Widget _buildToolPanel() {
    final toolPanel = _getToolPanel();
    if (toolPanel == null) return const SizedBox.shrink();
    
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: toolPanel,
      ),
    );
  }

  /// 获取当前工具面板
  /// 
  /// 返回当前选中工具对应的面板组件
  Widget? _getToolPanel() {
    switch (widget.currentTool) {
      case 'canvas':
        return _buildCanvasPanel();
      case 'filter':
        return _buildFilterPanel();
      case 'adjust':
        return _buildAdjustPanel();
      case 'text':
        return _buildTextPanel();
      case 'color':
        return _buildColorPanel();
      case 'margin':
        return _buildMarginPanel();
      default:
        return null;
    }
  }

  /// 构建画布操作面板
  Widget _buildCanvasPanel() {
    return CanvasControls(
      onReset: widget.onReset,
      onCrop: widget.onCrop,
      onFlipHorizontal: widget.onFlipHorizontal,
      onFlipVertical: widget.onFlipVertical,
      onZoomIn: widget.onZoomIn,
      onZoomOut: widget.onZoomOut,
      onCenterHorizontal: widget.onCenterHorizontal,
      onRatio34: widget.onRatio34,
      onRatio43: widget.onRatio43,
    );
  }

  /// 构建滤镜面板
  Widget _buildFilterPanel() {
    return FilterSelector(
      filters: widget.filters,
      filterNames: widget.filterNames,
      currentFilter: widget.currentFilter,
      filterStrength: widget.filterStrength,
      onFilterSelected: widget.onFilterSelected,
      onFilterStrengthChanged: widget.onFilterStrengthChanged,
    );
  }

  /// 构建调整参数面板
  Widget _buildAdjustPanel() {
    return ParameterAdjustments(
      adjustments: widget.adjustments,
      selectedAdjustment: widget.selectedAdjustment,
      onAdjustmentSelected: widget.onAdjustmentSelected,
      onAdjustmentChanged: widget.onAdjustmentChanged,
    );
  }

  /// 构建文字编辑面板
  Widget _buildTextPanel() {
    return TextControls(
      textFont: widget.textFont,
      onTextFontChanged: widget.onTextFontChanged,
      textFont2: widget.textFont2,
      onTextFont2Changed: widget.onTextFont2Changed,
      fonts: widget.fonts,
      fontNames: widget.fontNames,
      textPosition: widget.textPosition,
      onTextPositionChanged: widget.onTextPositionChanged,
      textPosition2: widget.textPosition2,
      onTextPosition2Changed: widget.onTextPosition2Changed,
      textSize: widget.textSize,
      onTextSizeChanged: widget.onTextSizeChanged,
      textSize2: widget.textSize2,
      onTextSize2Changed: widget.onTextSize2Changed,
      textColor: widget.textColor,
      onTextColorChanged: widget.onTextColorChanged,
      textColor2: widget.textColor2,
      onTextColor2Changed: widget.onTextColor2Changed,
      dateText: widget.dateText,
      onDateTextChanged: widget.onDateTextChanged,
      dateText2: widget.dateText2,
      onDateText2Changed: widget.onDateText2Changed,
      sentenceText: widget.sentenceText,
      onSentenceTextChanged: widget.onSentenceTextChanged,
      sentenceText2: widget.sentenceText2,
      onSentenceText2Changed: widget.onSentenceText2Changed,
      textDirection: widget.textDirection,
      onTextDirectionChanged: widget.onTextDirectionChanged,
      textDirection2: widget.textDirection2,
      onTextDirection2Changed: widget.onTextDirection2Changed,
    );
  }

  /// 构建颜色选择面板
  Widget _buildColorPanel() {
    return ColorControls(
      currentColor: widget.currentBackgroundColor,
      onColorChanged: widget.onBackgroundColorChanged,
    );
  }

  /// 构建边距调整面板
  Widget _buildMarginPanel() {
    return MarginControls(
      marginLeft: widget.marginLeft,
      onMarginLeftChanged: widget.onMarginLeftChanged,
      marginRight: widget.marginRight,
      onMarginRightChanged: widget.onMarginRightChanged,
      marginTop: widget.marginTop,
      onMarginTopChanged: widget.onMarginTopChanged,
      marginBottom: widget.marginBottom,
      onMarginBottomChanged: widget.onMarginBottomChanged,
      onReset: widget.onResetMargin,
    );
  }
}
