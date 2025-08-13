import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/contact_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_textstyles.dart';
import '../../core/app_strings.dart';
import '../../core/screen_util_helper.dart';
import 'add_contact_view.dart';
import 'contact_detail_view.dart';

class ContactsListView extends StatelessWidget {
  const ContactsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contactsC = Get.put(ContactsController());

    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        title: Text(
          AppStrings.myContacts,
          style: AppTextStyles.titleLarge.copyWith(
            fontSize: ScreenUtilHelper.fontSize(20),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: ScreenUtilHelper.scaleAll(4),
      ),
      body: SafeArea(
        child: Obx(() {
          if (contactsC.contacts.isEmpty) {
            return Center(
              child: Text(
                AppStrings.noContactsAvailable,
                style: AppTextStyles.bodyText2.copyWith(
                  fontSize: ScreenUtilHelper.fontSize(16),
                  color: AppColors.textMuted,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(ScreenUtilHelper.width(12)),
            itemCount: contactsC.contacts.length,
            itemBuilder: (context, index) {
              final contact = contactsC.contacts[index];

              return Card(
                margin: EdgeInsets.symmetric(
                  vertical: ScreenUtilHelper.height(6),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(12)),
                ),
                elevation: ScreenUtilHelper.scaleAll(2),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ScreenUtilHelper.width(20),
                    vertical: ScreenUtilHelper.height(12),
                  ),
                  leading: CircleAvatar(
                    radius: ScreenUtilHelper.radius(28),
                    backgroundColor: AppColors.deepPurpleLight,
                    child: Text(
                      contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                      style: AppTextStyles.avatarInitial.copyWith(
                        fontSize: ScreenUtilHelper.fontSize(24),
                        color: AppColors.card,
                      ),
                    ),
                  ),
                  title: Text(
                    contact.name,
                    style: AppTextStyles.listTitle.copyWith(
                      fontSize: ScreenUtilHelper.fontSize(18),
                    ),
                  ),
                  subtitle: Text(
                    contact.email,
                    style: AppTextStyles.bodyText2.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: AppColors.danger,
                      size: ScreenUtilHelper.fontSize(28),
                    ),
                    tooltip: AppStrings.deleteContact,
                    onPressed: () => contactsC.deleteContact(contact.id),
                  ),
                  onTap: () => Get.to(() => ContactDetailView(contact: contact)),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: AppStrings.addContactFabTag,
        foregroundColor: AppColors.card,
        backgroundColor: AppColors.primary,
        tooltip: AppStrings.addNewContact,
        onPressed: () => Get.to(() => AddContactView()),
        child: Icon(
          Icons.add,
          size: ScreenUtilHelper.fontSize(30),
        ),
      ),
    );
  }
}
