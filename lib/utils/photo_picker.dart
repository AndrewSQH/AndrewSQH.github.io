import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'image_utils.dart';

class PhotoPicker {
  static final ImagePicker _picker = ImagePicker();
  
  /// 允许的图片文件扩展名
  static final List<String> allowedImageExtensions = [
    '.jpg', '.jpeg', '.png', '.gif', '.webp'
  ];

  // 从相册选择照片（移动平台）
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (pickedFile == null) return null;

      if (kIsWeb) {
        // 在Web平台上，直接返回null，因为Web不支持File对象
        return null;
      }

      // 验证文件类型
      if (!_isAllowedImageType(pickedFile.path)) {
        debugPrint('不支持的图片格式，请选择JPG、PNG、GIF或WebP格式的图片');
        return null;
      }

      final File imageFile = File(pickedFile.path);
      
      // 裁剪图片为3:4比例
      final File? croppedFile = await ImageUtils.cropImageTo3_4(imageFile);
      
      return croppedFile;
    } catch (e) {
      debugPrint('选择照片失败: $e');
      return null;
    }
  }

  // 从相册选择照片（Web平台）
  static Future<Uint8List?> pickImageFromGalleryWeb() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (pickedFile == null) return null;

      // 在Web平台上，pickedFile.path是blob URL，无法直接验证文件类型
      // 直接读取字节数据，跳过文件类型验证
      debugPrint('Web平台选择文件: ${pickedFile.path}');

      // 读取图片字节数据
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      
      return imageBytes;
    } catch (e) {
      debugPrint('Web平台选择照片失败: $e');
      return null;
    }
  }

  // 处理选中的照片（应用滤镜）
  static Future<File?> processImage(File imageFile, String filterName) async {
    try {
      // 验证文件类型
      if (!_isAllowedImageType(imageFile.path)) {
        debugPrint('不支持的图片格式，请选择JPG、PNG、GIF或WebP格式的图片');
        return null;
      }

      // 应用滤镜
      final File? filteredFile = await ImageUtils.applySpecificFilter(imageFile, filterName);
      
      return filteredFile;
    } catch (e) {
      debugPrint('处理照片失败: $e');
      return null;
    }
  }

  /// 验证文件是否为允许的图片类型
  static bool _isAllowedImageType(String filePath) {
    final String lowerPath = filePath.toLowerCase();
    
    // 检查是否为HEIC/HEIF格式（不支持）
    if (lowerPath.endsWith('.heic') || lowerPath.endsWith('.heif')) {
      debugPrint('拒绝HEIC/HEIF格式: $filePath');
      return false;
    }
    
    // 检查是否为允许的格式
    final bool isAllowed = allowedImageExtensions.any((extension) => lowerPath.endsWith(extension));
    if (!isAllowed) {
      debugPrint('拒绝不支持的格式: $filePath');
      debugPrint('允许的扩展名: $allowedImageExtensions');
    }
    return isAllowed;
  }
}
