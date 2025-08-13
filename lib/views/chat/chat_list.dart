import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/app_textstyles.dart';
import '../../core/chat_list_service.dart';
import '../../core/screen_util_helper.dart';
import '../../models/user_model.dart';
import '../../core/app_colors.dart';
import '../../core/app_strings.dart';
import '../../core/app_values.dart';
import 'chat_view.dart';
import 'users_list.dart';

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
          AppStrings.chatsTitle,
          style: TextStyle(fontSize: ScreenUtilHelper.fontSize(AppValues.fontSizeXLarge)),
        ),
        centerTitle: true,
        elevation: ScreenUtilHelper.scaleAll(AppValues.dividerThickness * 2),
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
                  AppStrings.noChatsYet,
                  style: AppTextStyles.bodyText2.copyWith(
                    fontSize: ScreenUtilHelper.fontSize(AppValues.fontSizeMedium),
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: ScreenUtilHelper.height(AppValues.paddingSmall)),
              itemCount: chats.length,
              separatorBuilder: (_, __) => Divider(
                height: ScreenUtilHelper.height(AppValues.dividerThickness),
                color: AppColors.primary.withOpacity(0.3),
                thickness: AppValues.dividerThickness,
                indent: ScreenUtilHelper.width(AppValues.paddingMedium),
                endIndent: ScreenUtilHelper.width(AppValues.paddingMedium),
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
                        title: Text(AppStrings.loading),
                      );
                    }

                    final userDoc = userSnapshot.data!;
                    final user = UserModel.fromDoc(userDoc.id, userDoc.data()!);

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ScreenUtilHelper.width(AppValues.paddingMedium),
                        vertical: ScreenUtilHelper.height(AppValues.paddingSmall),
                      ),
                      leading: CircleAvatar(
                        radius: ScreenUtilHelper.radius(AppValues.avatarRadiusLarge),
                        backgroundColor: AppColors.deepPurpleLight,
                        backgroundImage: (user.profileImage != null && user.profileImage!.isNotEmpty)
                            ? NetworkImage(user.profileImage!)
                            : null,
                        child: (user.profileImage == null || user.profileImage!.isEmpty)
                            ? Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                          style: AppTextStyles.avatarInitial.copyWith(
                            fontSize: ScreenUtilHelper.fontSize(AppValues.fontSizeXLarge),
                            color: AppColors.primary,
                          ),
                        )
                            : null,
                      ),
                      title: Text(
                        user.name,
                        style: AppTextStyles.headline6.copyWith(
                          color: Colors.black87,
                          fontSize: ScreenUtilHelper.fontSize(AppValues.fontSizeLarge),
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: ScreenUtilHelper.fontSize(AppValues.fontSizeMedium),
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
        tooltip: AppStrings.newChatTooltip,
        child: Icon(
          Icons.message,
          color: Colors.white,
          size: ScreenUtilHelper.fontSize(AppValues.fontSizeXXLarge),
        ),
      ),
    );
  }
}
