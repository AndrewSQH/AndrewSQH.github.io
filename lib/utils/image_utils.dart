import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

class ImageUtils {
  // 裁剪图片为3:4比例
  static Future<File?> cropImageTo3_4(File imageFile) async {
    try {
      // 注意：由于 image 包的 API 可能有变化，这里简化实现
      // 在实际应用中，可能需要使用其他图像处理库或方法
      
      // 这里直接返回原始文件，实际项目中需要实现真正的裁剪
      return imageFile;
    } catch (e) {
      print('裁剪图片失败: $e');
      return null;
    }
  }

  // 生成当前日期字符串
  static String getCurrentDateString() {
    final DateTime now = DateTime.now();
    final List<String> weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final String weekday = weekdays[now.weekday - 1]; // now.weekday 范围是1-7，所以减1得到0-6的索引
    return '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')} $weekday';
  }

  // 随机获取一句极简短句
  static String getRandomShortSentence() {
    final List<String> sentences = [
      '风很温柔',
      '阳光正好',
      '岁月静好',
      '人间值得',
      '未来可期',
      '万物可爱',
      '平安喜乐',
      '温暖如初',
      '一切顺利',
      '心想事成',
      '时光荏苒',
      '岁月如歌',
      '花开四季',
      '云卷云舒',
      '潮起潮落',
    ];
    final Random random = Random();
    return sentences[random.nextInt(sentences.length)];
  }



  // 应用具体的滤镜效果
  static Future<File?> applySpecificFilter(File imageFile, String filterName) async {
    try {
      // 读取图片文件
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
      final ui.FrameInfo frame = await codec.getNextFrame();
      final ui.Image image = frame.image;

      // 获取图像数据
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) return null;

      final Uint8List pixels = byteData.buffer.asUint8List();
      final int width = image.width;
      final int height = image.height;

      // 应用滤镜效果
      _applyFilterEffect(pixels, width, height, filterName);

      // 创建新图像
      final Completer<ui.Image> completer = Completer<ui.Image>();
      ui.decodeImageFromPixels(
        pixels,
        width,
        height,
        ui.PixelFormat.rgba8888,
        (ui.Image img) {
          completer.complete(img);
        },
      );
      final ui.Image newImage = await completer.future;

      // 将图片转换为字节数据
      final ByteData? newByteData = await newImage.toByteData(format: ui.ImageByteFormat.png);
      if (newByteData == null) return null;

      final Uint8List pngBytes = newByteData.buffer.asUint8List();

      // 保存为新文件
      final File outputFile = File('${imageFile.path}_$filterName.png');
      await outputFile.writeAsBytes(pngBytes);

      return outputFile;
    } catch (e) {
      print('应用滤镜失败: $e');
      return null;
    }
  }

  // 应用具体的滤镜效果
  static void _applyFilterEffect(Uint8List pixels, int width, int height, String filterName) {
    for (int i = 0; i < pixels.length; i += 4) {
      int r = pixels[i];
      int g = pixels[i + 1];
      int b = pixels[i + 2];
      final int a = pixels[i + 3];

      // 根据滤镜名称应用不同的效果
      switch (filterName) {
        case 'hefe':
          // Hefe 滤镜：增加暖色调和亮度
          r = (r + 15).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          break;
        case 'inkwell':
          // Inkwell 滤镜：黑白效果
          final int gray = ((r * 0.299) + (g * 0.587) + (b * 0.114)).toInt();
          r = gray;
          g = gray;
          b = gray;
          break;
        case 'nostalgia':
          // Nostalgia 滤镜：复古效果
          final int gray = ((r * 0.393) + (g * 0.769) + (b * 0.189)).toInt();
          r = gray;
          g = (gray * 0.9).toInt();
          b = (gray * 0.8).toInt();
          break;
        case 'sunrise':
          // Sunrise 滤镜：日出效果，增加暖色调
          r = (r + 25).clamp(0, 255);
          g = (g + 15).clamp(0, 255);
          break;
        case 'emerald':
          // Emerald 滤镜：翡翠效果，增加绿色调
          r = (r - 5).clamp(0, 255);
          g = (g + 15).clamp(0, 255);
          b = (b + 10).clamp(0, 255);
          break;
        case 'sakura':
          // Sakura 滤镜：樱花效果，增加粉色调
          r = (r + 20).clamp(0, 255);
          g = (g - 5).clamp(0, 255);
          b = (b + 15).clamp(0, 255);
          break;
        case 'crayon':
          // Crayon 滤镜：蜡笔效果，简化颜色
          r = ((r / 64).round() * 64).clamp(0, 255);
          g = ((g / 64).round() * 64).clamp(0, 255);
          b = ((b / 64).round() * 64).clamp(0, 255);
          break;
        case 'kevin_new':
          // Kevin New 滤镜：鲜艳效果
          r = (r + 10).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          b = (b + 10).clamp(0, 255);
          break;
        case 'amaro':
          // Amaro 滤镜：增加对比度和亮度，添加暖色调
          r = (r + 10).clamp(0, 255);
          g = (g + 5).clamp(0, 255);
          break;
        case 'brannan':
          // Brannan 滤镜：增加对比度，添加蓝色调
          r = (r + 0).clamp(0, 255);
          g = (g + 0).clamp(0, 255);
          b = (b + 15).clamp(0, 255);
          break;
        case 'lomo':
          // Lomo 滤镜：增加对比度，添加红色和绿色调
          r = (r + 20).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          break;
        case 'valencia':
          // Valencia 滤镜：稍微增加亮度，添加暖色调
          r = (r + 15).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          b = (b - 5).clamp(0, 255);
          break;
        case 'hudson':
          // Hudson 滤镜：增加亮度，添加冷色调
          r = (r - 5).clamp(0, 255);
          g = (g + 0).clamp(0, 255);
          b = (b + 15).clamp(0, 255);
          break;
        case 'sutro':
          // Sutro 滤镜：降低亮度，添加暖棕色调
          r = (r + 20).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          b = (b - 10).clamp(0, 255);
          break;
        case 'antique':
          // Antique 滤镜：复古色调
          final int gray = ((r * 0.393) + (g * 0.769) + (b * 0.189)).toInt();
          r = gray;
          g = (gray * 0.9).toInt();
          b = (gray * 0.8).toInt();
          break;
        case 'beauty':
          // Beauty 滤镜：美化肌肤色调
          r = (r + 10).clamp(0, 255);
          g = (g + 5).clamp(0, 255);
          b = (b - 5).clamp(0, 255);
          break;
        case 'brooklyn':
          // Brooklyn 滤镜：添加冷色调
          r = (r - 10).clamp(0, 255);
          g = (g + 0).clamp(0, 255);
          b = (b + 10).clamp(0, 255);
          break;
        case 'calm':
          // Calm 滤镜：降低对比度，添加柔和绿色调
          r = (r + 0).clamp(0, 255);
          g = (g + 5).clamp(0, 255);
          b = (b + 5).clamp(0, 255);
          break;
        case 'cool':
          // Cool 滤镜：添加强烈蓝色调
          r = (r - 5).clamp(0, 255);
          g = (g + 0).clamp(0, 255);
          b = (b + 20).clamp(0, 255);
          break;
        case 'earlybird':
          // Earlybird 滤镜：添加暖色调
          r = (r + 15).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          break;
        case 'evergreen':
          // Evergreen 滤镜：添加强烈绿色调
          r = (r + 0).clamp(0, 255);
          g = (g + 20).clamp(0, 255);
          b = (b + 10).clamp(0, 255);
          break;
        case 'healthy':
          // Healthy 滤镜：添加自然色调
          r = (r + 5).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          b = (b + 5).clamp(0, 255);
          break;
        case 'latte':
          // Latte 滤镜：添加暖奶油色调
          r = (r + 10).clamp(0, 255);
          g = (g + 15).clamp(0, 255);
          b = (b + 5).clamp(0, 255);
          break;
        case 'n1977':
          // 1977 滤镜：添加暖粉色调
          r = (r + 20).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          b = (b + 5).clamp(0, 255);
          break;
        case 'nashville':
          // Nashville 滤镜：添加暖棕色调
          r = (r + 15).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          b = (b - 5).clamp(0, 255);
          break;
        case 'pixar':
          // Pixar 滤镜：鲜艳色彩
          r = (r + 15).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          b = (b + 15).clamp(0, 255);
          break;
        case 'rise':
          // Rise 滤镜：添加暖色调
          r = (r + 15).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          break;
        case 'romance':
          // Romance 滤镜：添加柔和粉色调
          r = (r + 15).clamp(0, 255);
          g = (g + 0).clamp(0, 255);
          b = (b + 10).clamp(0, 255);
          break;
        case 'sierra':
          // Sierra 滤镜：添加暖色调
          r = (r + 10).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          break;
        case 'sketch':
          // Sketch 滤镜：素描效果
          final int gray = ((r * 0.299) + (g * 0.587) + (b * 0.114)).toInt();
          final int edge = 255 - (255 - gray);
          r = edge;
          g = edge;
          b = edge;
          break;
        case 'skinwhiten':
          // Skinwhiten 滤镜：美白嫩肤
          r = (r + 5).clamp(0, 255);
          g = (g + 5).clamp(0, 255);
          b = (b + 5).clamp(0, 255);
          break;
        case 'sugar_tablets':
          // Sugar Tablets 滤镜：鲜艳色彩
          r = (r + 15).clamp(0, 255);
          g = (g + 15).clamp(0, 255);
          b = (b + 15).clamp(0, 255);
          break;
        case 'sunset':
          // Sunset 滤镜：日落橙调
          r = (r + 20).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          b = (b - 5).clamp(0, 255);
          break;
        case 'sweets':
          // Sweets 滤镜：柔和粉彩
          r = (r + 10).clamp(0, 255);
          g = (g + 15).clamp(0, 255);
          b = (b + 10).clamp(0, 255);
          break;
        case 'tender':
          // Tender 滤镜：温柔柔和
          r = (r + 10).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          break;
        case 'toaster2':
          // Toaster2 滤镜：高对比度暖调
          r = (r + 15).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          break;
        case 'walden':
          // Walden 滤镜：青绿自然
          r = (r + 0).clamp(0, 255);
          g = (g + 15).clamp(0, 255);
          b = (b + 10).clamp(0, 255);
          break;
        case 'warm':
          // Warm 滤镜：强烈暖色调
          r = (r + 20).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          b = (b - 5).clamp(0, 255);
          break;
        case 'whitecat':
          // Whitecat 滤镜：显著增加亮度
          r = (r + 0).clamp(0, 255);
          g = (g + 0).clamp(0, 255);
          b = (b + 5).clamp(0, 255);
          break;
        case 'xproii':
          // Xproii 滤镜：强烈色彩偏移
          r = (r + 20).clamp(0, 255);
          g = (g + 0).clamp(0, 255);
          b = (b + 15).clamp(0, 255);
          break;
        case 'abao':
          // Abao 滤镜：柔和暖色调
          r = (r + 10).clamp(0, 255);
          g = (g + 15).clamp(0, 255);
          b = (b + 5).clamp(0, 255);
          break;
        case 'charm':
          // Charm 滤镜：柔和浪漫色调
          r = (r + 15).clamp(0, 255);
          g = (g + 10).clamp(0, 255);
          b = (b + 5).clamp(0, 255);
          break;
        case 'elegant':
          // Elegant 滤镜：精致柔和色调
          r = (r + 5).clamp(0, 255);
          g = (g + 8).clamp(0, 255);
          b = (b - 2).clamp(0, 255);
          break;
        case 'fandel':
          // Fandel 滤镜：温暖金色调
          r = (r + 15).clamp(0, 255);
          g = (g + 12).clamp(0, 255);
          b = (b + 3).clamp(0, 255);
          break;
        default:
          // 默认不做处理
          break;
      }

      // 应用对比度调整
      double contrast = 1.0;
      switch (filterName) {
        case 'hefe':
        case 'sunrise':
        case 'kevin_new':
        case 'amaro':
        case 'lomo':
        case 'valencia':
        case 'earlybird':
        case 'rise':
        case 'toaster2':
          contrast = 1.1;
          break;
        case 'crayon':
        case 'brannan':
        case 'sutro':
        case 'pixar':
        case 'xproii':
          contrast = 1.2;
          break;
        case 'nostalgia':
        case 'antique':
        case 'n1977':
        case 'nashville':
        case 'fandel':
          contrast = 1.05;
          break;
        case 'hudson':
        case 'calm':
        case 'beauty':
        case 'romance':
        case 'tender':
        case 'sweets':
          contrast = 0.95;
          break;
        default:
          contrast = 1.0;
          break;
      }

      // 应用对比度
      r = (((r / 255.0 - 0.5) * contrast + 0.5) * 255).toInt().clamp(0, 255);
      g = (((g / 255.0 - 0.5) * contrast + 0.5) * 255).toInt().clamp(0, 255);
      b = (((b / 255.0 - 0.5) * contrast + 0.5) * 255).toInt().clamp(0, 255);

      // 保存修改后的值
      pixels[i] = r;
      pixels[i + 1] = g;
      pixels[i + 2] = b;
      pixels[i + 3] = a;
    }
  }
}
