import 'dart:io';

class Postcard {
  final String id;
  final String imagePath;
  final String templateId;
  final DateTime createdAt;
  final String? dateText;
  final String? sentenceText;

  Postcard({
    required this.id,
    required this.imagePath,
    required this.templateId,
    required this.createdAt,
    this.dateText,
    this.sentenceText,
  });

  factory Postcard.fromMap(Map<String, dynamic> map) {
    return Postcard(
      id: map['id'] as String,
      imagePath: map['imagePath'] as String,
      templateId: map['templateId'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      dateText: map['dateText'] as String?,
      sentenceText: map['sentenceText'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'templateId': templateId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'dateText': dateText,
      'sentenceText': sentenceText,
    };
  }

  File get imageFile => File(imagePath);
}
