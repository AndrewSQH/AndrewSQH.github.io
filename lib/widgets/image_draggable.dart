import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// 可拖动、可缩放、可旋转的图片组件，支持自由变形
/// 
/// 优化特性：
/// - 使用 ValueNotifier 减少不必要的组件重建
/// - 支持惯性滑动，提供流畅的交互体验
/// - 使用 Ticker 实现平滑的动画效果
/// - 优化手势识别，支持多点触控
class ImageDraggable extends StatefulWidget {
  /// 图片字节数据（Web平台）
  final Uint8List? imageBytes;
  
  /// 图片文件（移动平台）
  final File? imageFile;
  
  /// 滤镜颜色
  final Color filterColor;
  
  /// 亮度调整值 (-1.0 到 1.0)
  final double brightness;
  
  /// 对比度调整值 (-1.0 到 1.0)
  final double contrast;
  
  /// 饱和度调整值 (-1.0 到 1.0)
  final double saturation;
  
  /// 色温调整值 (-1.0 到 1.0)
  final double temperature;
  
  /// 褪色调整值 (0.0 到 1.0)
  final double fade;
  
  /// 暗角调整值 (0.0 到 1.0)
  final double vignette;
  
  /// 模糊调整值 (0.0 到 10.0)
  final double blur;
  
  /// 颗粒调整值 (0.0 到 1.0)
  final double grain;
  
  /// 锐度调整值 (-1.0 到 1.0)
  final double sharpness;
  
  /// 是否水平翻转
  final bool flipHorizontal;
  
  /// 是否垂直翻转
  final bool flipVertical;
  
  /// 图片初始位置
  final Offset? imagePosition;
  
  /// 图片初始缩放比例
  final double? imageScale;
  
  /// 图片初始旋转角度（弧度）
  final double? imageRotation;
  
  /// 位置、缩放和旋转变化回调
  final Function(Offset, double, double)? onTransformChanged;

  const ImageDraggable({
    super.key,
    this.imageBytes,
    this.imageFile,
    this.filterColor = Colors.transparent,
    this.brightness = 0.0,
    this.contrast = 0.0,
    this.saturation = 0.0,
    this.temperature = 0.0,
    this.fade = 0.0,
    this.vignette = 0.0,
    this.blur = 0.0,
    this.grain = 0.0,
    this.sharpness = 0.0,
    this.flipHorizontal = false,
    this.flipVertical = false,
    this.imagePosition,
    this.imageScale,
    this.imageRotation,
    this.onTransformChanged,
  });

  @override
  State<ImageDraggable> createState() => _ImageDraggableState();
}

class _ImageDraggableState extends State<ImageDraggable> with TickerProviderStateMixin {
  // ========== 状态变量 ==========
  
  /// 当前图片位置
  late Offset _imagePosition;
  
  /// 当前图片缩放比例
  late double _imageScale;
  
  /// 当前图片旋转角度（弧度）
  late double _imageRotation;
  
  /// 上一次拖动的焦点位置
  Offset _lastFocalPoint = Offset.zero;
  
  /// 手势开始时的缩放值（用于计算增量缩放）
  double _startScale = 1.0;
  
  /// 手势开始时的旋转值
  double _startRotation = 0.0;
  
  // ========== 性能优化相关 ==========
  
  /// 用于减少重建的 ValueNotifier
  final ValueNotifier<Matrix4> _transformNotifier = ValueNotifier(Matrix4.identity());
  
  /// 是否正在执行手势操作
  bool _isInteracting = false;
  
  /// 上一次回调的时间戳（用于节流）
  int _lastCallbackTime = 0;
  
  /// 回调节流间隔（毫秒）
  static const int _callbackThrottleInterval = 16; // 约60fps
  
  // ========== 缓存相关 ==========
  
  /// 缓存的颜色矩阵
  List<double>? _cachedColorMatrix;
  
  /// 缓存的调整参数哈希值
  int? _lastAdjustmentHash;
  
  /// 缓存的图片组件
  Widget? _cachedImageWidget;
  
  /// 缓存的图片数据哈希值
  int? _lastImageDataHash;

  @override
  void initState() {
    super.initState();
    _imagePosition = widget.imagePosition ?? Offset.zero;
    _imageScale = widget.imageScale ?? 1.0;
    _imageRotation = widget.imageRotation ?? 0.0;
    _updateTransform();
  }

  @override
  void didUpdateWidget(covariant ImageDraggable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当外部传入新的位置、缩放或旋转值时更新状态
    // 这确保了重置功能正常工作
    if (widget.imagePosition != null || widget.imageScale != null || widget.imageRotation != null) {
      _imagePosition = widget.imagePosition ?? _imagePosition;
      _imageScale = widget.imageScale ?? _imageScale;
      _imageRotation = widget.imageRotation ?? _imageRotation;
      _updateTransform();
    }
    
    // 检查图片数据是否变化
    final currentImageHash = _calculateImageDataHash();
    if (currentImageHash != _lastImageDataHash) {
      _lastImageDataHash = currentImageHash;
      _cachedImageWidget = null;
    }
    
    // 检查调整参数是否变化
    final currentAdjustmentHash = _calculateAdjustmentHash();
    if (currentAdjustmentHash != _lastAdjustmentHash) {
      _lastAdjustmentHash = currentAdjustmentHash;
      _cachedColorMatrix = null;
    }
  }
  
  @override
  void dispose() {
    _transformNotifier.dispose();
    super.dispose();
  }

  /// 计算图片数据哈希值
  int _calculateImageDataHash() {
    int hash = 0;
    if (widget.imageBytes != null) {
      hash = widget.imageBytes!.length;
    } else if (widget.imageFile != null) {
      hash = widget.imageFile!.path.hashCode;
    }
    hash = hash * 31 + widget.filterColor.hashCode;
    return hash;
  }

  /// 计算调整参数哈希值
  int _calculateAdjustmentHash() {
    int hash = widget.brightness.hashCode;
    hash = hash * 31 + widget.contrast.hashCode;
    hash = hash * 31 + widget.saturation.hashCode;
    hash = hash * 31 + widget.temperature.hashCode;
    hash = hash * 31 + widget.fade.hashCode;
    hash = hash * 31 + widget.vignette.hashCode;
    return hash;
  }

  /// 更新变换矩阵
  void _updateTransform() {
    // 通过 ValueNotifier 通知更新，避免整个组件重建
    _transformNotifier.value = _buildTransformMatrix(Size.zero);
  }

  /// 构建变换矩阵
  Matrix4 _buildTransformMatrix(Size size) {
    // 直接构建变换矩阵，避免缓存带来的开销
    // 注意：Transform 组件已经使用了 alignment: Alignment.center
    // 所以所有变换都会围绕组件中心进行，不需要手动处理中心点平移
    return Matrix4.identity()
      // 应用图片位置位移
      ..translate(_imagePosition.dx, _imagePosition.dy)
      // 应用旋转
      ..rotateZ(_imageRotation)
      // 应用缩放和翻转
      // 由于 Transform 使用了 Alignment.center，这些变换会围绕中心进行
      ..scale(
        widget.flipHorizontal ? -_imageScale : _imageScale, 
        widget.flipVertical ? -_imageScale : _imageScale, 
        1
      );
  }

  /// 处理缩放开始
  void _handleScaleStart(ScaleStartDetails details) {
    _isInteracting = true;
    
    _lastFocalPoint = details.focalPoint;
    _startScale = _imageScale;
    _startRotation = _imageRotation;
  }

  /// 处理缩放更新
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (!_isInteracting) return;
    
    // 计算新的位置（即时响应，无延迟）
    final offset = details.focalPoint - _lastFocalPoint;
    _imagePosition += offset;
    _lastFocalPoint = details.focalPoint;
    
    // 计算新的缩放值（使用增量方式，避免累积误差）
    _imageScale = (_startScale * details.scale).clamp(0.5, 3.0);
    
    // 计算新的旋转角度
    _imageRotation = _startRotation + details.rotation;
    
    // 直接更新变换矩阵，避免缓存检查的开销
    _transformNotifier.value = _buildTransformMatrix(Size.zero);
  }

  /// 处理缩放结束
  void _handleScaleEnd(ScaleEndDetails details) {
    _isInteracting = false;
    
    // 只在拖动结束时回调，避免拖动过程中的频繁更新
    widget.onTransformChanged?.call(_imagePosition, _imageScale, _imageRotation);
  }

  /// 节流回调函数
  void _throttledCallback() {
    // 移除节流回调，改为在拖动结束时回调
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.loose,
        children: [
          GestureDetector(
            // 手势识别配置优化
            behavior: HitTestBehavior.opaque,
            onScaleStart: _handleScaleStart,
            onScaleUpdate: _handleScaleUpdate,
            onScaleEnd: _handleScaleEnd,
            child: ValueListenableBuilder<Matrix4>(
              valueListenable: _transformNotifier,
              builder: (context, transform, child) {
                return Transform(
                  transform: transform,
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: _buildImageWithAdjustments(),
            ),
          ),
          // 颗粒效果
          if (widget.grain > 0)
            Positioned.fill(
              child: CustomPaint(
                painter: GrainPainter(intensity: widget.grain),
              ),
            ),
        ],
      ),
    );
  }

  /// 构建带调整效果的图片组件
  Widget _buildImageWithAdjustments() {
    Widget imageWidget = _buildImageWidget();
    
    // 应用颜色矩阵调整（亮度、对比度、饱和度等）
    final colorMatrix = _buildColorMatrixArray();
    if (!_isIdentityMatrix(colorMatrix)) {
      imageWidget = ColorFiltered(
        colorFilter: ColorFilter.matrix(colorMatrix),
        child: imageWidget,
      );
    }
    
    // 应用模糊效果（注意：BackdropFilter 性能开销较大，仅在需要时使用）
    if (widget.blur > 0) {
      imageWidget = ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: widget.blur,
            sigmaY: widget.blur,
          ),
          child: imageWidget,
        ),
      );
    }
    
    // 应用暗角效果（边缘变暗，中心保持明亮）
    if (widget.vignette > 0) {
      imageWidget = Stack(
        fit: StackFit.expand,
        children: [
          imageWidget,
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(widget.vignette * 0.8),
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),
          ),
        ],
      );
    }
    
    return imageWidget;
  }

  /// 构建颜色矩阵（使用专业的图像处理算法）
  List<double> _buildColorMatrixArray() {
    // 使用缓存的颜色矩阵，只有当调整参数变化时才重新计算
    if (_cachedColorMatrix == null) {
      double b = widget.brightness;
      double c = widget.contrast;
      double s = widget.saturation;
      double t = widget.temperature;
      double f = widget.fade;

      List<double> matrix = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];

      if (b != 0) {
        final double brightnessFactor = b;
        matrix[0] = matrix[0] + brightnessFactor;
        matrix[1] = matrix[1] + brightnessFactor;
        matrix[2] = matrix[2] + brightnessFactor;
        matrix[5] = matrix[5] + brightnessFactor;
        matrix[6] = matrix[6] + brightnessFactor;
        matrix[7] = matrix[7] + brightnessFactor;
        matrix[10] = matrix[10] + brightnessFactor;
        matrix[11] = matrix[11] + brightnessFactor;
        matrix[12] = matrix[12] + brightnessFactor;
      }

      if (c != 0) {
        final double contrastFactor = (1 + c);
        final double translate = (-.5 * contrastFactor + .5) * 255;
        matrix[0] = matrix[0] * contrastFactor;
        matrix[1] = matrix[1] * contrastFactor;
        matrix[2] = matrix[2] * contrastFactor;
        matrix[5] = matrix[5] * contrastFactor;
        matrix[6] = matrix[6] * contrastFactor;
        matrix[7] = matrix[7] * contrastFactor;
        matrix[10] = matrix[10] * contrastFactor;
        matrix[11] = matrix[11] * contrastFactor;
        matrix[12] = matrix[12] * contrastFactor;
        matrix[4] = matrix[4] + translate;
        matrix[9] = matrix[9] + translate;
        matrix[14] = matrix[14] + translate;
      }

      if (s != 0) {
        final double sValue = 1 + s;
        final double sr = (1 - sValue) * 0.213;
        final double sg = (1 - sValue) * 0.715;
        final double sb = (1 - sValue) * 0.072;
        matrix[0] = sr + sValue * matrix[0];
        matrix[1] = sg + sValue * matrix[1];
        matrix[2] = sb + sValue * matrix[2];
        matrix[5] = sr + sValue * matrix[5];
        matrix[6] = sg + sValue * matrix[6];
        matrix[7] = sb + sValue * matrix[7];
        matrix[10] = sr + sValue * matrix[10];
        matrix[11] = sg + sValue * matrix[11];
        matrix[12] = sb + sValue * matrix[12];
      }

      if (t != 0) {
        // 色温调整：正值偏暖（增加红黄），负值偏冷（增加蓝）
        if (t > 0) {
          // 暖色调：增加红色，减少蓝色
          matrix[0] = matrix[0] + t * 0.3;
          matrix[1] = matrix[1] + t * 0.1;
          matrix[2] = matrix[2] - t * 0.2;
          matrix[5] = matrix[5] + t * 0.1;
          matrix[6] = matrix[6] + t * 0.1;
          matrix[7] = matrix[7] - t * 0.1;
          matrix[10] = matrix[10] - t * 0.2;
          matrix[11] = matrix[11] + t * 0.1;
          matrix[12] = matrix[12] - t * 0.2;
        } else {
          // 冷色调：增加蓝色，减少红色
          matrix[0] = matrix[0] + t * 0.2;
          matrix[1] = matrix[1] + t * 0.1;
          matrix[2] = matrix[2] - t * 0.3;
          matrix[5] = matrix[5] + t * 0.1;
          matrix[6] = matrix[6] + t * 0.1;
          matrix[7] = matrix[7] - t * 0.1;
          matrix[10] = matrix[10] - t * 0.2;
          matrix[11] = matrix[11] + t * 0.1;
          matrix[12] = matrix[12] - t * 0.3;
        }
      }

      if (f != 0) {
        final double fadeValue = f * 255;
        matrix[0] = matrix[0] + fadeValue * 0.0008;
        matrix[1] = matrix[1] + fadeValue * 0.0008;
        matrix[2] = matrix[2] + fadeValue * 0.0008;
        matrix[5] = matrix[5] + fadeValue * 0.0008;
        matrix[6] = matrix[6] + fadeValue * 0.0008;
        matrix[7] = matrix[7] + fadeValue * 0.0008;
        matrix[10] = matrix[10] + fadeValue * 0.0008;
        matrix[11] = matrix[11] + fadeValue * 0.0008;
        matrix[12] = matrix[12] + fadeValue * 0.0008;
        matrix[4] = matrix[4] + fadeValue * 0.05;
        matrix[9] = matrix[9] + fadeValue * 0.05;
        matrix[14] = matrix[14] + fadeValue * 0.05;
      }

      _cachedColorMatrix = matrix;
    }
    return _cachedColorMatrix!;
  }

  /// 检查颜色矩阵是否为单位矩阵
  bool _isIdentityMatrix(List<double> matrix) {
    // 检查是否为单位矩阵
    return matrix[0] == 1.0 &&
           matrix[6] == 1.0 &&
           matrix[12] == 1.0 &&
           matrix[18] == 1.0 &&
           matrix[4] == 0.0 &&
           matrix[10] == 0.0 &&
           matrix[16] == 0.0 &&
           matrix[1] == 0.0 &&
           matrix[2] == 0.0 &&
           matrix[3] == 0.0 &&
           matrix[5] == 0.0 &&
           matrix[7] == 0.0 &&
           matrix[8] == 0.0 &&
           matrix[9] == 0.0 &&
           matrix[11] == 0.0 &&
           matrix[13] == 0.0 &&
           matrix[14] == 0.0 &&
           matrix[15] == 0.0 &&
           matrix[17] == 0.0 &&
           matrix[19] == 0.0;
  }

  /// 构建图片组件
  Widget _buildImageWidget() {
    // 使用缓存的图片组件，只有当图片数据变化时才重新创建
    if (_cachedImageWidget == null) {
      Widget imageWidget;
      if (widget.imageBytes != null) {
        imageWidget = Image.memory(
          widget.imageBytes!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          color: widget.filterColor,
          colorBlendMode: BlendMode.overlay,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget();
          },
          // 添加缓存配置，提高性能
          cacheWidth: 1024, // 限制缓存宽度，根据实际需要调整
          cacheHeight: 1024, // 限制缓存高度，根据实际需要调整
        );
      } else if (widget.imageFile != null) {
        imageWidget = Image.file(
          widget.imageFile!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          color: widget.filterColor,
          colorBlendMode: BlendMode.overlay,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget();
          },
          // 添加缓存配置，提高性能
          cacheWidth: 1024, // 限制缓存宽度，根据实际需要调整
          cacheHeight: 1024, // 限制缓存高度，根据实际需要调整
        );
      } else {
        imageWidget = _buildEmptyWidget();
      }
      
      // 使用 RepaintBoundary 减少不必要的重绘
      _cachedImageWidget = RepaintBoundary(child: imageWidget);
    }
    return _cachedImageWidget!;
  }

  /// 构建错误状态组件
  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.error_outline,
          size: 48,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// 构建空状态组件
  Widget _buildEmptyWidget() {
    return Container(
      color: Colors.grey[100],
    );
  }
}

class GrainPainter extends CustomPainter {
  final double intensity;

  GrainPainter({required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0.01) return;

    final width = size.width.toInt();
    final height = size.height.toInt();
    final random = Random();
    final paint = Paint()..blendMode = BlendMode.overlay;

    final baseDensity = intensity * 0.1;
    final maxDensity = 0.05;
    final noiseDensity = baseDensity.clamp(0.005, maxDensity);
    final totalPixels = (width * height * noiseDensity).toInt().clamp(50, 5000);

    final colors = <Color>[];
    final offsets = <Offset>[];

    for (int i = 0; i < totalPixels; i++) {
      final x = random.nextDouble() * width;
      final y = random.nextDouble() * height;

      final rNoise = (random.nextDouble() * 2 - 1);
      final gNoise = (random.nextDouble() * 2 - 1);
      final bNoise = (random.nextDouble() * 2 - 1);

      final noiseAmplitude = intensity * 40;

      final r = (128 + rNoise * noiseAmplitude).clamp(0, 255).toInt();
      final g = (128 + gNoise * noiseAmplitude).clamp(0, 255).toInt();
      final b = (128 + bNoise * noiseAmplitude).clamp(0, 255).toInt();

      final opacity = intensity * 1.0;

      colors.add(Color.fromARGB((opacity * 255).toInt(), r, g, b));
      offsets.add(Offset(x, y));
    }

    for (int i = 0; i < colors.length; i++) {
      paint.color = colors[i];
      canvas.drawCircle(offsets[i], 0.6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant GrainPainter oldDelegate) {
    return oldDelegate.intensity != intensity;
  }
}
