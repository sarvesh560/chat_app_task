import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/fire_base_services.dart';

class ChatController extends GetxController {
  final messageController = ''.obs;

  Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream(String chatId) {
    return FirebaseService.firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendText({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    final messageData = {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseService.firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    await FirebaseService.firestore.collection('chats').doc(chatId).set({
      'lastMessage': text.trim(),
      'lastTimestamp': FieldValue.serverTimestamp(),
      'users': [senderId, receiverId],
    }, SetOptions(merge: true));
  }
}
