import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'app_colors.dart';

class CanvasTextRenderer {
  // 渲染整个画布（包括背景、边框、图片和文字）
  static Future<File?> renderCanvas(File imageFile, String dateText, String sentenceText, {
    String dateText2 = '',
    String sentenceText2 = '',
    double brightness = 0.0,
    double contrast = 0.0,
    double saturation = 0.0,
    double temperature = 0.0,
    double fade = 0.0,
    double vignette = 0.0,
    double blur = 0.0,
    double grain = 0.0,
    double sharpness = 0.0,
    String? filterName,
    double filterStrength = 0.5,
    String templateId = 'pattern_1',
    double rotation = 0.0,
    bool flipHorizontal = false,
    bool flipVertical = false,
    Offset? croppedImagePosition,
    double croppedImageScale = 1.0,
    String textFont = 'default',
    String textFont2 = 'default',
    String textPosition = 'center',
    String textPosition2 = 'center',
    double textSize = 16.0,
    double textSize2 = 16.0,
    String borderColor = '#FFFFFF',
    String backgroundColor = '#F8F5F0',
    double borderWidth = 10.0,
  }) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        // 在Web平台上，直接返回原始文件
        // 因为Web平台无法直接写入文件
        return imageFile;
      }

      // 加载图片为 ui.Image
      final ui.Image? image = await _loadImageFromFile(imageFile);
      if (image == null) {
        print('无法加载图片文件');
        return null;
      }
      
      // 使用图片的实际比例作为画布比例
      final double canvasWidth = image.width.toDouble();
      final double canvasHeight = image.height.toDouble();
      
      // 创建画布
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder, Rect.fromLTWH(0, 0, canvasWidth, canvasHeight));
      
      // 1. 绘制画布背景
      final backgroundPaint = Paint()..color = HexColor(backgroundColor);
      canvas.drawRect(
        Rect.fromLTWH(0, 0, canvasWidth, canvasHeight),
        backgroundPaint,
      );
      
      // 2. 绘制边框
      final borderPaint = Paint()
        ..color = HexColor(borderColor)
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;
      canvas.drawRect(
        Rect.fromLTWH(borderWidth / 2, borderWidth / 2, canvasWidth - borderWidth, canvasHeight - borderWidth),
        borderPaint,
      );
      
      // 3. 绘制内容区域（减去边框）
      final contentRect = Rect.fromLTWH(
        borderWidth,
        borderWidth,
        canvasWidth - borderWidth * 2,
        canvasHeight - borderWidth * 2,
      );
      
      // 保存画布状态
      canvas.save();
      
      // 裁剪到内容区域
      canvas.clipRect(contentRect);
      
      // 4. 根据模板ID绘制布局
      _drawTemplateLayout(
        canvas, 
        templateId, 
        image, 
        dateText, 
        sentenceText, 
        dateText2, 
        sentenceText2, 
        contentRect.width, 
        contentRect.height, 
        brightness, 
        contrast, 
        saturation, 
        temperature, 
        fade, 
        vignette, 
        blur, 
        grain, 
        sharpness, 
        filterName, 
        filterStrength, 
        croppedImagePosition, 
        croppedImageScale, 
        textFont, 
        textFont2, 
        textPosition, 
        textPosition2, 
        textSize, 
        textSize2, 
        flipHorizontal, 
        flipVertical, 
        rotation
      );
      
      // 恢复画布状态
      canvas.restore();
      
      // 结束录制
      final ui.Picture picture = recorder.endRecording();
      
      // 将画布转换为图片
      final ui.Image outputImage = await picture.toImage(canvasWidth.toInt(), canvasHeight.toInt());
      
      // 将图片转换为字节数据
      final ByteData? byteData = await outputImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      
      final Uint8List pngBytes = byteData.buffer.asUint8List();
      
      // 保存为文件
      final File outputFile = File('${imageFile.path}_canvas_render.png');
      await outputFile.writeAsBytes(pngBytes);
      
      return outputFile;
    } catch (e) {
      print('渲染画布失败: $e');
      // 出错时返回原始文件，确保流程不中断
      return imageFile;
    }
  }

  // 在Web平台上渲染整个画布
  static Future<Uint8List?> renderCanvasWeb(Uint8List imageBytes, String dateText, String sentenceText, String dateText2, String sentenceText2, {
    double brightness = 0.0,
    double contrast = 0.0,
    double saturation = 0.0,
    double temperature = 0.0,
    double fade = 0.0,
    double vignette = 0.0,
    double blur = 0.0,
    double grain = 0.0,
    double sharpness = 0.0,
    String? filterName,
    double filterStrength = 0.5,
    String templateId = 'pattern_1',
    double rotation = 0.0,
    bool flipHorizontal = false,
    bool flipVertical = false,
    Offset? croppedImagePosition,
    double croppedImageScale = 1.0,
    String textFont = 'default',
    String textFont2 = 'default',
    String textPosition = 'center',
    String textPosition2 = 'center',
    double textSize = 16.0,
    double textSize2 = 16.0,
    String borderColor = '#FFFFFF',
    String backgroundColor = '#F8F5F0',
    double borderWidth = 10.0,
  }) async {
    try {
      // 加载图片为 ui.Image
      final ui.Image? image = await _loadImageFromBytes(imageBytes);
      if (image == null) {
        print('无法加载图片字节数据');
        return null;
      }
      
      // 使用固定的3:4比例画布，与编辑界面保持一致
      final double canvasWidth = 800;
      final double canvasHeight = canvasWidth * 4 / 3;
      
      // 创建画布
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder, Rect.fromLTWH(0, 0, canvasWidth, canvasHeight));
      
      // 1. 绘制画布背景
      final backgroundPaint = Paint()..color = HexColor(backgroundColor);
      canvas.drawRect(
        Rect.fromLTWH(0, 0, canvasWidth, canvasHeight),
        backgroundPaint,
      );
      
      // 2. 绘制边框
      final borderPaint = Paint()
        ..color = HexColor(borderColor)
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;
      canvas.drawRect(
        Rect.fromLTWH(borderWidth / 2, borderWidth / 2, canvasWidth - borderWidth, canvasHeight - borderWidth),
        borderPaint,
      );
      
      // 3. 绘制内容区域（减去边框）
      final contentRect = Rect.fromLTWH(
        borderWidth,
        borderWidth,
        canvasWidth - borderWidth * 2,
        canvasHeight - borderWidth * 2,
      );
      
      // 保存画布状态
      canvas.save();
      
      // 裁剪到内容区域
      canvas.clipRect(contentRect);
      
      // 4. 根据模板ID绘制布局
      _drawTemplateLayout(
        canvas, 
        templateId, 
        image, 
        dateText, 
        sentenceText, 
        dateText2, 
        sentenceText2, 
        contentRect.width, 
        contentRect.height, 
        brightness, 
        contrast, 
        saturation, 
        temperature, 
        fade, 
        vignette, 
        blur, 
        grain, 
        sharpness, 
        filterName, 
        filterStrength, 
        croppedImagePosition, 
        croppedImageScale, 
        textFont, 
        textFont2, 
        textPosition, 
        textPosition2, 
        textSize, 
        textSize2, 
        flipHorizontal, 
        flipVertical, 
        rotation
      );
      
      // 恢复画布状态
      canvas.restore();
      
      // 结束录制
      final ui.Picture picture = recorder.endRecording();
      
      // 将画布转换为图片
      final ui.Image outputImage = await picture.toImage(canvasWidth.toInt(), canvasHeight.toInt());
      
      // 将图片转换为字节数据
      final ByteData? byteData = await outputImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      
      final Uint8List pngBytes = byteData.buffer.asUint8List();
      
      return pngBytes;
    } catch (e) {
      print('Web平台渲染画布失败: $e');
      // 出错时返回原始字节数据，确保流程不中断
      return imageBytes;
    }
  }

  // 在Web平台上添加文字到图片字节数据
  static Future<Uint8List?> addTextToImageWeb(Uint8List imageBytes, String dateText, String sentenceText, {
    String dateText2 = '',
    String sentenceText2 = '',
    String? framePath,
    double brightness = 0.0,
    double contrast = 0.0,
    double saturation = 0.0,
    double temperature = 0.0,
    double fade = 0.0,
    double vignette = 0.0,
    double blur = 0.0,
    double grain = 0.0,
    double sharpness = 0.0,
    String? filterName,
    double filterStrength = 0.5,
    String templateId = 'pattern_1', // 添加模板ID参数
    Offset? croppedImagePosition,
    double croppedImageScale = 1.0,
    String textFont = 'default',
    String textFont2 = 'default',
    String textPosition = 'center',
    String textPosition2 = 'center',
    double textSize = 16.0,
    double textSize2 = 16.0,
    bool flipHorizontal = false,
    bool flipVertical = false,
    Color backgroundColor = const Color(0xFFF8F5F0),
  }) async {
    try {
      // 加载图片为 ui.Image
      final ui.Image? image = await _loadImageFromBytes(imageBytes);
      if (image == null) {
        print('无法加载图片字节数据');
        return null;
      }
      
      // 使用图片的实际比例作为画布比例
      double canvasWidth = image.width.toDouble();
      double canvasHeight = image.height.toDouble();
      
      // 创建画布
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder, Rect.fromLTWH(0, 0, canvasWidth, canvasHeight));
      
      // 首先绘制整个画布的背景
      canvas.drawRect(
        Rect.fromLTWH(0, 0, canvasWidth, canvasHeight),
        Paint()..color = backgroundColor,
      );
      
      // 根据模板ID绘制布局
      _drawTemplateLayout(canvas, templateId, image, dateText, sentenceText, dateText2, sentenceText2, canvasWidth, canvasHeight, brightness, contrast, saturation, temperature, fade, vignette, blur, grain, sharpness, filterName, filterStrength, croppedImagePosition, croppedImageScale, textFont, textFont2, textPosition, textPosition2, textSize, textSize2, flipHorizontal, flipVertical, 0.0);
      
      // 结束录制
      final ui.Picture picture = recorder.endRecording();
      
      // 将画布转换为图片
      final ui.Image outputImage = await picture.toImage(canvasWidth.toInt(), canvasHeight.toInt());
      
      // 将图片转换为字节数据
      final ByteData? byteData = await outputImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      
      final Uint8List pngBytes = byteData.buffer.asUint8List();
      
      return pngBytes;
    } catch (e) {
      print('Web平台添加文字失败: $e');
      // 出错时返回原始字节数据，确保流程不中断
      return imageBytes;
    }
  }
  
  // 根据模板ID绘制布局
  static void _drawTemplateLayout(Canvas canvas, String templateId, ui.Image image, String dateText, String sentenceText, String dateText2, String sentenceText2, double canvasWidth, double canvasHeight, double brightness, double contrast, double saturation, double temperature, double fade, double vignette, double blur, double grain, double sharpness, String? filterName, double filterStrength, Offset? croppedImagePosition, double croppedImageScale, String textFont, String textFont2, String textPosition, String textPosition2, double textSize, double textSize2, bool flipHorizontal, bool flipVertical, [double rotation = 0.0]) {
    switch (templateId) {
      case 'pattern_1':
        // 经典布局（顶部图片 + 底部文字）
        _drawPattern1Layout(canvas, image, dateText, sentenceText, dateText2, sentenceText2, canvasWidth, canvasHeight, brightness, contrast, saturation, temperature, fade, vignette, blur, grain, sharpness, filterName, filterStrength, croppedImagePosition, croppedImageScale, textFont, textFont2, textPosition, textPosition2, textSize, textSize2, flipHorizontal, flipVertical, rotation);
        break;
      case 'pattern_2':
        // 文字优先（顶部文字 + 底部图片）
        _drawPattern2Layout(canvas, image, dateText, sentenceText, dateText2, sentenceText2, canvasWidth, canvasHeight, brightness, contrast, saturation, temperature, fade, vignette, blur, grain, sharpness, filterName, filterStrength, croppedImagePosition, croppedImageScale, textFont, textFont2, textPosition, textPosition2, textSize, textSize2, flipHorizontal, flipVertical, rotation);
        break;
      case 'pattern_3':
        // 图片为主（顶部图片 + 底部居中大标题）
        _drawPattern3Layout(canvas, image, dateText, sentenceText, dateText2, sentenceText2, canvasWidth, canvasHeight, brightness, contrast, saturation, temperature, fade, vignette, blur, grain, sharpness, filterName, filterStrength, croppedImagePosition, croppedImageScale, textFont, textFont2, textPosition, textPosition2, textSize, textSize2, flipHorizontal, flipVertical, rotation);
        break;
      case 'pattern_4':
        // 居中布局（顶部图片 + 居中文字）
        _drawPattern4Layout(canvas, image, dateText, sentenceText, dateText2, sentenceText2, canvasWidth, canvasHeight, brightness, contrast, saturation, temperature, fade, vignette, blur, grain, sharpness, filterName, filterStrength, croppedImagePosition, croppedImageScale, textFont, textFont2, textPosition, textPosition2, textSize, textSize2, flipHorizontal, flipVertical, rotation);
        break;
      case 'pattern_5':
        // 标题突出（顶部大标题 + 底部文字 + 底部图片）
        _drawPattern5Layout(canvas, image, dateText, sentenceText, dateText2, sentenceText2, canvasWidth, canvasHeight, brightness, contrast, saturation, temperature, fade, vignette, blur, grain, sharpness, filterName, filterStrength, croppedImagePosition, croppedImageScale, textFont, textFont2, textPosition, textPosition2, textSize, textSize2, flipHorizontal, flipVertical, rotation);
        break;
      default:
        // 默认布局
        _drawPattern1Layout(canvas, image, dateText, sentenceText, dateText2, sentenceText2, canvasWidth, canvasHeight, brightness, contrast, saturation, temperature, fade, vignette, blur, grain, sharpness, filterName, filterStrength, croppedImagePosition, croppedImageScale, textFont, textFont2, textPosition, textPosition2, textSize, textSize2, flipHorizontal, flipVertical, rotation);
        break;
    }
  }
  
  // 绘制pattern_1布局（顶部图片 + 底部文字）
  static void _drawPattern1Layout(Canvas canvas, ui.Image image, String dateText, String sentenceText, String dateText2, String sentenceText2, double canvasWidth, double canvasHeight, double brightness, double contrast, double saturation, double temperature, double fade, double vignette, double blur, double grain, double sharpness, String? filterName, double filterStrength, Offset? croppedImagePosition, double croppedImageScale, String textFont, String textFont2, String textPosition, String textPosition2, double textSize, double textSize2, bool flipHorizontal, bool flipVertical, [double rotation = 0.0]) {
    // 设置图像与文字占比为5.5:1
    double imageHeight = canvasHeight * 5.5 / 6.5; // 图片占5.5/6.5
    double textHeight = canvasHeight * 1 / 6.5; // 文字占1/6.5
    
    // 确保文字区域有足够的空间
    textHeight = textHeight.clamp(100.0, 180.0);
    imageHeight = canvasHeight - textHeight;
    
    // 计算保持宽高比的图片显示区域
    final Rect imageRect = _calculateImageRect(image, 0, 0, canvasWidth, imageHeight);
    
    // 保存当前画布状态
    canvas.save();
    
    // 计算图片的原始显示区域（不考虑变换）
    final Rect originalImageRect = _calculateImageRect(image, 0, 0, canvasWidth, imageHeight);
    
    // 保存当前画布状态
    canvas.save();
    
    // 应用翻转效果 - 严格围绕图像几何中心进行
    _applyFlip(canvas, originalImageRect, flipHorizontal, flipVertical);
    
    // 应用裁剪位置、缩放和旋转
    if (croppedImagePosition != null || rotation != 0 || croppedImageScale != 1.0) {
      // 计算图片中心点
      final Offset center = Offset(originalImageRect.width / 2, originalImageRect.height / 2);
      
      // 应用位置偏移
      canvas.translate(croppedImagePosition?.dx ?? 0, croppedImagePosition?.dy ?? 0);
      
      // 移动到中心点
      canvas.translate(center.dx, center.dy);
      
      // 应用旋转
      if (rotation != 0) {
        canvas.rotate(rotation);
      }
      
      // 应用缩放
      canvas.scale(croppedImageScale);
      
      // 移回中心点
      canvas.translate(-center.dx, -center.dy);
    }
    
    // 绘制图片
    final sourceRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    canvas.drawImageRect(
      image,
      sourceRect,
      originalImageRect,
      Paint(),
    );
    
    // 恢复画布状态
    canvas.restore();
    
    // 重新保存画布状态以应用调整
    canvas.save();
    
    // 应用图片调整
    _applyImageAdjustments(canvas, canvasWidth.toInt(), imageHeight.toInt(), brightness, contrast, saturation, temperature, fade, vignette, blur, grain, sharpness, filterName, filterStrength);
    
    // 恢复画布状态
    canvas.restore();
    
    // 获取字体家族
    final fontFamily1 = textFont != 'default' ? textFont : 'Roboto';
    final fontFamily2 = textFont2 != 'default' ? textFont2 : 'Roboto';
    
    // 获取文字对齐方式
    final textAlign1 = _getTextAlignFromString(textPosition);
    final textAlign2 = _getTextAlignFromString(textPosition2);
    
    // 绘制文字
    final double textAreaTop = imageHeight;
    final double textAreaLeft = 20.0;
    final double textAreaWidth = canvasWidth - 40.0;
    
    // 绘制日期文字（左侧） - 第一处文字
    final dateTextPainter1 = TextPainter(
      text: TextSpan(
        text: dateText,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize * 0.75,
          fontFamily: fontFamily1,
          fontWeight: FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制短句文字（右侧） - 第一处文字
    final sentenceTextPainter1 = TextPainter(
      text: TextSpan(
        text: sentenceText,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize,
          fontFamily: fontFamily1,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制日期文字（左侧） - 第二处文字
    final dateTextPainter2 = TextPainter(
      text: TextSpan(
        text: dateText2,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize2 * 0.75,
          fontFamily: fontFamily2,
          fontWeight: FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制短句文字（右侧） - 第二处文字
    final sentenceTextPainter2 = TextPainter(
      text: TextSpan(
        text: sentenceText2,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize2,
          fontFamily: fontFamily2,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制文字区域背景，使用整个画布宽度
    final textBackgroundWidth = canvasWidth;
    final textBackgroundX = 0.0;
    
    canvas.drawRect(
      Rect.fromLTWH(textBackgroundX, imageHeight, textBackgroundWidth, textHeight),
      Paint()..color = Color(0xFFF8F5F0),
    );
    
    // 绘制第一处文字
    dateTextPainter1.paint(canvas, Offset(textBackgroundX + 20, textAreaTop + 10));
    sentenceTextPainter1.paint(canvas, Offset(textBackgroundX + textBackgroundWidth - 20 - sentenceTextPainter1.width, textAreaTop + 30));
    
    // 绘制第二处文字（在第一处文字下方）
    if (dateText2.isNotEmpty || sentenceText2.isNotEmpty) {
      // 调整文字2的位置，确保显示在合适的位置
      double text2Top = textAreaTop + 50;
      if (dateText2.isNotEmpty) {
        dateTextPainter2.paint(canvas, Offset(textBackgroundX + 20, text2Top));
        text2Top += 20;
      }
      if (sentenceText2.isNotEmpty) {
        sentenceTextPainter2.paint(canvas, Offset(textBackgroundX + textBackgroundWidth - 20 - sentenceTextPainter2.width, text2Top));
      }
    }
  }
  
  // 应用翻转效果，严格围绕图像的几何中心进行
  static void _applyFlip(Canvas canvas, Rect imageRect, bool flipHorizontal, bool flipVertical) {
    if (flipHorizontal || flipVertical) {
      // 计算图像的几何中心（绝对坐标）
      final double centerX = imageRect.left + imageRect.width / 2;
      final double centerY = imageRect.top + imageRect.height / 2;
      
      // 先平移到几何中心
      canvas.translate(centerX, centerY);
      
      // 应用翻转
      canvas.scale(flipHorizontal ? -1 : 1, flipVertical ? -1 : 1);
      
      // 再平移回原来的位置
      canvas.translate(-centerX, -centerY);
    }
  }

  // 根据字符串获取文字对齐方式
  static TextAlign _getTextAlignFromString(String alignment) {
    switch (alignment) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.center;
    }
  }
  
  // 绘制pattern_2布局（顶部文字 + 底部图片）
  static void _drawPattern2Layout(Canvas canvas, ui.Image image, String dateText, String sentenceText, String dateText2, String sentenceText2, double canvasWidth, double canvasHeight, double brightness, double contrast, double saturation, double temperature, double fade, double vignette, double blur, double grain, double sharpness, String? filterName, double filterStrength, Offset? croppedImagePosition, double croppedImageScale, String textFont, String textFont2, String textPosition, String textPosition2, double textSize, double textSize2, bool flipHorizontal, bool flipVertical, [double rotation = 0.0]) {
    // 设置图像与文字占比为5.5:1
    double textHeight = canvasHeight * 1 / 6.5; // 文字占1/6.5
    double imageHeight = canvasHeight * 5.5 / 6.5; // 图片占5.5/6.5
    
    // 确保文字区域有足够的空间
    textHeight = textHeight.clamp(120.0, 220.0);
    imageHeight = canvasHeight - textHeight;
    
    // 绘制文字
    final double textAreaTop = 0.0;
    final double textAreaLeft = 20.0;
    final double textAreaWidth = canvasWidth - 40.0;
    
    // 获取字体家族
    final fontFamily1 = textFont != 'default' ? textFont : 'Roboto';
    final fontFamily2 = textFont2 != 'default' ? textFont2 : 'Roboto';
    
    // 获取文字对齐方式
    final textAlign1 = _getTextAlignFromString(textPosition);
    final textAlign2 = _getTextAlignFromString(textPosition2);
    
    // 绘制日期文字（左侧） - 第一处文字
    final dateTextPainter1 = TextPainter(
      text: TextSpan(
        text: dateText,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize * 0.75,
          fontFamily: fontFamily1,
          fontWeight: FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制短句文字（右侧） - 第一处文字
    final sentenceTextPainter1 = TextPainter(
      text: TextSpan(
        text: sentenceText,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize,
          fontFamily: fontFamily1,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制日期文字（左侧） - 第二处文字
    final dateTextPainter2 = TextPainter(
      text: TextSpan(
        text: dateText2,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize2 * 0.75,
          fontFamily: fontFamily2,
          fontWeight: FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制短句文字（右侧） - 第二处文字
    final sentenceTextPainter2 = TextPainter(
      text: TextSpan(
        text: sentenceText2,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize2,
          fontFamily: fontFamily2,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制文字区域背景，使用整个画布宽度
    final textBackgroundWidth = canvasWidth;
    final textBackgroundX = 0.0;
    
    canvas.drawRect(
      Rect.fromLTWH(textBackgroundX, 0, textBackgroundWidth, textHeight),
      Paint()..color = Color(0xFFF8F5F0),
    );
    
    // 绘制第一处文字
    dateTextPainter1.paint(canvas, Offset(textBackgroundX + 20, textAreaTop + 10));
    sentenceTextPainter1.paint(canvas, Offset(textBackgroundX + textBackgroundWidth - 20 - sentenceTextPainter1.width, textAreaTop + 30));
    
    // 绘制第二处文字（在第一处文字下方）
    if (dateText2.isNotEmpty || sentenceText2.isNotEmpty) {
      // 调整文字2的位置，确保显示在合适的位置
      double text2Top = textAreaTop + 50;
      if (dateText2.isNotEmpty) {
        dateTextPainter2.paint(canvas, Offset(textBackgroundX + 20, text2Top));
        text2Top += 20;
      }
      if (sentenceText2.isNotEmpty) {
        sentenceTextPainter2.paint(canvas, Offset(textBackgroundX + textBackgroundWidth - 20 - sentenceTextPainter2.width, text2Top));
      }
    }
    
    // 绘制图片
    final Rect originalImageRect = _calculateImageRect(image, 0, textHeight, canvasWidth, imageHeight);
    
    // 保存当前画布状态
    canvas.save();
    
    // 应用翻转效果 - 严格围绕图像几何中心进行
    _applyFlip(canvas, originalImageRect, flipHorizontal, flipVertical);
    
    // 应用裁剪位置、缩放和旋转
    if (croppedImagePosition != null || rotation != 0 || croppedImageScale != 1.0) {
      // 计算图片中心点
      final Offset center = Offset(originalImageRect.width / 2, originalImageRect.height / 2);
      
      // 应用位置偏移
      canvas.translate(croppedImagePosition?.dx ?? 0, croppedImagePosition?.dy ?? 0);
      
      // 移动到中心点
      canvas.translate(center.dx, center.dy);
      
      // 应用旋转
      if (rotation != 0) {
        canvas.rotate(rotation);
      }
      
      // 应用缩放
      canvas.scale(croppedImageScale);
      
      // 移回中心点
      canvas.translate(-center.dx, -center.dy);
    }
    
    // 绘制图片
    final sourceRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    canvas.drawImageRect(
      image,
      sourceRect,
      originalImageRect,
      Paint(),
    );
    
    // 恢复画布状态
    canvas.restore();
    
    // 重新保存画布状态以应用调整
    canvas.save();
    
    // 应用图片调整
    _applyImageAdjustments(canvas, canvasWidth.toInt(), imageHeight.toInt(), brightness, contrast, saturation, temperature, fade, vignette, blur, grain, sharpness, filterName, filterStrength);
    
    // 恢复画布状态
    canvas.restore();
  }
  
  // 绘制pattern_3布局（顶部图片 + 底部居中大标题）
  static void _drawPattern3Layout(Canvas canvas, ui.Image image, String dateText, String sentenceText, String dateText2, String sentenceText2, double canvasWidth, double canvasHeight, double brightness, double contrast, double saturation, double temperature, double fade, double vignette, double blur, double grain, double sharpness, String? filterName, double filterStrength, Offset? croppedImagePosition, double croppedImageScale, String textFont, String textFont2, String textPosition, String textPosition2, double textSize, double textSize2, bool flipHorizontal, bool flipVertical, [double rotation = 0.0]) {
    // 设置图像与文字占比为5.5:1
    double imageHeight = canvasHeight * 5.5 / 6.5; // 图片占5.5/6.5
    double textHeight = canvasHeight * 1 / 6.5; // 文字占1/6.5
    
    // 绘制图片
    final Rect originalImageRect = _calculateImageRect(image, 0, 0, canvasWidth, imageHeight);
    
    // 保存当前画布状态
    canvas.save();
    
    // 应用翻转效果 - 严格围绕图像几何中心进行
    _applyFlip(canvas, originalImageRect, flipHorizontal, flipVertical);
    
    // 应用裁剪位置、缩放和旋转
    if (croppedImagePosition != null || rotation != 0 || croppedImageScale != 1.0) {
      // 计算图片中心点
      final Offset center = Offset(originalImageRect.width / 2, originalImageRect.height / 2);
      
      // 应用位置偏移
      canvas.translate(croppedImagePosition?.dx ?? 0, croppedImagePosition?.dy ?? 0);
      
      // 移动到中心点
      canvas.translate(center.dx, center.dy);
      
      // 应用旋转
      if (rotation != 0) {
        canvas.rotate(rotation);
      }
      
      // 应用缩放
      canvas.scale(croppedImageScale);
      
      // 移回中心点
      canvas.translate(-center.dx, -center.dy);
    }
    
    // 绘制图片
    final sourceRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    canvas.drawImageRect(
      image,
      sourceRect,
      originalImageRect,
      Paint(),
    );
    
    // 恢复画布状态
    canvas.restore();
    
    // 重新保存画布状态以应用调整
    canvas.save();
    
    // 应用图片调整
    _applyImageAdjustments(canvas, canvasWidth.toInt(), imageHeight.toInt(), brightness, contrast, saturation, temperature, fade, vignette, blur, grain, sharpness, filterName, filterStrength);
    
    // 恢复画布状态
    canvas.restore();
    
    // 绘制短句文字（居中大标题）
    final double textAreaTop = imageHeight;
    final double textAreaWidth = canvasWidth - 40.0;
    
    // 获取字体家族
    final fontFamily1 = textFont != 'default' ? textFont : 'Roboto';
    final fontFamily2 = textFont2 != 'default' ? textFont2 : 'Roboto';
    
    // 绘制第一处文字（居中大标题）
    final sentenceTextPainter1 = TextPainter(
      text: TextSpan(
        text: sentenceText,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize * 1.2, // 标题稍微大一点
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily1,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制第二处文字（居中大标题）
    final sentenceTextPainter2 = TextPainter(
      text: TextSpan(
        text: sentenceText2,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize2 * 1.2, // 标题稍微大一点
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily2,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制文字区域背景，使用整个画布宽度
    final textBackgroundWidth = canvasWidth;
    final textBackgroundX = 0.0;
    
    canvas.drawRect(
      Rect.fromLTWH(textBackgroundX, imageHeight, textBackgroundWidth, textHeight),
      Paint()..color = Color(0xFFF8F5F0),
    );
    
    // 绘制第一处文字
    sentenceTextPainter1.paint(canvas, Offset((canvasWidth - sentenceTextPainter1.width) / 2, textAreaTop + 10));
    
    // 绘制第二处文字（在第一处文字下方）
    if (sentenceText2.isNotEmpty) {
      sentenceTextPainter2.paint(canvas, Offset((canvasWidth - sentenceTextPainter2.width) / 2, textAreaTop + 50));
    }
  }
  
  // 绘制pattern_4布局（顶部图片 + 居中文字）
  static void _drawPattern4Layout(Canvas canvas, ui.Image image, String dateText, String sentenceText, String dateText2, String sentenceText2, double canvasWidth, double canvasHeight, double brightness, double contrast, double saturation, double temperature, double fade, double vignette, double blur, double grain, double sharpness, String? filterName, double filterStrength, Offset? croppedImagePosition, double croppedImageScale, String textFont, String textFont2, String textPosition, String textPosition2, double textSize, double textSize2, bool flipHorizontal, bool flipVertical, [double rotation = 0.0]) {
    // 设置图像与文字占比为5.5:1
    double imageHeight = canvasHeight * 5.5 / 6.5; // 图片占5.5/6.5
    double textHeight = canvasHeight * 1 / 6.5; // 文字占1/6.5
    
    // 绘制图片
    final Rect originalImageRect = _calculateImageRect(image, 0, 0, canvasWidth, imageHeight);
    
    // 保存当前画布状态
    canvas.save();
    
    // 应用翻转效果 - 严格围绕图像几何中心进行
    _applyFlip(canvas, originalImageRect, flipHorizontal, flipVertical);
    
    // 应用裁剪位置、缩放和旋转
    if (croppedImagePosition != null || rotation != 0 || croppedImageScale != 1.0) {
      // 计算图片中心点
      final Offset center = Offset(originalImageRect.width / 2, originalImageRect.height / 2);
      
      // 应用位置偏移
      canvas.translate(croppedImagePosition?.dx ?? 0, croppedImagePosition?.dy ?? 0);
      
      // 移动到中心点
      canvas.translate(center.dx, center.dy);
      
      // 应用旋转
      if (rotation != 0) {
        canvas.rotate(rotation);
      }
      
      // 应用缩放
      canvas.scale(croppedImageScale);
      
      // 移回中心点
      canvas.translate(-center.dx, -center.dy);
    }
    
    // 绘制图片
    final sourceRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    canvas.drawImageRect(
      image,
      sourceRect,
      originalImageRect,
      Paint(),
    );
    
    // 恢复画布状态
    canvas.restore();
    
    // 重新保存画布状态以应用调整
    canvas.save();
    
    // 应用图片调整
    _applyImageAdjustments(canvas, canvasWidth.toInt(), imageHeight.toInt(), brightness, contrast, saturation, temperature, fade, vignette, blur, grain, sharpness, filterName, filterStrength);
    
    // 恢复画布状态
    canvas.restore();
    
    // 绘制文字（居中）
    final double textAreaTop = imageHeight;
    final double textAreaWidth = canvasWidth - 40.0;
    
    // 获取字体家族
    final fontFamily1 = textFont != 'default' ? textFont : 'Roboto';
    final fontFamily2 = textFont2 != 'default' ? textFont2 : 'Roboto';
    
    // 绘制日期文字（居中） - 第一处文字
    final dateTextPainter1 = TextPainter(
      text: TextSpan(
        text: dateText,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize * 0.75,
          fontFamily: fontFamily1,
          fontWeight: FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制短句文字（居中） - 第一处文字
    final sentenceTextPainter1 = TextPainter(
      text: TextSpan(
        text: sentenceText,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize,
          fontFamily: fontFamily1,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制日期文字（居中） - 第二处文字
    final dateTextPainter2 = TextPainter(
      text: TextSpan(
        text: dateText2,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize2 * 0.75,
          fontFamily: fontFamily2,
          fontWeight: FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制短句文字（居中） - 第二处文字
    final sentenceTextPainter2 = TextPainter(
      text: TextSpan(
        text: sentenceText2,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize2,
          fontFamily: fontFamily2,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制文字区域背景，使用整个画布宽度
    final textBackgroundWidth = canvasWidth;
    final textBackgroundX = 0.0;
    
    canvas.drawRect(
      Rect.fromLTWH(textBackgroundX, imageHeight, textBackgroundWidth, textHeight),
      Paint()..color = Color(0xFFF8F5F0),
    );
    
    // 绘制第一处文字
    dateTextPainter1.paint(canvas, Offset((canvasWidth - dateTextPainter1.width) / 2, textAreaTop + 10));
    sentenceTextPainter1.paint(canvas, Offset((canvasWidth - sentenceTextPainter1.width) / 2, textAreaTop + 30));
    
    // 绘制第二处文字（在第一处文字下方）
    if (dateText2.isNotEmpty || sentenceText2.isNotEmpty) {
      // 调整文字2的位置，确保显示在合适的位置
      double text2Top = textAreaTop + 50;
      if (dateText2.isNotEmpty) {
        dateTextPainter2.paint(canvas, Offset((canvasWidth - dateTextPainter2.width) / 2, text2Top));
        text2Top += 20;
      }
      if (sentenceText2.isNotEmpty) {
        sentenceTextPainter2.paint(canvas, Offset((canvasWidth - sentenceTextPainter2.width) / 2, text2Top));
      }
    }
  }
  
  // 绘制pattern_5布局（顶部大标题 + 底部文字 + 底部图片）
  static void _drawPattern5Layout(Canvas canvas, ui.Image image, String dateText, String sentenceText, String dateText2, String sentenceText2, double canvasWidth, double canvasHeight, double brightness, double contrast, double saturation, double temperature, double fade, double vignette, double blur, double grain, double sharpness, String? filterName, double filterStrength, Offset? croppedImagePosition, double croppedImageScale, String textFont, String textFont2, String textPosition, String textPosition2, double textSize, double textSize2, bool flipHorizontal, bool flipVertical, [double rotation = 0.0]) {
    // 设置图像与文字占比为5.5:1
    double textHeight = canvasHeight * 1 / 6.5; // 文字占1/6.5
    double imageHeight = canvasHeight * 5.5 / 6.5; // 图片占5.5/6.5
    
    // 绘制短句文字（居中大标题）
    final double textAreaTop = 0.0;
    final double textAreaWidth = canvasWidth - 40.0;
    
    // 获取字体家族
    final fontFamily1 = textFont != 'default' ? textFont : 'Roboto';
    final fontFamily2 = textFont2 != 'default' ? textFont2 : 'Roboto';
    
    // 绘制第一处文字 - 短句（居中大标题）
    final sentenceTextPainter1 = TextPainter(
      text: TextSpan(
        text: sentenceText,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize * 1.2, // 标题稍微大一点
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily1,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制第一处文字 - 日期（右侧）
    final dateTextPainter1 = TextPainter(
      text: TextSpan(
        text: dateText,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize * 0.75,
          fontFamily: fontFamily1,
          fontWeight: FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制第二处文字 - 短句（居中大标题）
    final sentenceTextPainter2 = TextPainter(
      text: TextSpan(
        text: sentenceText2,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize2 * 1.2, // 标题稍微大一点
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily2,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制第二处文字 - 日期（右侧）
    final dateTextPainter2 = TextPainter(
      text: TextSpan(
        text: dateText2,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: textSize2 * 0.75,
          fontFamily: fontFamily2,
          fontWeight: FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    )..layout(maxWidth: textAreaWidth);
    
    // 绘制文字区域背景，使用整个画布宽度
    final textBackgroundWidth = canvasWidth;
    final textBackgroundX = 0.0;
    
    canvas.drawRect(
      Rect.fromLTWH(textBackgroundX, 0, textBackgroundWidth, textHeight),
      Paint()..color = Color(0xFFF8F5F0),
    );
    
    // 绘制第一处文字
    sentenceTextPainter1.paint(canvas, Offset((canvasWidth - sentenceTextPainter1.width) / 2, textAreaTop + 10));
    dateTextPainter1.paint(canvas, Offset(textBackgroundX + textBackgroundWidth - 20 - dateTextPainter1.width, textAreaTop + 35));
    
    // 绘制第二处文字（在第一处文字下方）
    if (sentenceText2.isNotEmpty || dateText2.isNotEmpty) {
      // 调整文字2的位置，确保显示在合适的位置
      double text2Top = textAreaTop + 50;
      if (sentenceText2.isNotEmpty) {
        sentenceTextPainter2.paint(canvas, Offset((canvasWidth - sentenceTextPainter2.width) / 2, text2Top));
        text2Top += 25;
      }
      if (dateText2.isNotEmpty) {
        dateTextPainter2.paint(canvas, Offset(textBackgroundX + textBackgroundWidth - 20 - dateTextPainter2.width, text2Top));
      }
    }
    
    // 绘制图片
    final Rect originalImageRect = _calculateImageRect(image, 0, textHeight, canvasWidth, imageHeight);
    
    // 保存当前画布状态
    canvas.save();
    
    // 应用翻转效果 - 严格围绕图像几何中心进行
    _applyFlip(canvas, originalImageRect, flipHorizontal, flipVertical);
    
    // 应用裁剪位置、缩放和旋转
    if (croppedImagePosition != null || rotation != 0 || croppedImageScale != 1.0) {
      // 计算图片中心点
      final Offset center = Offset(originalImageRect.width / 2, originalImageRect.height / 2);
      
      // 应用位置偏移
      canvas.translate(croppedImagePosition?.dx ?? 0, croppedImagePosition?.dy ?? 0);
      
      // 移动到中心点
      canvas.translate(center.dx, center.dy);
      
      // 应用旋转
      if (rotation != 0) {
        canvas.rotate(rotation);
      }
      
      // 应用缩放
      canvas.scale(croppedImageScale);
      
      // 移回中心点
      canvas.translate(-center.dx, -center.dy);
    }
    
    // 绘制图片
    final sourceRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    canvas.drawImageRect(
      image,
      sourceRect,
      originalImageRect,
      Paint(),
    );
    
    // 恢复画布状态
    canvas.restore();
    
    // 重新保存画布状态以应用调整
    canvas.save();
    
    // 应用图片调整
    _applyImageAdjustments(canvas, canvasWidth.toInt(), imageHeight.toInt(), brightness, contrast, saturation, temperature, fade, vignette, blur, grain, sharpness, filterName, filterStrength);
    
    // 恢复画布状态
    canvas.restore();
  }

  // 从资源加载图片
  static Future<ui.Image?> _loadImageFromAsset(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      return await _loadImageFromBytes(bytes);
    } catch (e) {
      print('加载资源图片失败: $e');
      // 返回null而不是抛出异常，让调用者处理
      return null;
    }
  }

  // 从文件加载图片
  static Future<ui.Image?> _loadImageFromFile(File file) async {
    try {
      final Uint8List bytes = await file.readAsBytes();
      return await _loadImageFromBytes(bytes);
    } catch (e) {
      print('加载图片失败: $e');
      // 返回null而不是抛出异常，让调用者处理
      return null;
    }
  }

  // 从字节数据加载图片
  static Future<ui.Image?> _loadImageFromBytes(Uint8List bytes) async {
    final Completer<ui.Image?> completer = Completer();
    
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });
    
    try {
      return await completer.future;
    } catch (e) {
      print('解码图片失败: $e');
      return null;
    }
  }

  // 计算保持宽高比的图片显示区域
  static Rect _calculateImageRect(ui.Image image, double left, double top, double width, double height) {
    final double imageAspectRatio = image.width / image.height;
    final double containerAspectRatio = width / height;
    
    double scaledWidth = width;
    double scaledHeight = height;
    double offsetX = 0;
    double offsetY = 0;
    
    if (imageAspectRatio > containerAspectRatio) {
      // 图片比容器更宽，以宽度为基准缩放
      scaledHeight = width / imageAspectRatio;
      offsetY = (height - scaledHeight) / 2;
    } else {
      // 图片比容器更高，以高度为基准缩放
      scaledWidth = height * imageAspectRatio;
      offsetX = (width - scaledWidth) / 2;
    }
    
    return Rect.fromLTWH(left + offsetX, top + offsetY, scaledWidth, scaledHeight);
  }

  // 绘制文字背景
  static void _drawTextBackground(Canvas canvas, int width, int height) {
    final Paint paint = Paint()
      ..color = Color(0xCCF8F5F0); // 半透明的米白色
    
    canvas.drawRect(Rect.fromLTWH(0, height - 80.0, width.toDouble(), 80.0), paint);
  }

  // 绘制日期文字
  static void _drawDateText(Canvas canvas, String text, int width, int height) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: 16,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: width.toDouble() - 40);
    
    textPainter.paint(canvas, Offset(20, height - 60));
  }

  // 绘制短句文字
  static void _drawSentenceText(Canvas canvas, String text, int width, int height) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: 18,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
    )..layout(maxWidth: width.toDouble() - 40);
    
    textPainter.paint(canvas, Offset(width - 20 - textPainter.width, height - 30));
  }

  // 根据模板ID绘制文字
  static void _drawTextByTemplate(Canvas canvas, String templateId, String dateText, String sentenceText, int imageWidth, int imageHeight, double canvasHeight, String textDirection) {
    // 根据不同模板ID绘制文字在不同位置，与编辑界面中的布局一致
    switch (templateId) {
      case 'pattern_1':
        // 经典布局（顶部图片 + 底部文字）
        _drawBottomText(canvas, dateText, sentenceText, imageWidth, imageHeight, textDirection);
        break;
      case 'pattern_2':
        // 文字优先（顶部文字 + 底部图片）
        _drawTopText(canvas, dateText, sentenceText, imageWidth, imageHeight, textDirection: textDirection);
        break;
      case 'pattern_3':
        // 图片为主（顶部图片 + 底部居中大标题）
        _drawBottomCenteredText(canvas, dateText, sentenceText, imageWidth, imageHeight, showDate: false, isTitle: true, textDirection: textDirection);
        break;
      case 'pattern_4':
        // 居中布局（顶部图片 + 居中文字）
        _drawBottomCenteredText(canvas, dateText, sentenceText, imageWidth, imageHeight, textDirection: textDirection);
        break;
      case 'pattern_5':
        // 标题突出（顶部大标题 + 底部文字 + 底部图片）
        _drawTopText(canvas, dateText, sentenceText, imageWidth, imageHeight, isTitle: true, textDirection: textDirection);
        break;
      default:
        // 默认布局
        _drawBottomText(canvas, dateText, sentenceText, imageWidth, imageHeight, textDirection);
        break;
    }
  }
  
  // 绘制底部文字
  static void _drawBottomText(Canvas canvas, String dateText, String sentenceText, int imageWidth, int imageHeight, String textDirection) {
    // 在图片底部绘制文字
    final textAreaTop = imageHeight.toDouble() - 80; // 从图片底部向上留出80像素的空间
    
    // 确保文字区域有足够的空间
    if (textAreaTop > 0) {
      if (textDirection == 'horizontal') {
        // 绘制日期文字（左侧）
        final dateTextPainter = TextPainter(
          text: TextSpan(
            text: dateText,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal,
            ),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
        )..layout(maxWidth: imageWidth.toDouble() - 40);
        
        dateTextPainter.paint(canvas, Offset(20, textAreaTop + 15));
        
        // 绘制短句文字（右侧）
        final sentenceTextPainter = TextPainter(
          text: TextSpan(
            text: sentenceText,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
        )..layout(maxWidth: imageWidth.toDouble() - 40);
        
        sentenceTextPainter.paint(canvas, Offset(imageWidth - 20 - sentenceTextPainter.width, textAreaTop + 40));
      } else {
        // 竖排文字
        final dateTextPainter = TextPainter(
          text: TextSpan(
            text: dateText,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal,
            ),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
        )..layout(maxWidth: 30); // 竖排文字宽度限制
        
        final sentenceTextPainter = TextPainter(
          text: TextSpan(
            text: sentenceText,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
        )..layout(maxWidth: 30); // 竖排文字宽度限制
        
        // 保存画布状态
        canvas.save();
        
        // 绘制日期文字（左侧竖排）
        canvas.translate(20, textAreaTop + 15);
        canvas.rotate(-90 * 3.14159265359 / 180); // 旋转90度
        dateTextPainter.paint(canvas, Offset(0, 0));
        canvas.restore();
        
        // 绘制短句文字（右侧竖排）
        canvas.save();
        canvas.translate(imageWidth - 20, textAreaTop + 40);
        canvas.rotate(-90 * 3.14159265359 / 180); // 旋转90度
        sentenceTextPainter.paint(canvas, Offset(0, 0));
        canvas.restore();
      }
    }
  }
  
  // 绘制顶部文字
  static void _drawTopText(Canvas canvas, String dateText, String sentenceText, int imageWidth, int imageHeight, {bool isTitle = false, String textDirection = 'horizontal'}) {
    // 在图片顶部绘制文字
    final textAreaTop = 20.0; // 从图片顶部向下留出20像素的空间
    final textAreaHeight = 80.0;
    
    // 确保文字区域有足够的空间
    if (textAreaTop + textAreaHeight < imageHeight) {
      if (isTitle) {
        if (textDirection == 'horizontal') {
          // 标题样式（横排）
          final sentenceTextPainter = TextPainter(
            text: TextSpan(
              text: sentenceText,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          )..layout(maxWidth: imageWidth.toDouble() - 40);
          
          sentenceTextPainter.paint(canvas, Offset((imageWidth - sentenceTextPainter.width) / 2, textAreaTop + 10));
          
          // 绘制日期文字（右侧）
          final dateTextPainter = TextPainter(
            text: TextSpan(
              text: dateText,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 12,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.normal,
              ),
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.right,
          )..layout(maxWidth: imageWidth.toDouble() - 40);
          
          dateTextPainter.paint(canvas, Offset(imageWidth - 20 - dateTextPainter.width, textAreaTop + 45));
        } else {
          // 标题样式（竖排）
          final sentenceTextPainter = TextPainter(
            text: TextSpan(
              text: sentenceText,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
          )..layout(maxWidth: 30); // 竖排文字宽度限制
          
          // 绘制标题文字（左侧竖排）
          canvas.save();
          canvas.translate(40, textAreaTop + 10);
          canvas.rotate(-90 * 3.14159265359 / 180); // 旋转90度
          sentenceTextPainter.paint(canvas, Offset(0, 0));
          canvas.restore();
          
          // 绘制日期文字（右侧竖排）
          final dateTextPainter = TextPainter(
            text: TextSpan(
              text: dateText,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 12,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.normal,
              ),
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
          )..layout(maxWidth: 30); // 竖排文字宽度限制
          
          canvas.save();
          canvas.translate(imageWidth - 40, textAreaTop + 10);
          canvas.rotate(-90 * 3.14159265359 / 180); // 旋转90度
          dateTextPainter.paint(canvas, Offset(0, 0));
          canvas.restore();
        }
      } else {
        if (textDirection == 'horizontal') {
          // 普通样式（横排）
          // 绘制日期文字（左侧）
          final dateTextPainter = TextPainter(
            text: TextSpan(
              text: dateText,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.normal,
              ),
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
          )..layout(maxWidth: imageWidth.toDouble() - 40);
          
          dateTextPainter.paint(canvas, Offset(20, textAreaTop + 15));
          
          // 绘制短句文字（右侧）
          final sentenceTextPainter = TextPainter(
            text: TextSpan(
              text: sentenceText,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          )..layout(maxWidth: imageWidth.toDouble() - 40);
          
          sentenceTextPainter.paint(canvas, Offset(imageWidth - 20 - sentenceTextPainter.width, textAreaTop + 40));
        } else {
          // 普通样式（竖排）
          final dateTextPainter = TextPainter(
            text: TextSpan(
              text: dateText,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.normal,
              ),
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
          )..layout(maxWidth: 30); // 竖排文字宽度限制
          
          final sentenceTextPainter = TextPainter(
            text: TextSpan(
              text: sentenceText,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
          )..layout(maxWidth: 30); // 竖排文字宽度限制
          
          // 绘制日期文字（左侧竖排）
          canvas.save();
          canvas.translate(20, textAreaTop + 15);
          canvas.rotate(-90 * 3.14159265359 / 180); // 旋转90度
          dateTextPainter.paint(canvas, Offset(0, 0));
          canvas.restore();
          
          // 绘制短句文字（右侧竖排）
          canvas.save();
          canvas.translate(imageWidth - 20, textAreaTop + 40);
          canvas.rotate(-90 * 3.14159265359 / 180); // 旋转90度
          sentenceTextPainter.paint(canvas, Offset(0, 0));
          canvas.restore();
        }
      }
    }
  }
  
  // 绘制底部居中文字
  static void _drawBottomCenteredText(Canvas canvas, String dateText, String sentenceText, int imageWidth, int imageHeight, {bool showDate = true, bool isTitle = false, String textDirection = 'horizontal'}) {
    // 在图片底部绘制居中文字
    final textAreaTop = imageHeight.toDouble() - 80; // 从图片底部向上留出80像素的空间
    
    // 确保文字区域有足够的空间
    if (textAreaTop > 0) {
      if (isTitle) {
        if (textDirection == 'horizontal') {
          // 标题样式（横排）
          final sentenceTextPainter = TextPainter(
            text: TextSpan(
              text: sentenceText,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 22,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          )..layout(maxWidth: imageWidth.toDouble() - 40);
          
          sentenceTextPainter.paint(canvas, Offset((imageWidth - sentenceTextPainter.width) / 2, textAreaTop + 20));
        } else {
          // 标题样式（竖排）
          final sentenceTextPainter = TextPainter(
            text: TextSpan(
              text: sentenceText,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 22,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
          )..layout(maxWidth: 30); // 竖排文字宽度限制
          
          // 绘制标题文字（居中竖排）
          canvas.save();
          canvas.translate(imageWidth / 2, textAreaTop + 20);
          canvas.rotate(-90 * 3.14159265359 / 180); // 旋转90度
          sentenceTextPainter.paint(canvas, Offset(-sentenceTextPainter.height / 2, 0));
          canvas.restore();
        }
      } else {
        if (textDirection == 'horizontal') {
          // 普通样式（横排）
          if (showDate) {
            // 绘制日期文字（居中）
            final dateTextPainter = TextPainter(
              text: TextSpan(
                text: dateText,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                ),
              ),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
            )..layout(maxWidth: imageWidth.toDouble() - 40);
            
            dateTextPainter.paint(canvas, Offset((imageWidth - dateTextPainter.width) / 2, textAreaTop + 15));
          }
          
          // 绘制短句文字（居中）
          final sentenceTextPainter = TextPainter(
            text: TextSpan(
              text: sentenceText,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          )..layout(maxWidth: imageWidth.toDouble() - 40);
          
          sentenceTextPainter.paint(canvas, Offset((imageWidth - sentenceTextPainter.width) / 2, textAreaTop + (showDate ? 40 : 20)));
        } else {
          // 普通样式（竖排）
          if (showDate) {
            // 绘制日期文字（居中竖排）
            final dateTextPainter = TextPainter(
              text: TextSpan(
                text: dateText,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                ),
              ),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
            )..layout(maxWidth: 30); // 竖排文字宽度限制
            
            // 绘制日期文字（居中竖排）
            canvas.save();
            canvas.translate(imageWidth / 2 - 40, textAreaTop + 15);
            canvas.rotate(-90 * 3.14159265359 / 180); // 旋转90度
            dateTextPainter.paint(canvas, Offset(0, 0));
            canvas.restore();
          }
          
          // 绘制短句文字（居中竖排）
          final sentenceTextPainter = TextPainter(
            text: TextSpan(
              text: sentenceText,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
          )..layout(maxWidth: 30); // 竖排文字宽度限制
          
          // 绘制短句文字（居中竖排）
          canvas.save();
          canvas.translate(imageWidth / 2 + 40, textAreaTop + 15);
          canvas.rotate(-90 * 3.14159265359 / 180); // 旋转90度
          sentenceTextPainter.paint(canvas, Offset(0, 0));
          canvas.restore();
        }
      }
    }
  }



  // 应用图片调整
  static void _applyImageAdjustments(Canvas canvas, int width, int height, 
    double brightness, double contrast, double saturation, double temperature, 
    double fade, double vignette, double blur, double grain, double sharpness,
    String? filterName,
    double filterStrength) {
    // 应用滤镜效果
    _applyFilterEffect(canvas, width, height, filterName, filterStrength);
    
    // 应用亮度调整 (exposure)
    if (brightness != 0) {
      // 线性亮度调整，与 Python 代码一致
      // factor = 1.0 + exposure
      final double factor = 1.0 + brightness;
      
      // 根据亮度值计算适当的 alpha 值
      // 对于正数亮度，使用白色叠加
      // 对于负数亮度，使用黑色叠加
      final int alpha = (brightness.abs() * 100).toInt().clamp(0, 100);
      
      final Paint brightnessPaint = Paint()
        ..color = Color.fromARGB(alpha, 
          brightness > 0 ? 255 : 0, 
          brightness > 0 ? 255 : 0, 
          brightness > 0 ? 255 : 0)
        ..blendMode = brightness > 0 ? BlendMode.lighten : BlendMode.darken;
      
      canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightnessPaint);
    }
    
    // 应用对比度调整
    if (contrast != 0) {
      // 标准对比度调整：(pixel - 128) * (1 + contrast) + 128
      // 在Flutter中，我们使用颜色混合来模拟这种效果
      final Paint contrastPaint = Paint()
        ..color = Color.fromARGB((contrast.abs() * 60).toInt(), 128, 128, 128)
        ..blendMode = contrast > 0 ? BlendMode.overlay : BlendMode.softLight;
      
      canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
    }
    
    // 应用饱和度调整
    if (saturation != 0) {
      // 饱和度调整：使用亮度公式将RGB转换为灰度，然后根据饱和度值插值
      // 在Flutter中，我们使用颜色混合来模拟这种效果
      final Paint saturationPaint = Paint()
        ..color = Color.fromARGB((saturation.abs() * 60).toInt(), 255, 128, 128)
        ..blendMode = saturation > 0 ? BlendMode.color : BlendMode.saturation;
      
      canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), saturationPaint);
    }
    
    // 应用色温调整
    if (temperature != 0) {
      // 调整蓝红通道，正值增加蓝色（冷），负值增加红色（暖）
      final double blueAdjust = temperature * 0.5;
      final double redAdjust = -temperature * 0.3;
      final double greenAdjust = -temperature * 0.2;
      
      final int alpha = (temperature.abs() * 60).toInt();
      final int red = (255 * (1.0 + redAdjust)).toInt().clamp(0, 255);
      final int green = (255 * (1.0 + greenAdjust)).toInt().clamp(0, 255);
      final int blue = (255 * (1.0 + blueAdjust)).toInt().clamp(0, 255);
      
      final Paint temperaturePaint = Paint()
        ..color = Color.fromARGB(alpha, red, green, blue)
        ..blendMode = BlendMode.overlay;
      
      canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), temperaturePaint);
    }
    
    // 应用褪色调整
    if (fade != 0) {
      // 褪色效果：减少对比度并添加暖色调
      // 1. 先减少对比度
      final double contrastReduction = -0.7 * fade;
      if (contrastReduction != 0) {
        final Paint contrastPaint = Paint()
          ..color = Color.fromARGB((contrastReduction.abs() * 50).toInt(), 128, 128, 128)
          ..blendMode = BlendMode.softLight;
        
        canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
      }
      
      // 2. 添加暖色调（轻微的黄/棕色调）
      final double tintStrength = fade * 0.3;
      final int alpha = (tintStrength * 80).toInt();
      
      final Paint fadePaint = Paint()
        ..color = Color.fromARGB(alpha, 255, 220, 180)
        ..blendMode = BlendMode.overlay;
      
      canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), fadePaint);
    }
    
    // 应用暗角调整
    if (vignette != 0) {
      // 创建径向渐变蒙版，使角落变暗
      final Gradient gradient = RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: [
          Color.fromARGB(0, 0, 0, 0),
          Color.fromARGB((vignette * 150).toInt(), 0, 0, 0),
        ],
      );
      
      final Paint vignettePaint = Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
      
      canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), vignettePaint);
    }
    
    // 应用模糊调整
    if (blur != 0) {
      // 注意：在Flutter的Canvas API中，直接应用高斯模糊需要使用ImageFilter
      // 这里我们使用简单的模拟，实际应用中可能需要更复杂的实现
      final Paint blurPaint = Paint()
        ..color = Color.fromARGB((blur * 10).toInt(), 128, 128, 128)
        ..blendMode = BlendMode.softLight;
      
      canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), blurPaint);
    }
    
    // 应用颗粒调整
    if (grain != 0) {
      // 颗粒效果：添加随机噪声
      // 注意：在Flutter中实现真正的噪声需要更复杂的方法
      // 这里我们使用简单的模拟，实际应用中可能需要使用CustomPainter和噪声算法
      final Paint grainPaint = Paint()
        ..color = Color.fromARGB((grain * 30).toInt(), 128, 128, 128)
        ..blendMode = BlendMode.overlay;
      
      canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), grainPaint);
    }
    
    // 应用锐度调整
    if (sharpness != 0) {
      // 锐度调整需要更复杂的实现
      // 这里只是简单的模拟
      final Paint sharpnessPaint = Paint()
        ..color = Color.fromARGB((sharpness.abs() * 30).toInt(), 128, 128, 128)
        ..blendMode = BlendMode.overlay;
      
      canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), sharpnessPaint);
    }
  }

  // 应用滤镜效果
  static void _applyFilterEffect(Canvas canvas, int width, int height, String? filterName, double filterStrength) {
    if (filterName == null || filterName == 'original') {
      return;
    }

    Color? baseColor;

    switch (filterName) {
      case 'amaro':
        baseColor = Color.fromARGB(30, 255, 200, 100);
        break;
      case 'antique':
        baseColor = Color.fromARGB(40, 180, 160, 140);
        break;
      case 'beauty':
        baseColor = Color.fromARGB(25, 255, 220, 200);
        break;
      case 'blackcat':
        baseColor = Color.fromARGB(50, 80, 90, 100);
        break;
      case 'brannan':
        baseColor = Color.fromARGB(40, 100, 150, 200);
        break;
      case 'brooklyn':
        baseColor = Color.fromARGB(30, 180, 200, 220);
        break;
      case 'calm':
        baseColor = Color.fromARGB(20, 200, 220, 210);
        break;
      case 'cool':
        baseColor = Color.fromARGB(30, 150, 200, 255);
        break;
      case 'crayon':
        baseColor = Color.fromARGB(40, 220, 200, 180);
        break;
      case 'earlybird':
        baseColor = Color.fromARGB(35, 255, 180, 120);
        break;
      case 'emerald':
        baseColor = Color.fromARGB(30, 150, 220, 180);
        break;
      case 'evergreen':
        baseColor = Color.fromARGB(35, 120, 180, 150);
        break;
      case 'freud':
        baseColor = Color.fromARGB(45, 180, 120, 180);
        break;
      case 'healthy':
        baseColor = Color.fromARGB(25, 220, 200, 180);
        break;
      case 'hefe':
        baseColor = Color.fromARGB(30, 240, 180, 120);
        break;
      case 'hudson':
        baseColor = Color.fromARGB(25, 180, 220, 255);
        break;
      case 'inkwell':
        baseColor = Color.fromARGB(60, 128, 128, 128);
        break;
      case 'kevin_new':
        baseColor = Color.fromARGB(25, 255, 200, 150);
        break;
      case 'latte':
        baseColor = Color.fromARGB(30, 220, 180, 140);
        break;
      case 'lomo':
        baseColor = Color.fromARGB(40, 255, 150, 100);
        break;
      case 'n1977':
        baseColor = Color.fromARGB(45, 255, 180, 120);
        break;
      case 'nashville':
        baseColor = Color.fromARGB(35, 255, 200, 150);
        break;
      case 'nostalgia':
        baseColor = Color.fromARGB(40, 180, 160, 140);
        break;
      case 'pixar':
        baseColor = Color.fromARGB(30, 255, 200, 150);
        break;
      case 'rise':
        baseColor = Color.fromARGB(30, 240, 200, 160);
        break;
      case 'romance':
        baseColor = Color.fromARGB(25, 255, 200, 220);
        break;
      case 'sakura':
        baseColor = Color.fromARGB(30, 255, 200, 220);
        break;
      case 'sierra':
        baseColor = Color.fromARGB(25, 200, 220, 200);
        break;
      case 'sketch':
        baseColor = Color.fromARGB(50, 180, 180, 180);
        break;
      case 'skinwhiten':
        baseColor = Color.fromARGB(20, 255, 255, 255);
        break;
      case 'sugar_tablets':
        baseColor = Color.fromARGB(25, 255, 220, 180);
        break;
      case 'sunrise':
        baseColor = Color.fromARGB(40, 255, 180, 120);
        break;
      case 'sunset':
        baseColor = Color.fromARGB(40, 255, 150, 100);
        break;
      case 'sutro':
        baseColor = Color.fromARGB(50, 150, 100, 100);
        break;
      case 'sweets':
        baseColor = Color.fromARGB(25, 255, 200, 180);
        break;
      case 'tender':
        baseColor = Color.fromARGB(20, 220, 200, 180);
        break;
      case 'toaster2_filter_shader':
        baseColor = Color.fromARGB(45, 255, 180, 100);
        break;
      case 'valencia':
        baseColor = Color.fromARGB(35, 255, 200, 150);
        break;
      case 'walden':
        baseColor = Color.fromARGB(30, 180, 220, 180);
        break;
      case 'warm':
        baseColor = Color.fromARGB(30, 255, 200, 150);
        break;
      case 'whitecat':
        baseColor = Color.fromARGB(30, 255, 255, 255);
        break;
      case 'xproii_filter_shader':
        baseColor = Color.fromARGB(40, 255, 150, 200);
        break;
      case 'abao':
        baseColor = Color.fromARGB(25, 255, 200, 150);
        break;
      case 'charm':
        baseColor = Color.fromARGB(25, 255, 180, 200);
        break;
      case 'elegant':
        baseColor = Color.fromARGB(20, 200, 180, 160);
        break;
      case 'fandel':
        baseColor = Color.fromARGB(30, 255, 180, 120);
        break;
      case 'floral':
        baseColor = Color.fromARGB(25, 220, 200, 220);
        break;
      case 'iris':
        baseColor = Color.fromARGB(30, 200, 180, 220);
        break;
      case 'juicy':
        baseColor = Color.fromARGB(25, 200, 255, 200);
        break;
      case 'lord_kelvin':
        baseColor = Color.fromARGB(35, 255, 180, 120);
        break;
      case 'mystical':
        baseColor = Color.fromARGB(30, 150, 180, 220);
        break;
      case 'peach':
        baseColor = Color.fromARGB(30, 255, 200, 180);
        break;
      case 'pomelo':
        baseColor = Color.fromARGB(25, 200, 255, 200);
        break;
      case 'rococo':
        baseColor = Color.fromARGB(25, 220, 180, 160);
        break;
      case 'snowy':
        baseColor = Color.fromARGB(30, 220, 240, 255);
        break;
      case 'summer':
        baseColor = Color.fromARGB(30, 255, 200, 150);
        break;
      case 'sweet':
        baseColor = Color.fromARGB(25, 255, 200, 220);
        break;
      case 'toaster':
        baseColor = Color.fromARGB(40, 255, 180, 120);
        break;
      default:
        break;
    }

    if (baseColor != null) {
      // 根据滤镜强度调整透明度
      int adjustedAlpha = (baseColor.alpha * filterStrength * 2).toInt(); // 实质上加强两倍
      Color adjustedColor = Color.fromARGB(adjustedAlpha, baseColor.red, baseColor.green, baseColor.blue);
      Paint filterPaint = Paint()
        ..color = adjustedColor
        ..blendMode = BlendMode.overlay;
      canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), filterPaint);
    }
  }
}
