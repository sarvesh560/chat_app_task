import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/contact_controller.dart';
import '../../core/screen_util_helper.dart';
import 'add_contact_view.dart';
import 'contact_detail_view.dart';

class ContactsListView extends StatelessWidget {
  const ContactsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final contactsC = Get.put(ContactsController());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'My Contacts',
          style: TextStyle(fontSize: ScreenUtilHelper.fontSize(20)),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: ScreenUtilHelper.scaleAll(4),
      ),
      body: SafeArea(
        child: Obx(() {
          if (contactsC.contacts.isEmpty) {
            return Center(
              child: Text(
                'No contacts available',
                style: TextStyle(
                  fontSize: ScreenUtilHelper.fontSize(16),
                  color: Colors.grey,
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
                margin: EdgeInsets.symmetric(vertical: ScreenUtilHelper.height(6)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(12))),
                elevation: ScreenUtilHelper.scaleAll(2),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ScreenUtilHelper.width(20),
                    vertical: ScreenUtilHelper.height(12),
                  ),
                  leading: CircleAvatar(
                    radius: ScreenUtilHelper.radius(28),
                    backgroundColor: Colors.deepPurple.shade200,
                    child: Text(
                      contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtilHelper.fontSize(24),
                      ),
                    ),
                  ),
                  title: Text(
                    contact.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtilHelper.fontSize(18),
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    contact.email,
                    style: TextStyle(color: Colors.black54),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline,
                        color: Colors.redAccent, size: ScreenUtilHelper.fontSize(28)),
                    tooltip: 'Delete Contact',
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
        heroTag: 'Add contact',
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        onPressed: () => Get.to(() => AddContactView()),
        tooltip: 'Add New Contact',
        child: Icon(Icons.add, size: ScreenUtilHelper.fontSize(30)),
      ),
    );
  }
}
