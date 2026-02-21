import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application/utils/image_cache.dart';

void main() {
  group('ImageCacheManager', () {
    late ImageCacheManager cacheManager;

    setUp(() {
      // 创建一个新的 ImageCacheManager 实例用于测试
      cacheManager = ImageCacheManager();
    });

    tearDown(() {
      // 测试完成后清除缓存
      cacheManager.clearAllCache();
    });

    test('should generate cache key correctly', () {
      // 测试缓存键生成功能
      final cacheKey = cacheManager.generateCacheKey(
        source: 'test.jpg',
        brightness: 0.2,
        contrast: -0.1,
        saturation: 0.3,
        temperature: 0.4,
        fade: 0.1,
        vignette: 0.2,
        blur: 5.0,
        grain: 0.3,
        sharpness: 0.1,
        filterName: 'amaro',
        rotation: 90.0,
        flipHorizontal: true,
        flipVertical: false,
      );

      // 验证缓存键格式正确
      expect(cacheKey, isNotEmpty);
      expect(cacheKey, contains('test.jpg'));
      expect(cacheKey, contains('amaro'));
      expect(cacheKey, contains('90.0'));
      expect(cacheKey, contains('h'));
      expect(cacheKey, contains('n'));
    });

    test('should add and retrieve from memory cache', () {
      // 测试内存缓存功能
      final testKey = 'test_memory_key';
      final testBytes = Uint8List.fromList([1, 2, 3, 4, 5]);

      // 添加到内存缓存
      cacheManager.addToMemoryCache(testKey, testBytes);

      // 从内存缓存中获取
      final retrievedBytes = cacheManager.getFromMemoryCache(testKey);

      // 验证获取到的数据正确
      expect(retrievedBytes, isNotNull);
      expect(retrievedBytes, equals(testBytes));
    });

    test('should add and retrieve from disk cache', () async {
      // 测试磁盘缓存功能
      final testKey = 'test_disk_key';
      
      // 创建一个临时文件用于测试
      final tempFile = File('${Directory.systemTemp.path}/test_cache_file.jpg');
      await tempFile.writeAsBytes(Uint8List.fromList([1, 2, 3, 4, 5]));

      // 添加到磁盘缓存
      cacheManager.addToDiskCache(testKey, tempFile);

      // 从磁盘缓存中获取
      final retrievedFile = cacheManager.getFromDiskCache(testKey);

      // 验证获取到的文件正确
      expect(retrievedFile, isNotNull);
      expect(retrievedFile?.path, equals(tempFile.path));

      // 清理临时文件
      await tempFile.delete();
    });

    test('should check if cache exists', () {
      // 测试缓存存在性检查功能
      final testKey = 'test_exists_key';
      final testBytes = Uint8List.fromList([1, 2, 3, 4, 5]);

      // 初始状态下缓存不存在
      expect(cacheManager.hasCache(testKey), isFalse);

      // 添加到内存缓存
      cacheManager.addToMemoryCache(testKey, testBytes);

      // 现在缓存应该存在
      expect(cacheManager.hasCache(testKey), isTrue);
    });

    test('should clear memory cache', () {
      // 测试清除内存缓存功能
      final testKey = 'test_clear_memory_key';
      final testBytes = Uint8List.fromList([1, 2, 3, 4, 5]);

      // 添加到内存缓存
      cacheManager.addToMemoryCache(testKey, testBytes);
      expect(cacheManager.getMemoryCacheSize(), equals(1));

      // 清除内存缓存
      cacheManager.clearMemoryCache();

      // 验证内存缓存已清空
      expect(cacheManager.getMemoryCacheSize(), equals(0));
      expect(cacheManager.getFromMemoryCache(testKey), isNull);
    });

    test('should clear disk cache', () async {
      // 测试清除磁盘缓存功能
      final testKey = 'test_clear_disk_key';
      
      // 创建一个临时文件用于测试
      final tempFile = File('${Directory.systemTemp.path}/test_cache_file.jpg');
      await tempFile.writeAsBytes(Uint8List.fromList([1, 2, 3, 4, 5]));

      // 添加到磁盘缓存
      cacheManager.addToDiskCache(testKey, tempFile);
      expect(cacheManager.getDiskCacheSize(), equals(1));

      // 清除磁盘缓存
      cacheManager.clearDiskCache();

      // 验证磁盘缓存已清空
      expect(cacheManager.getDiskCacheSize(), equals(0));
      expect(cacheManager.getFromDiskCache(testKey), isNull);

      // 清理临时文件
      if (tempFile.existsSync()) {
        await tempFile.delete();
      }
    });

    test('should clear all cache', () async {
      // 测试清除所有缓存功能
      final memoryKey = 'test_memory_all_key';
      final diskKey = 'test_disk_all_key';
      final testBytes = Uint8List.fromList([1, 2, 3, 4, 5]);

      // 创建一个临时文件用于测试
      final tempFile = File('${Directory.systemTemp.path}/test_cache_file.jpg');
      await tempFile.writeAsBytes(testBytes);

      // 添加到内存和磁盘缓存
      cacheManager.addToMemoryCache(memoryKey, testBytes);
      cacheManager.addToDiskCache(diskKey, tempFile);

      expect(cacheManager.getMemoryCacheSize(), equals(1));
      expect(cacheManager.getDiskCacheSize(), equals(1));

      // 清除所有缓存
      cacheManager.clearAllCache();

      // 验证所有缓存已清空
      expect(cacheManager.getMemoryCacheSize(), equals(0));
      expect(cacheManager.getDiskCacheSize(), equals(0));
      expect(cacheManager.getFromMemoryCache(memoryKey), isNull);
      expect(cacheManager.getFromDiskCache(diskKey), isNull);

      // 清理临时文件
      if (tempFile.existsSync()) {
        await tempFile.delete();
      }
    });
  });
}
