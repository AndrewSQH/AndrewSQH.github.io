import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'models/edit_tools_config.dart';

/// 画布控制组件
/// 
/// 提供图像操作的控制按钮，包括：
/// - 重置、放大、缩小
/// - 裁剪、翻转
/// - 比例调整
/// 
/// 该组件采用无状态设计，所有操作通过回调函数传递给父组件处理
class CanvasControls extends StatelessWidget {
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

  const CanvasControls({
    super.key,
    required this.onReset,
    required this.onCrop,
    required this.onFlipHorizontal,
    required this.onFlipVertical,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onCenterHorizontal,
    required this.onRatio34,
    required this.onRatio43,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTitle(),
        const SizedBox(height: 8),
        _buildHint(),
        const SizedBox(height: 16),
        _buildButtonRow(),
      ],
    );
  }

  /// 构建标题
  Widget _buildTitle() {
    return Text(
      '图像操作',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  /// 构建提示文字
  Widget _buildHint() {
    return Text(
      '提示：拖动图片和文字可调整位置',
      style: TextStyle(
        fontSize: 12,
        color: AppColors.textSecondary,
      ),
    );
  }

  /// 构建按钮行
  Widget _buildButtonRow() {
    // 获取按钮配置列表
    final buttons = _getButtonConfigs();
    
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: buttons.map((button) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: _buildCanvasButton(button),
          )).toList(),
        ),
      ),
    );
  }

  /// 获取按钮配置列表
  /// 
  /// 按照功能分组返回按钮配置，便于维护和扩展
  List<CanvasButtonConfig> _getButtonConfigs() {
    return [
      // 基础操作
      CanvasButtonConfig(
        label: '重置',
        icon: Icons.refresh,
        onTap: onReset,
      ),
      CanvasButtonConfig(
        label: '放大',
        icon: Icons.zoom_in,
        onTap: onZoomIn,
      ),
      CanvasButtonConfig(
        label: '缩小',
        icon: Icons.zoom_out,
        onTap: onZoomOut,
      ),
      
      // 变换操作
      CanvasButtonConfig(
        label: '裁剪',
        icon: Icons.crop,
        onTap: onCrop,
      ),
      CanvasButtonConfig(
        label: '水平翻转',
        icon: Icons.flip,
        onTap: onFlipHorizontal,
      ),
      CanvasButtonConfig(
        label: '垂直翻转',
        icon: Icons.flip_camera_android,
        onTap: onFlipVertical,
      ),
      
      // 对齐和比例
      CanvasButtonConfig(
        label: '水平居中',
        icon: Icons.format_align_center,
        onTap: onCenterHorizontal,
      ),
      CanvasButtonConfig(
        label: '3:4',
        icon: Icons.square_outlined,
        onTap: onRatio34,
      ),
      CanvasButtonConfig(
        label: '4:3',
        icon: Icons.square_rounded,
        onTap: onRatio43,
      ),
    ];
  }

  /// 构建单个画布控制按钮
  /// 
  /// [config] 按钮配置信息
  Widget _buildCanvasButton(CanvasButtonConfig config) {
    return GestureDetector(
      onTap: config.onTap,
      child: Column(
        children: [
          _buildButtonIcon(config.icon),
          const SizedBox(height: 4),
          _buildButtonLabel(config.label),
        ],
      ),
    );
  }

  /// 构建按钮图标容器
  Widget _buildButtonIcon(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: _buildButtonDecoration(),
      child: Icon(
        icon,
        size: 22,
        color: AppColors.primary,
      ),
    );
  }

  /// 构建按钮装饰样式
  BoxDecoration _buildButtonDecoration() {
    return BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  /// 构建按钮标签
  Widget _buildButtonLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
