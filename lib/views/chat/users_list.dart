import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/app_textstyles.dart';
import '../../core/chat_list_service.dart';
import '../../core/screen_util_helper.dart';
import '../../models/user_model.dart';
import '../../core/app_colors.dart';
import 'chat_view.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final ChatService chatService = ChatService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Select User to Chat',
          style: TextStyle(fontSize: ScreenUtilHelper.fontSize(18)),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final users = snapshot.data!.docs.where((doc) => doc.id != currentUserId).toList();

            if (users.isEmpty) {
              return Center(
                child: Text(
                  'No other users found',
                  style: AppTextStyles.bodyText2.copyWith(
                    fontSize: ScreenUtilHelper.fontSize(14),
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: ScreenUtilHelper.height(8)),
              itemCount: users.length,
              separatorBuilder: (_, __) => Divider(
                height: ScreenUtilHelper.height(1),
                color: AppColors.primary.withOpacity(0.3),
                thickness: 1,
                indent: ScreenUtilHelper.width(16),
                endIndent: ScreenUtilHelper.width(16),
              ),
              itemBuilder: (context, index) {
                final userDoc = users[index];
                final user = UserModel.fromDoc(userDoc.id, userDoc.data()!);

                return ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ScreenUtilHelper.width(16),
                    vertical: ScreenUtilHelper.height(8),
                  ),
                  leading: CircleAvatar(
                    radius: ScreenUtilHelper.radius(26),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    backgroundImage: (user.profileImage != null && user.profileImage!.isNotEmpty)
                        ? NetworkImage(user.profileImage!)
                        : null,
                    child: (user.profileImage == null || user.profileImage!.isEmpty)
                        ? Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: AppTextStyles.avatarInitial.copyWith(
                        fontSize: ScreenUtilHelper.fontSize(18),
                      ),
                    )
                        : null,
                  ),
                  title: Text(
                    user.name,
                    style: AppTextStyles.listTitle.copyWith(
                      fontSize: ScreenUtilHelper.fontSize(16),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: ScreenUtilHelper.scaleWidth(20),
                    color: Colors.grey,
                  ),
                  onTap: () async {
                    final chatId = await chatService.getOrCreateChatId(currentUserId, user.id);

                    Get.back(); // close user list view

                    Get.to(() => ChatView(
                      chatId: chatId,
                      otherUserId: user.id,
                      currentUserId: currentUserId,
                    ));
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
