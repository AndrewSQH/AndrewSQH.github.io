import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

// 条件导入dart:html，仅在Web平台使用
// 这样可以避免在非Web平台编译时出现错误

// 在Web平台上，导入dart:html
// 在非Web平台上，使用存根实现

// Web平台的实现文件
// lib/utils/html_utils_web.dart

// 非Web平台的实现文件
// lib/utils/html_utils_stub.dart

// 条件导入，根据平台选择不同的实现
// 避免在WebAssembly构建时导入dart:html
import 'html_utils_stub.dart' // 默认使用存根实现
    if (dart.library.html) 'html_utils_web.dart'; // 仅在Web平台使用html实现



class ExportUtils {
  // 保存图片到本地
  static Future<bool> saveImageToLocal(File imageFile) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        // 在Web平台上，无法直接保存文件
        // 可以考虑实现下载功能
        print('Web平台不支持直接保存文件');
        return true; // 返回true，确保流程继续
      }

      // 获取应用文档目录
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory imagesDir = Directory('${appDir.path}/postcards');
      
      // 确保目录存在
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      
      // 生成文件名
      final String fileName = 'postcard_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File savedFile = File('${imagesDir.path}/$fileName');
      
      // 复制文件
      await imageFile.copy(savedFile.path);
      
      print('图片已保存到: ${savedFile.path}');
      return true;
    } catch (e) {
      print('保存图片失败: $e');
      return false;
    }
  }

  // 分享图片功能已移除，仅保留保存功能
  // 如需添加分享功能，请使用 share_plus 包并取消以下注释
  /*
  static Future<bool> shareToWeChat(File imageFile) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        // 在Web平台上，使用 share_plus 的 Web 实现
        await Share.shareXFiles(
          [XFile(imageFile.path)],
          text: '分享我的明信片',
          subject: '明信片',
        );
        return true;
      }

      // 使用 share_plus 分享图片
      // 注意：在实际应用中，可能需要使用专门的微信分享插件来实现更详细的分享功能
      await Share.shareXFiles(
        [XFile(imageFile.path)],
        text: '分享我的明信片',
        subject: '明信片',
      );
      
      return true;
    } catch (e) {
      print('分享图片失败: $e');
      return false;
    }
  }
  */

  // 导出图片（只保存，不分享）
  static Future<bool> exportImage(File imageFile) async {
    try {
      // 只保存到本地，不分享
      final bool saved = await saveImageToLocal(imageFile);
      if (!saved) {
        return false;
      }
      
      return true;
    } catch (e) {
      print('导出图片失败: $e');
      return false;
    }
  }

  // Web平台导出图片
  static Future<bool> exportImageWeb(Uint8List imageBytes) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        try {
          // 尝试使用HtmlUtils实现下载功能
          final htmlUtils = HtmlUtils();
          
          // 创建Blob对象
          final blob = htmlUtils.createBlob([imageBytes], 'image/jpeg');
          // 创建下载链接
          final url = htmlUtils.createObjectUrlFromBlob(blob);
          // 创建<a>标签
          final anchor = htmlUtils.createAnchorElement(url);
          // 设置下载文件名
          htmlUtils.setAnchorDownload(anchor, 'postcard_${DateTime.now().millisecondsSinceEpoch}.jpg');
          // 触发点击事件
          htmlUtils.clickAnchor(anchor);
          // 释放URL对象
          htmlUtils.revokeObjectUrl(url);
          
          print('Web平台图片导出成功');
          return true;
        } catch (e) {
          // 如果在WebAssembly平台上，HtmlUtils会抛出UnsupportedError
          // 捕获这个错误并返回false
          print('WebAssembly平台不支持此方法: $e');
          return false;
        }
      }
      
      // 非Web平台，返回false
      print('非Web平台不支持此方法');
      return false;
    } catch (e) {
      print('Web平台导出图片失败: $e');
      return false;
    }
  }
}
