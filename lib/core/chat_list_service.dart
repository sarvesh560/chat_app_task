import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get or create chat ID between two users
  Future<String> getOrCreateChatId(String currentUserId, String otherUserId) async {
    final chatQuery = await _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .get();

    for (var doc in chatQuery.docs) {
      final participants = List<String>.from(doc['participants']);
      if (participants.contains(otherUserId)) {
        return doc.id;
      }
    }

    final newChatRef = _firestore.collection('chats').doc();
    await newChatRef.set({
      'participants': [currentUserId, otherUserId],
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    return newChatRef.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatsForUser(String currentUserId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Helper method to get the other user ID from chat document
  String getOtherUserIdFromChat(Map<String, dynamic> chatData, String currentUserId) {
    final participants = List<String>.from(chatData['participants']);
    return participants.firstWhere((id) => id != currentUserId);
  }
}
