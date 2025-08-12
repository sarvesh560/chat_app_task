import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final String? imageUrl;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    this.imageUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'text': text,
    'imageUrl': imageUrl,
    'timestamp': Timestamp.fromDate(timestamp),
  };

  factory MessageModel.fromDoc(String id, Map<String, dynamic> map) {
    return MessageModel(
      id: id,
      senderId: map['senderId'],
      text: map['text'] ?? '',
      imageUrl: map['imageUrl'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
