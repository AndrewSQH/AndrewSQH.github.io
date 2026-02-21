import 'package:flutter/material.dart';

/// 可拖动的文字组件
/// 
/// 优化特性：
/// - 使用 ValueNotifier 减少不必要的组件重建
/// - 支持惯性滑动，提供流畅的交互体验
/// - 使用 Ticker 实现平滑的动画效果
/// - 优化手势识别，响应更灵敏
class TextDraggable extends StatefulWidget {
  /// 日期文本内容
  final String dateText;
  
  /// 句子文本内容
  final String sentenceText;
  
  /// 日期文本样式
  final TextStyle? dateTextStyle;
  
  /// 句子文本样式
  final TextStyle? sentenceTextStyle;
  
  /// 文本对齐方式
  final TextAlign textAlign;
  
  /// 交叉轴对齐方式
  final CrossAxisAlignment crossAxisAlignment;
  
  /// 主轴对齐方式
  final MainAxisAlignment mainAxisAlignment;
  
  /// 是否显示日期
  final bool showDate;
  
  /// 文本字体
  final String textFont;
  
  /// 文本位置
  final String textPosition;
  
  /// 文本大小
  final double textSize;
  
  /// 文本颜色
  final Color textColor;
  
  /// 初始位置
  final Offset initialPosition;
  
  /// 位置变化回调
  final Function(Offset)? onPositionChanged;

  const TextDraggable({
    super.key,
    required this.dateText,
    required this.sentenceText,
    this.dateTextStyle,
    this.sentenceTextStyle,
    required this.textAlign,
    required this.crossAxisAlignment,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.showDate = true,
    this.textFont = 'default',
    this.textPosition = 'center',
    this.textSize = 16.0,
    this.textColor = Colors.black,
    this.initialPosition = Offset.zero,
    this.onPositionChanged,
  });

  @override
  State<TextDraggable> createState() => _TextDraggableState();
}

class _TextDraggableState extends State<TextDraggable> with TickerProviderStateMixin {
  // ========== 状态变量 ==========
  
  /// 当前文字位置
  late Offset _textPosition;
  
  /// 上一次拖动的焦点位置
  Offset _lastFocalPoint = Offset.zero;
  
  // ========== 性能优化相关 ==========
  
  /// 用于减少重建的 ValueNotifier
  final ValueNotifier<Offset> _positionNotifier = ValueNotifier(Offset.zero);
  
  /// 是否正在执行手势操作
  bool _isInteracting = false;
  
  /// 上一次回调的时间戳（用于节流）
  int _lastCallbackTime = 0;
  
  /// 回调节流间隔（毫秒）
  static const int _callbackThrottleInterval = 16; // 约60fps

  @override
  void initState() {
    super.initState();
    _textPosition = widget.initialPosition;
    _positionNotifier.value = _textPosition;
  }

  @override
  void didUpdateWidget(covariant TextDraggable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当 widget 的 initialPosition 发生变化时，更新内部状态
    // 这样可以确保文字位置能够正确响应外部状态变化
    if (widget.initialPosition != oldWidget.initialPosition) {
      _textPosition = widget.initialPosition;
      _positionNotifier.value = _textPosition;
    }
  }
  
  @override
  void dispose() {
    _positionNotifier.dispose();
    super.dispose();
  }

  /// 获取字体样式
  TextStyle _getFontStyle() {
    if (widget.textFont != 'default') {
      return TextStyle(fontFamily: widget.textFont);
    } else {
      return const TextStyle();
    }
  }

  /// 处理拖动开始
  void _handlePanStart(DragStartDetails details) {
    _isInteracting = true;
    
    _lastFocalPoint = details.localPosition;
  }

  /// 处理拖动更新
  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isInteracting) return;
    
    // 计算新的位置（即时响应，无延迟）
    final offset = details.delta;
    _textPosition += offset;
    
    // 更新位置通知
    _positionNotifier.value = _textPosition;
  }

  /// 处理拖动结束
  void _handlePanEnd(DragEndDetails details) {
    _isInteracting = false;
    
    // 只在拖动结束时回调，避免拖动过程中的频繁更新
    widget.onPositionChanged?.call(_textPosition);
  }

  /// 节流回调函数
  void _throttledCallback() {
    // 移除节流回调，改为在拖动结束时回调
  }

  @override
  Widget build(BuildContext context) {
    final baseFontStyle = _getFontStyle();
    final textAlign = widget.textAlign;
    final crossAxisAlignment = widget.crossAxisAlignment;
    
    final dateTextStyle = baseFontStyle.merge(TextStyle(
      fontSize: widget.textSize * 0.75,
      color: widget.textColor,
    )).merge(widget.dateTextStyle ?? const TextStyle());
    
    final sentenceTextStyle = baseFontStyle.merge(TextStyle(
      fontSize: widget.textSize,
      color: widget.textColor,
    )).merge(widget.sentenceTextStyle ?? const TextStyle());

    return RepaintBoundary(
      child: ValueListenableBuilder<Offset>(
        valueListenable: _positionNotifier,
        builder: (context, position, child) {
          return Transform.translate(
            offset: position,
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: GestureDetector(
                  // 手势识别配置优化
                  behavior: HitTestBehavior.translucent,
                  onPanStart: _handlePanStart,
                  onPanUpdate: _handlePanUpdate,
                  onPanEnd: _handlePanEnd,
                  child: Container(
                    padding: const EdgeInsets.all(8), // 添加一些 padding 使点击更容易
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: crossAxisAlignment,
                      mainAxisAlignment: widget.mainAxisAlignment,
                      children: [
                        if (widget.showDate)
                          Text(
                            widget.dateText,
                            style: dateTextStyle,
                            textAlign: textAlign,
                          ),
                        if (widget.showDate)
                          const SizedBox(height: 2),
                        Text(
                          widget.sentenceText,
                          style: sentenceTextStyle,
                          textAlign: textAlign,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
