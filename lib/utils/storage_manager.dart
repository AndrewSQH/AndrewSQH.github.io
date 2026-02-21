import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import '../models/postcard.dart';
import '../models/message.dart';

class StorageManager {
  static const String _boxName = 'postcards';
  static const String _configBoxName = 'config';
  static Box<Postcard>? _box;
  static Box? _configBox;
  static Box<Message>? _messageBox;
  static List<Postcard> _webPostcards = []; // Web平台的内存存储
  static Map<String, String> _webConfig = {}; // Web平台的配置存储
  static List<Message> _webMessages = []; // Web平台的消息存储

  // 初始化 Hive
  static Future<void> initialize() async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        // 在Web平台上，使用内存存储
        debugPrint('Web平台使用内存存储');
        _webPostcards = [];
        _webConfig = {};
        _webMessages = [];
        return;
      }

      final Directory appDir = await getApplicationDocumentsDirectory();
      Hive.init(appDir.path);
      
      // 注册适配器
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(PostcardAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(MessageAdapter());
      }
      
      // 打开盒子
      _box = await Hive.openBox<Postcard>(_boxName);
      _messageBox = await Hive.openBox<Message>('messages');
      _configBox = await Hive.openBox(_configBoxName);
    } catch (e) {
      print('初始化存储失败: $e');
    }
  }

  // 保存明信片
  static Future<void> savePostcard(Postcard postcard) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        _webPostcards.add(postcard);
        return;
      }

      if (_box == null) {
        await initialize();
      }
      await _box?.put(postcard.id, postcard);
    } catch (e) {
      print('保存明信片失败: $e');
    }
  }

  // 获取所有明信片
  static List<Postcard> getAllPostcards() {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        return _webPostcards;
      }

      if (_box == null) return [];
      return _box?.values.toList() ?? [];
    } catch (e) {
      print('获取明信片失败: $e');
      return [];
    }
  }

  // 删除明信片
  static Future<void> deletePostcard(String id) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        _webPostcards.removeWhere((postcard) => postcard.id == id);
        return;
      }

      if (_box == null) return;
      await _box?.delete(id);
    } catch (e) {
      print('删除明信片失败: $e');
    }
  }

  // 清除所有明信片
  static Future<void> clearAllPostcards() async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        _webPostcards.clear();
        return;
      }

      if (_box == null) return;
      await _box?.clear();
    } catch (e) {
      print('清除明信片失败: $e');
    }
  }

  // 清除缓存
  static Future<void> clearCache() async {
    try {
      // 清除所有明信片
      await clearAllPostcards();
      
      // 检查是否为Web平台
      if (kIsWeb) {
        _webConfig.clear();
        return;
      }

      // 删除保存的图片文件
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory imagesDir = Directory('${appDir.path}/postcards');
      
      if (await imagesDir.exists()) {
        await imagesDir.delete(recursive: true);
      }
      
      // 清除配置
      if (_configBox != null) {
        await _configBox?.clear();
      }
    } catch (e) {
      print('清除缓存失败: $e');
    }
  }

  // 获取字符串值
  static Future<String?> getString(String key) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        return _webConfig[key];
      }

      if (_configBox == null) {
        await initialize();
      }
      return _configBox?.get(key) as String?;
    } catch (e) {
      print('获取字符串失败: $e');
      return null;
    }
  }

  // 保存字符串值
  static Future<void> setString(String key, String value) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        _webConfig[key] = value;
        return;
      }

      if (_configBox == null) {
        await initialize();
      }
      await _configBox?.put(key, value);
    } catch (e) {
      print('保存字符串失败: $e');
    }
  }

  // 保存收藏的滤镜
  static Future<void> saveFavoriteFilter(String filterName) async {
    try {
      final List<String> favorites = await getFavoriteFilters();
      if (!favorites.contains(filterName)) {
        favorites.add(filterName);
        final String favoritesJson = favorites.join(',');
        await setString('favorite_filters', favoritesJson);
      }
    } catch (e) {
      print('保存收藏滤镜失败: $e');
    }
  }

  // 获取收藏的滤镜
  static Future<List<String>> getFavoriteFilters() async {
    try {
      final String? favoritesJson = await getString('favorite_filters');
      if (favoritesJson == null || favoritesJson.isEmpty) {
        return [];
      }
      return favoritesJson.split(',');
    } catch (e) {
      print('获取收藏滤镜失败: $e');
      return [];
    }
  }

  // 移除收藏的滤镜
  static Future<void> removeFavoriteFilter(String filterName) async {
    try {
      final List<String> favorites = await getFavoriteFilters();
      favorites.remove(filterName);
      final String favoritesJson = favorites.join(',');
      await setString('favorite_filters', favoritesJson);
    } catch (e) {
      print('移除收藏滤镜失败: $e');
    }
  }

  // 检查滤镜是否已收藏
  static Future<bool> isFilterFavorited(String filterName) async {
    try {
      final List<String> favorites = await getFavoriteFilters();
      return favorites.contains(filterName);
    } catch (e) {
      print('检查收藏滤镜失败: $e');
      return false;
    }
  }

  // 保存收藏的模板
  static Future<void> saveFavoriteTemplate(String templateId) async {
    try {
      final List<String> favorites = await getFavoriteTemplates();
      if (!favorites.contains(templateId)) {
        favorites.add(templateId);
        final String favoritesJson = favorites.join(',');
        await setString('favorite_templates', favoritesJson);
      }
    } catch (e) {
      print('保存收藏模板失败: $e');
    }
  }

  // 获取收藏的模板
  static Future<List<String>> getFavoriteTemplates() async {
    try {
      final String? favoritesJson = await getString('favorite_templates');
      if (favoritesJson == null || favoritesJson.isEmpty) {
        return [];
      }
      return favoritesJson.split(',');
    } catch (e) {
      print('获取收藏模板失败: $e');
      return [];
    }
  }

  // 移除收藏的模板
  static Future<void> removeFavoriteTemplate(String templateId) async {
    try {
      final List<String> favorites = await getFavoriteTemplates();
      favorites.remove(templateId);
      final String favoritesJson = favorites.join(',');
      await setString('favorite_templates', favoritesJson);
    } catch (e) {
      print('移除收藏模板失败: $e');
    }
  }

  // 检查模板是否已收藏
  static Future<bool> isTemplateFavorited(String templateId) async {
    try {
      final List<String> favorites = await getFavoriteTemplates();
      return favorites.contains(templateId);
    } catch (e) {
      print('检查收藏模板失败: $e');
      return false;
    }
  }

  // 保存消息
  static Future<void> saveMessage(Message message) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        _webMessages.add(message);
        return;
      }

      if (_messageBox == null) {
        await initialize();
      }
      await _messageBox?.put(message.id, message);
    } catch (e) {
      print('保存消息失败: $e');
    }
  }

  // 获取消息列表
  static List<Message> getMessages({String? userId}) {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        if (userId != null) {
          return _webMessages.where((message) => message.senderId == userId || message.receiverId == userId).toList();
        }
        return _webMessages;
      }

      if (_messageBox == null) return [];
      if (userId != null) {
        return _messageBox?.values.where((message) => message.senderId == userId || message.receiverId == userId).toList() ?? [];
      }
      return _messageBox?.values.toList() ?? [];
    } catch (e) {
      print('获取消息失败: $e');
      return [];
    }
  }

  // 获取与特定用户的聊天消息
  static List<Message> getChatMessages(String userId1, String userId2) {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        return _webMessages.where((message) => 
          (message.senderId == userId1 && message.receiverId == userId2) ||
          (message.senderId == userId2 && message.receiverId == userId1)
        ).toList();
      }

      if (_messageBox == null) return [];
      return _messageBox?.values.where((message) => 
        (message.senderId == userId1 && message.receiverId == userId2) ||
        (message.senderId == userId2 && message.receiverId == userId1)
      ).toList() ?? [];
    } catch (e) {
      print('获取聊天消息失败: $e');
      return [];
    }
  }

  // 标记消息为已读
  static Future<void> markMessageAsRead(String messageId) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        final message = _webMessages.firstWhere((m) => m.id == messageId);
        message.isRead = true;
        return;
      }

      if (_messageBox == null) return;
      final message = _messageBox?.get(messageId);
      if (message != null) {
        message.isRead = true;
        await _messageBox?.put(messageId, message);
      }
    } catch (e) {
      print('标记消息为已读失败: $e');
    }
  }

  // 删除消息
  static Future<void> deleteMessage(String messageId) async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        _webMessages.removeWhere((message) => message.id == messageId);
        return;
      }

      if (_messageBox == null) return;
      await _messageBox?.delete(messageId);
    } catch (e) {
      print('删除消息失败: $e');
    }
  }

  // 获取未读消息数量
  static int getUnreadMessageCount(String userId) {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        return _webMessages.where((message) => message.receiverId == userId && !message.isRead).length;
      }

      if (_messageBox == null) return 0;
      return _messageBox?.values.where((message) => message.receiverId == userId && !message.isRead).length ?? 0;
    } catch (e) {
      print('获取未读消息数量失败: $e');
      return 0;
    }
  }

  // 关闭Hive盒子
  static Future<void> close() async {
    try {
      // 检查是否为Web平台
      if (kIsWeb) {
        return;
      }

      if (_box != null && _box!.isOpen) {
        await _box?.close();
      }
      if (_messageBox != null && _messageBox!.isOpen) {
        await _messageBox?.close();
      }
      if (_configBox != null && _configBox!.isOpen) {
        await _configBox?.close();
      }
    } catch (e) {
      print('关闭存储失败: $e');
    }
  }
}
 

// Postcard 适配器
class PostcardAdapter extends TypeAdapter<Postcard> {
  @override
  final int typeId = 0;

  @override
  Postcard read(BinaryReader reader) {
    final id = reader.readString();
    final imagePath = reader.readString();
    final templateId = reader.readString();
    final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final dateText = reader.readNullableString();
    final sentenceText = reader.readNullableString();

    return Postcard(
      id: id,
      imagePath: imagePath,
      templateId: templateId,
      createdAt: createdAt,
      dateText: dateText,
      sentenceText: sentenceText,
    );
  }

  @override
  void write(BinaryWriter writer, Postcard obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.imagePath);
    writer.writeString(obj.templateId);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
    writer.writeNullableString(obj.dateText);
    writer.writeNullableString(obj.sentenceText);
  }
}

// 扩展 BinaryReader 和 BinaryWriter 以支持可空字符串
extension BinaryReaderNullable on BinaryReader {
  String? readNullableString() {
    final exists = readBool();
    if (!exists) return null;
    return readString();
  }
}

extension BinaryWriterNullable on BinaryWriter {
  void writeNullableString(String? value) {
    writeBool(value != null);
    if (value != null) {
      writeString(value);
    }
  }
}
