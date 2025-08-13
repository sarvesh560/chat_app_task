import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/app_colors.dart';
import '../../core/app_textstyles.dart';
import '../../core/screen_util_helper.dart';
import '../../core/app_strings.dart';
import '../../core/app_values.dart';
import '../../models/user_model.dart';
import 'chat_view.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.usersTitle,
          style: TextStyle(fontSize: ScreenUtilHelper.fontSize(AppValues.fontSizeXLarge)),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs.where((doc) => doc.id != currentUserId).toList();

          if (users.isEmpty) {
            return Center(
              child: Text(
                AppStrings.noUsersFound,
                style: AppTextStyles.bodyText2.copyWith(
                  fontSize: ScreenUtilHelper.fontSize(AppValues.fontSizeMedium),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: ScreenUtilHelper.height(AppValues.paddingSmall)),
            itemCount: users.length,
            separatorBuilder: (_, __) => Divider(
              height: ScreenUtilHelper.height(AppValues.dividerThickness),
              color: AppColors.primary.withOpacity(0.3),
              thickness: AppValues.dividerThickness,
              indent: ScreenUtilHelper.width(AppValues.paddingMedium),
              endIndent: ScreenUtilHelper.width(AppValues.paddingMedium),
            ),
            itemBuilder: (context, index) {
              final userDoc = users[index];
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
                    chatId: '',
                    otherUserId: user.id,
                    currentUserId: currentUserId,
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
