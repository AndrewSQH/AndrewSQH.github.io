import 'dart:math';
import '../models/message.dart';
import '../utils/storage_manager.dart';

/// 消息服务类
/// 
/// 用于处理消息的发送和接收逻辑
class MessageService {
  /// 单例实例
  static final MessageService _instance = MessageService._internal();

  /// 工厂构造函数
  factory MessageService() => _instance;

  /// 内部构造函数
  MessageService._internal();

  /// 发送消息
  Future<void> sendMessage({
    required String senderId,
    required String senderName,
    required String receiverId,
    required String receiverName,
    required String content,
    String messageType = 'text',
  }) async {
    try {
      // 生成消息ID
      final messageId = 'msg_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';

      // 创建消息实例
      final message = Message(
        id: messageId,
        senderId: senderId,
        senderName: senderName,
        receiverId: receiverId,
        receiverName: receiverName,
        content: content,
        sentAt: DateTime.now(),
        isRead: false,
        messageType: messageType,
      );

      // 保存消息
      await StorageManager.saveMessage(message);
    } catch (e) {
      print('发送消息失败: $e');
      rethrow;
    }
  }

  /// 获取与特定用户的聊天消息
  List<Message> getChatMessages(String userId1, String userId2) {
    try {
      final messages = StorageManager.getChatMessages(userId1, userId2);
      // 按发送时间排序
      messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));
      return messages;
    } catch (e) {
      print('获取聊天消息失败: $e');
      return [];
    }
  }

  /// 标记消息为已读
  Future<void> markAsRead(String messageId) async {
    try {
      await StorageManager.markMessageAsRead(messageId);
    } catch (e) {
      print('标记消息为已读失败: $e');
    }
  }

  /// 获取未读消息数量
  int getUnreadMessageCount(String userId) {
    try {
      return StorageManager.getUnreadMessageCount(userId);
    } catch (e) {
      print('获取未读消息数量失败: $e');
      return 0;
    }
  }

  /// 获取最近的聊天列表
  List<Map<String, dynamic>> getChatList(String userId) {
    try {
      final messages = StorageManager.getMessages(userId: userId);
      
      // 按对话分组
      final chatGroups = <String, Map<String, dynamic>>{};
      
      for (final message in messages) {
        // 确定对方用户的ID和名称
        final otherUserId = message.senderId == userId ? message.receiverId : message.senderId;
        final otherUserName = message.senderId == userId ? message.receiverName : message.senderName;
        
        // 如果该对话还不存在，或者当前消息比已存在的最后消息更新
        if (!chatGroups.containsKey(otherUserId) || 
            message.sentAt.isAfter(chatGroups[otherUserId]!['lastMessage'].sentAt)) {
          // 计算未读消息数量
          final unreadCount = StorageManager.getMessages(userId: userId)
              .where((m) => m.senderId == otherUserId && !m.isRead)
              .length;
          
          chatGroups[otherUserId] = {
            'userId': otherUserId,
            'userName': otherUserName,
            'lastMessage': message,
            'unreadCount': unreadCount,
          };
        }
      }
      
      // 按最后消息时间排序
      final chatList = chatGroups.values.toList();
      chatList.sort((a, b) => b['lastMessage'].sentAt.compareTo(a['lastMessage'].sentAt));
      
      return chatList;
    } catch (e) {
      print('获取聊天列表失败: $e');
      return [];
    }
  }
}
