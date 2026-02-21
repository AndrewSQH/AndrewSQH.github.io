import 'package:hive/hive.dart';

/// 消息模型类
/// 
/// 用于存储和管理消息数据
@HiveType(typeId: 1)
class Message {
  /// 消息ID
  @HiveField(0)
  final String id;
  
  /// 发送者ID
  @HiveField(1)
  final String senderId;
  
  /// 发送者名称
  @HiveField(2)
  final String senderName;
  
  /// 接收者ID
  @HiveField(3)
  final String receiverId;
  
  /// 接收者名称
  @HiveField(4)
  final String receiverName;
  
  /// 消息内容
  @HiveField(5)
  final String content;
  
  /// 发送时间
  @HiveField(6)
  final DateTime sentAt;
  
  /// 是否已读
  @HiveField(7)
  bool isRead;
  
  /// 消息类型
  @HiveField(8)
  final String messageType;
  
  /// 构造函数
  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.content,
    required this.sentAt,
    this.isRead = false,
    this.messageType = 'text',
  });
}

/// 消息适配器
class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 1;

  @override
  Message read(BinaryReader reader) {
    final id = reader.readString();
    final senderId = reader.readString();
    final senderName = reader.readString();
    final receiverId = reader.readString();
    final receiverName = reader.readString();
    final content = reader.readString();
    final sentAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final isRead = reader.readBool();
    final messageType = reader.readString();

    return Message(
      id: id,
      senderId: senderId,
      senderName: senderName,
      receiverId: receiverId,
      receiverName: receiverName,
      content: content,
      sentAt: sentAt,
      isRead: isRead,
      messageType: messageType,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.senderId);
    writer.writeString(obj.senderName);
    writer.writeString(obj.receiverId);
    writer.writeString(obj.receiverName);
    writer.writeString(obj.content);
    writer.writeInt(obj.sentAt.millisecondsSinceEpoch);
    writer.writeBool(obj.isRead);
    writer.writeString(obj.messageType);
  }
}
