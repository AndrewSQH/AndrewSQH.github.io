import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// 图片缓存管理类
/// 
/// 负责管理图片的内存缓存和磁盘缓存，提高图片加载性能
class ImageCacheManager {
  /// 单例实例
  static final ImageCacheManager _instance = ImageCacheManager._internal();
  
  /// 工厂构造函数
  factory ImageCacheManager() => _instance;

  /// 内存缓存
  final Map<String, Uint8List> _memoryCache = {};
  
  /// 磁盘缓存
  final Map<String, File> _diskCache = {};
  
  /// 内存缓存时间戳
  final Map<String, DateTime> _memoryCacheTimestamps = {};
  
  /// 磁盘缓存时间戳
  final Map<String, DateTime> _diskCacheTimestamps = {};
  
  /// 最大内存缓存数量
  final int _maxMemoryCacheSize = 50;
  
  /// 最大内存缓存大小（100MB）
  final int _maxMemoryCacheBytes = 100 * 1024 * 1024;
  
  /// 最大磁盘缓存数量
  final int _maxDiskCacheSize = 100;
  
  /// 缓存过期时间
  final Duration _cacheExpiryDuration = Duration(days: 7);

  /// 私有构造函数
  ImageCacheManager._internal();

  /// 生成缓存键
  /// 
  /// [source] - 图片源路径
  /// [brightness] - 亮度调整值
  /// [contrast] - 对比度调整值
  /// [saturation] - 饱和度调整值
  /// [temperature] - 色温调整值
  /// [fade] - 褪色调整值
  /// [vignette] - 暗角调整值
  /// [blur] - 模糊调整值
  /// [grain] - 颗粒调整值
  /// [sharpness] - 锐度调整值
  /// [filterName] - 滤镜名称
  /// [rotation] - 旋转角度
  /// [flipHorizontal] - 是否水平翻转
  /// [flipVertical] - 是否垂直翻转
  /// [croppedPositionX] - 裁剪位置X坐标
  /// [croppedPositionY] - 裁剪位置Y坐标
  /// [croppedScale] - 裁剪缩放比例
  String generateCacheKey({
    required String source,
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
    double rotation = 0.0,
    bool flipHorizontal = false,
    bool flipVertical = false,
    double croppedPositionX = 0.0,
    double croppedPositionY = 0.0,
    double croppedScale = 1.0,
  }) {
    return '${source}_${brightness}_${contrast}_${saturation}_${temperature}_${fade}_${vignette}_${blur}_${grain}_${sharpness}_${filterName ?? 'none'}_${rotation}_${flipHorizontal ? 'h' : 'n'}_${flipVertical ? 'v' : 'n'}_${croppedPositionX}_${croppedPositionY}_$croppedScale';
  }

  /// 从内存缓存中获取图片
  /// 
  /// [key] - 缓存键
  /// 
  /// 返回缓存的图片字节数据，如果不存在则返回null
  Uint8List? getFromMemoryCache(String key) {
    return _memoryCache[key];
  }

  /// 从磁盘缓存中获取图片文件
  /// 
  /// [key] - 缓存键
  /// 
  /// 返回缓存的图片文件，如果不存在则返回null
  File? getFromDiskCache(String key) {
    return _diskCache[key];
  }

  /// 计算当前内存缓存大小（字节）
  /// 
  /// 返回内存缓存的总大小（字节）
  int _getMemoryCacheSizeInBytes() {
    int totalSize = 0;
    for (final bytes in _memoryCache.values) {
      totalSize += bytes.length;
    }
    return totalSize;
  }

  /// 将图片添加到内存缓存
  /// 
  /// [key] - 缓存键
  /// [imageBytes] - 图片字节数据
  void addToMemoryCache(String key, Uint8List imageBytes) {
    // 清理过期缓存
    _cleanExpiredCache();
    
    // 限制内存缓存数量和大小
    while (_memoryCache.length >= _maxMemoryCacheSize || 
           _getMemoryCacheSizeInBytes() + imageBytes.length > _maxMemoryCacheBytes) {
      // 移除最旧的缓存项
      _removeOldestCache(_memoryCache, _memoryCacheTimestamps);
    }
    
    _memoryCache[key] = imageBytes;
    _memoryCacheTimestamps[key] = DateTime.now();
  }

  /// 将图片添加到磁盘缓存
  /// 
  /// [key] - 缓存键
  /// [imageFile] - 图片文件
  void addToDiskCache(String key, File imageFile) {
    // 清理过期缓存
    _cleanExpiredCache();
    
    // 限制磁盘缓存大小
    if (_diskCache.length >= _maxDiskCacheSize) {
      // 移除最旧的缓存项
      _removeOldestCache(_diskCache, _diskCacheTimestamps);
    }
    
    _diskCache[key] = imageFile;
    _diskCacheTimestamps[key] = DateTime.now();
  }

  /// 移除最旧的缓存项
  /// 
  /// [cache] - 缓存映射
  /// [timestamps] - 时间戳映射
  void _removeOldestCache(Map<String, dynamic> cache, Map<String, DateTime> timestamps) {
    if (cache.isEmpty) return;
    
    String oldestKey = cache.keys.first;
    DateTime oldestTime = timestamps[oldestKey] ?? DateTime.now();
    
    for (final key in cache.keys) {
      final timestamp = timestamps[key];
      if (timestamp != null && timestamp.isBefore(oldestTime)) {
        oldestKey = key;
        oldestTime = timestamp;
      }
    }
    
    // 如果是磁盘缓存，需要删除文件
    if (cache == _diskCache) {
      final oldestFile = cache[oldestKey] as File?;
      if (oldestFile != null) {
        try {
          oldestFile.deleteSync();
        } catch (e) {
          print('删除缓存文件失败: $e');
        }
      }
    }
    
    cache.remove(oldestKey);
    timestamps.remove(oldestKey);
  }

  /// 清理过期缓存
  void _cleanExpiredCache() {
    final now = DateTime.now();
    
    // 清理过期的内存缓存
    final expiredMemoryKeys = _memoryCacheTimestamps.entries
        .where((entry) => now.difference(entry.value) > _cacheExpiryDuration)
        .map((entry) => entry.key)
        .toList();
    
    for (final key in expiredMemoryKeys) {
      _memoryCache.remove(key);
      _memoryCacheTimestamps.remove(key);
    }
    
    // 清理过期的磁盘缓存
    final expiredDiskKeys = _diskCacheTimestamps.entries
        .where((entry) => now.difference(entry.value) > _cacheExpiryDuration)
        .map((entry) => entry.key)
        .toList();
    
    for (final key in expiredDiskKeys) {
      final file = _diskCache[key];
      if (file != null) {
        try {
          file.deleteSync();
        } catch (e) {
          print('删除过期缓存文件失败: $e');
        }
      }
      _diskCache.remove(key);
      _diskCacheTimestamps.remove(key);
    }
  }

  /// 清除内存缓存
  void clearMemoryCache() {
    _memoryCache.clear();
    _memoryCacheTimestamps.clear();
  }

  /// 清除磁盘缓存
  void clearDiskCache() {
    for (final file in _diskCache.values) {
      try {
        file.deleteSync();
      } catch (e) {
        print('删除缓存文件失败: $e');
      }
    }
    _diskCache.clear();
    _diskCacheTimestamps.clear();
  }

  /// 清除所有缓存
  void clearAllCache() {
    clearMemoryCache();
    clearDiskCache();
  }

  /// 获取内存缓存大小
  /// 
  /// 返回内存缓存的项数
  int getMemoryCacheSize() {
    return _memoryCache.length;
  }

  /// 获取磁盘缓存大小
  /// 
  /// 返回磁盘缓存的项数
  int getDiskCacheSize() {
    return _diskCache.length;
  }

  /// 检查是否存在缓存
  /// 
  /// [key] - 缓存键
  /// 
  /// 返回是否存在缓存
  bool hasCache(String key) {
    return _memoryCache.containsKey(key) || _diskCache.containsKey(key);
  }

  /// 获取缓存统计信息
  /// 
  /// 返回缓存统计信息映射
  Map<String, dynamic> getCacheStats() {
    return {
      'memoryCacheCount': _memoryCache.length,
      'memoryCacheSizeBytes': _getMemoryCacheSizeInBytes(),
      'memoryCacheSizeMB': (_getMemoryCacheSizeInBytes() / (1024 * 1024)).toStringAsFixed(2),
      'diskCacheCount': _diskCache.length,
      'maxMemoryCacheSize': _maxMemoryCacheSize,
      'maxMemoryCacheBytes': _maxMemoryCacheBytes,
      'maxMemoryCacheMB': (_maxMemoryCacheBytes / (1024 * 1024)).toStringAsFixed(2),
      'maxDiskCacheSize': _maxDiskCacheSize,
    };
  }

  /// 打印缓存统计信息
  void printCacheStats() {
    final stats = getCacheStats();
    print('=== 图片缓存统计信息 ===');
    print('内存缓存项数: ${stats['memoryCacheCount']}');
    print('内存缓存大小: ${stats['memoryCacheSizeMB']} MB');
    print('磁盘缓存项数: ${stats['diskCacheCount']}');
    print('最大内存缓存项数: ${stats['maxMemoryCacheSize']}');
    print('最大内存缓存大小: ${stats['maxMemoryCacheMB']} MB');
    print('最大磁盘缓存项数: ${stats['maxDiskCacheSize']}');
    print('====================');
  }
}
