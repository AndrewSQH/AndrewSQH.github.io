import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// 滤镜基类，提供通用的方法和接口
abstract class FilterBase {
  /// 滤镜强度 (0.0-1.0)
  final double strength;

  /// 构造函数
  FilterBase(this.strength);

  /// 应用滤镜到图片字节数据
  /// 
  /// [imageBytes] - 输入图片的字节数据
  /// 
  /// 返回处理后的图片字节数据
  Future<Uint8List> apply(Uint8List imageBytes) async {
    try {
      // 将字节数据转换为ui.Image
      final ui.Image image = await _bytesToImage(imageBytes);
      
      // 将ui.Image转换为ImageProvider
      final ImageProvider provider = MemoryImage(imageBytes);
      
      // 应用滤镜效果
      final Uint8List filteredBytes = await _applyFilter(image);
      
      return filteredBytes;
    } catch (e) {
      print('应用滤镜失败: $e');
      return imageBytes; // 失败时返回原始数据
    }
  }

  /// 内部方法：应用具体的滤镜效果
  /// 
  /// [image] - 输入图片
  /// 
  /// 返回处理后的图片字节数据
  Future<Uint8List> _applyFilter(ui.Image image) async {
    // 创建画布
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder, Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));

    // 绘制原始图片
    canvas.drawImage(image, Offset.zero, Paint());

    // 应用具体的滤镜效果
    applyToCanvas(canvas, image.width, image.height);

    // 结束录制
    final ui.Picture picture = recorder.endRecording();

    // 将画布转换为图片
    final ui.Image outputImage = await picture.toImage(image.width, image.height);

    // 将图片转换为字节数据
    final ByteData? byteData = await outputImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('无法将图片转换为字节数据');
    }

    return byteData.buffer.asUint8List();
  }

  /// 应用滤镜到画布
  /// 
  /// [canvas] - 画布
  /// [width] - 图片宽度
  /// [height] - 图片高度
  void applyToCanvas(Canvas canvas, int width, int height);

  /// 内部方法：将字节数据转换为ui.Image
  Future<ui.Image> _bytesToImage(Uint8List bytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  /// 内部方法：混合两个颜色
  Color blendColors(Color color1, Color color2, double ratio) {
    return Color.lerp(color1, color2, ratio)!;
  }

  /// 内部方法：创建径向渐变
  Gradient createRadialGradient(int width, int height, List<Color> colors) {
    return RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: colors,
    );
  }
}
