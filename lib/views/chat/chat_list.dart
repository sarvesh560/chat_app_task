import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task/views/chat/users_list.dart';
import '../../core/app_textstyles.dart';
import '../../core/chat_list_service.dart';
import '../../core/screen_util_helper.dart';
import '../../models/user_model.dart';
import '../../core/app_colors.dart';
import 'chat_view.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final ChatService chatService = ChatService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(fontSize: ScreenUtilHelper.fontSize(20)),
        ),
        centerTitle: true,
        elevation: ScreenUtilHelper.scaleAll(2),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: chatService.getChatsForUser(currentUserId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final chats = snapshot.data!.docs;

            if (chats.isEmpty) {
              return Center(
                child: Text(
                  'No chats yet. Start a conversation!',
                  style: AppTextStyles.bodyText2.copyWith(
                    fontSize: ScreenUtilHelper.fontSize(16),
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: ScreenUtilHelper.height(8)),
              itemCount: chats.length,
              separatorBuilder: (_, __) => Divider(
                height: ScreenUtilHelper.height(1),
                color: AppColors.primary.withOpacity(0.3),
                thickness: 1,
                indent: ScreenUtilHelper.width(16),
                endIndent: ScreenUtilHelper.width(16),
              ),
              itemBuilder: (context, index) {
                final chatDoc = chats[index];
                final chatData = chatDoc.data();
                final otherUserId = chatService.getOtherUserIdFromChat(chatData, currentUserId);

                return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return const ListTile(
                        title: Text('Loading...'),
                      );
                    }

                    final userDoc = userSnapshot.data!;
                    final user = UserModel.fromDoc(userDoc.id, userDoc.data()!);

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ScreenUtilHelper.width(16),
                        vertical: ScreenUtilHelper.height(8),
                      ),
                      leading: CircleAvatar(
                        radius: ScreenUtilHelper.radius(26),
                        backgroundColor: AppColors.deepPurpleLight,
                        backgroundImage: (user.profileImage != null && user.profileImage!.isNotEmpty)
                            ? NetworkImage(user.profileImage!)
                            : null,
                        child: (user.profileImage == null || user.profileImage!.isEmpty)
                            ? Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                          style: TextStyle(
                            fontSize: ScreenUtilHelper.fontSize(20),
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        )
                            : null,
                      ),
                      title: Text(
                        user.name,
                        style: AppTextStyles.headline6.copyWith(
                          color: Colors.black87,
                          fontSize: ScreenUtilHelper.fontSize(18),
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: ScreenUtilHelper.fontSize(20),
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Get.to(() => ChatView(
                          chatId: chatDoc.id,
                          otherUserId: user.id,
                          currentUserId: currentUserId,
                        ));
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'chatListFab',
        backgroundColor: AppColors.primary,
        onPressed: () {
          Get.to(() => const UsersListView());
        },
        tooltip: 'New Chat',
        child: Icon(
          Icons.message,
          color: Colors.white,
          size: ScreenUtilHelper.fontSize(24),
        ),
      ),
    );
  }
}
