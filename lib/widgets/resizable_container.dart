import 'dart:math';
import 'package:flutter/material.dart';

/// 控制点位置枚举
enum HandlePosition {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// 可调整大小的容器组件
/// 
/// 用于包装文字和图片，提供矩形框自由拉伸功能
class ResizableContainer extends StatefulWidget {
  /// 子组件
  final Widget child;
  
  /// 初始宽度
  final double initialWidth;
  
  /// 初始高度
  final double initialHeight;
  
  /// 初始位置
  final Offset initialPosition;
  
  /// 宽高比（可选），设置后会保持此比例
  final double? aspectRatio;
  
  /// 最小宽度
  final double minWidth;
  
  /// 最小高度
  final double minHeight;
  
  /// 位置和大小变化回调
  final Function(Offset, double, double)? onTransformChanged;
  
  /// 是否可旋转
  final bool canRotate;

  const ResizableContainer({
    super.key,
    required this.child,
    required this.initialWidth,
    required this.initialHeight,
    this.initialPosition = Offset.zero,
    this.aspectRatio,
    this.minWidth = 50,
    this.minHeight = 50,
    this.onTransformChanged,
    this.canRotate = true,
  });

  @override
  State<ResizableContainer> createState() => _ResizableContainerState();
}

class _ResizableContainerState extends State<ResizableContainer> with TickerProviderStateMixin {
  /// 当前位置
  late Offset _position;
  
  /// 当前宽度
  late double _width;
  
  /// 当前高度
  late double _height;
  
  /// 当前旋转角度（弧度）
  double _rotation = 0.0;
  
  /// 是否正在拖动
  bool _isDragging = false;
  
  /// 是否正在调整大小
  bool _isResizing = false;
  
  /// 当前调整大小的控制点
  HandlePosition? _currentHandle;
  
  /// 手势开始时的位置
  Offset _startPosition = Offset.zero;
  
  /// 手势开始时的大小
  Size _startSize = Size.zero;
  
  /// 手势开始时的旋转角度
  double _startRotation = 0.0;
  
  /// 控制点大小
  static const double _handleSize = 8.0;
  
  /// 边框颜色
  static const Color _borderColor = Colors.blue;
  
  /// 边框宽度
  static const double _borderWidth = 1.5;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
    _width = widget.initialWidth;
    _height = widget.initialHeight;
  }

  @override
  void didUpdateWidget(covariant ResizableContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当initial尺寸变化时更新状态
    if (widget.initialWidth != oldWidget.initialWidth || 
        widget.initialHeight != oldWidget.initialHeight) {
      // 只有当尺寸为0或负数时才重置
      if (_width <= 0 || _height <= 0) {
        _width = widget.initialWidth;
        _height = widget.initialHeight;
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // 添加尺寸检查，避免对无尺寸的渲染框进行命中测试
    if (_width <= 0 || _height <= 0) {
      // 返回一个有最小尺寸的容器，避免命中测试错误
      return SizedBox(
        width: widget.minWidth,
        height: widget.minHeight,
      );
    }
    
    return Transform.translate(
      offset: _position,
      child: Transform.rotate(
        angle: _rotation,
        child: Stack(
          children: [
            // 主内容区域
            SizedBox(
              width: _width,
              height: _height,
              child: widget.child,
            ),
            
            // 可拖动的背景
            GestureDetector(
              onScaleStart: _handleDragStart,
              onScaleUpdate: _handleDragUpdate,
              onScaleEnd: _handleDragEnd,
              child: Container(
                width: _width,
                height: _height,
                color: Colors.transparent,
              ),
            ),
            
            // 边框
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _borderColor,
                    width: _borderWidth,
                  ),
                ),
              ),
            ),
            
            // 控制点
            _buildHandles(),
          ],
        ),
      ),
    );
  }

  /// 构建控制点
  Widget _buildHandles() {
    // 添加尺寸检查，避免在容器尺寸为零时构建控制点
    if (_width <= 0 || _height <= 0) {
      // 返回一个有最小尺寸的容器，避免命中测试错误
      return SizedBox(
        width: widget.minWidth,
        height: widget.minHeight,
      );
    }
    
    return Stack(
      children: [
        // 左上角
        _buildHandle(HandlePosition.topLeft, Offset(-_handleSize / 2, -_handleSize / 2)),
        
        // 上中
        _buildHandle(HandlePosition.topCenter, Offset(_width / 2 - _handleSize / 2, -_handleSize / 2)),
        
        // 右上角
        _buildHandle(HandlePosition.topRight, Offset(_width - _handleSize / 2, -_handleSize / 2)),
        
        // 左中
        _buildHandle(HandlePosition.centerLeft, Offset(-_handleSize / 2, _height / 2 - _handleSize / 2)),
        
        // 右中
        _buildHandle(HandlePosition.centerRight, Offset(_width - _handleSize / 2, _height / 2 - _handleSize / 2)),
        
        // 左下角
        _buildHandle(HandlePosition.bottomLeft, Offset(-_handleSize / 2, _height - _handleSize / 2)),
        
        // 下中
        _buildHandle(HandlePosition.bottomCenter, Offset(_width / 2 - _handleSize / 2, _height - _handleSize / 2)),
        
        // 右下角
        _buildHandle(HandlePosition.bottomRight, Offset(_width - _handleSize / 2, _height - _handleSize / 2)),
      ],
    );
  }

  /// 构建单个控制点
  Widget _buildHandle(HandlePosition position, Offset offset) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
        onScaleStart: (details) => _handleResizeStart(position, details),
        onScaleUpdate: _handleResizeUpdate,
        onScaleEnd: _handleResizeEnd,
        child: Container(
          width: _handleSize,
          height: _handleSize,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: _borderColor,
              width: _borderWidth,
            ),
            borderRadius: BorderRadius.circular(_handleSize / 2),
          ),
        ),
      ),
    );
  }

  /// 处理拖拽开始
  void _handleDragStart(ScaleStartDetails details) {
    _isDragging = true;
    _startPosition = details.focalPoint;
    _startRotation = _rotation;
  }

  /// 处理拖拽更新
  void _handleDragUpdate(ScaleUpdateDetails details) {
    if (!_isDragging) return;
    
    // 更新位置
    final offset = details.focalPoint - _startPosition;
    setState(() {
      _position += offset;
      _startPosition = details.focalPoint;
      
      // 更新旋转角度
      if (widget.canRotate) {
        _rotation = _startRotation + details.rotation;
      }
    });
    
    // 通知回调
    widget.onTransformChanged?.call(_position, _width, _height);
  }

  /// 处理拖拽结束
  void _handleDragEnd(ScaleEndDetails details) {
    _isDragging = false;
  }

  /// 处理调整大小开始
  void _handleResizeStart(HandlePosition position, ScaleStartDetails details) {
    _isResizing = true;
    _currentHandle = position;
    _startPosition = details.focalPoint;
    _startSize = Size(_width, _height);
  }

  /// 处理调整大小更新
  void _handleResizeUpdate(ScaleUpdateDetails details) {
    if (!_isResizing || _currentHandle == null) return;
    
    final offset = details.focalPoint - _startPosition;
    double newWidth = _startSize.width;
    double newHeight = _startSize.height;
    
    // 根据控制点位置调整大小
    switch (_currentHandle!) {
      case HandlePosition.topLeft:
        newWidth = _startSize.width - offset.dx;
        newHeight = _startSize.height - offset.dy;
        break;
      case HandlePosition.topCenter:
        newHeight = _startSize.height - offset.dy;
        break;
      case HandlePosition.topRight:
        newWidth = _startSize.width + offset.dx;
        newHeight = _startSize.height - offset.dy;
        break;
      case HandlePosition.centerLeft:
        newWidth = _startSize.width - offset.dx;
        break;
      case HandlePosition.centerRight:
        newWidth = _startSize.width + offset.dx;
        break;
      case HandlePosition.bottomLeft:
        newWidth = _startSize.width - offset.dx;
        newHeight = _startSize.height + offset.dy;
        break;
      case HandlePosition.bottomCenter:
        newHeight = _startSize.height + offset.dy;
        break;
      case HandlePosition.bottomRight:
        newWidth = _startSize.width + offset.dx;
        newHeight = _startSize.height + offset.dy;
        break;
    }
    
    // 应用最小尺寸限制
    newWidth = max(newWidth, widget.minWidth);
    newHeight = max(newHeight, widget.minHeight);
    
    // 保持宽高比
    if (widget.aspectRatio != null) {
      final aspectRatio = widget.aspectRatio!;
      final currentRatio = newWidth / newHeight;
      
      if (currentRatio > aspectRatio) {
        // 宽度过大，调整宽度
        newWidth = newHeight * aspectRatio;
      } else {
        // 高度过大，调整高度
        newHeight = newWidth / aspectRatio;
      }
    }
    
    setState(() {
      _width = newWidth;
      _height = newHeight;
    });
    
    // 通知回调
    widget.onTransformChanged?.call(_position, _width, _height);
  }

  /// 处理调整大小结束
  void _handleResizeEnd(ScaleEndDetails details) {
    _isResizing = false;
    _currentHandle = null;
  }
}
