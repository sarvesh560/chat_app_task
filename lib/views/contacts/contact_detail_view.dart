import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/contact_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_textstyles.dart';
import '../../core/app_strings.dart';
import '../../core/screen_util_helper.dart';
import '../../models/contact_model.dart';
import '../../widges/rounded_input_field_widgets.dart';

class ContactDetailView extends StatefulWidget {
  final ContactModel contact;
  const ContactDetailView({required this.contact, Key? key}) : super(key: key);

  @override
  State<ContactDetailView> createState() => _ContactDetailViewState();
}

class _ContactDetailViewState extends State<ContactDetailView> {
  late TextEditingController nameC;
  late TextEditingController emailC;
  late TextEditingController phoneC;
  late Map<String, String> customFields;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameC = TextEditingController(text: widget.contact.name);
    emailC = TextEditingController(text: widget.contact.email);
    phoneC = TextEditingController(text: widget.contact.phone);
    customFields = Map<String, String>.from(
      widget.contact.customFields.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  void _addCustomField() {
    setState(() {
      customFields[''] = '';
    });
  }

  void _updateCustomKey(String oldKey, String newKey) {
    if (newKey.isEmpty) return;
    setState(() {
      final val = customFields[oldKey] ?? '';
      customFields.remove(oldKey);
      customFields[newKey] = val;
    });
  }

  void _updateCustomValue(String key, String value) {
    setState(() {
      customFields[key] = value;
    });
  }

  void _removeCustomField(String key) {
    setState(() {
      customFields.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    final contactsC = Get.find<ContactsController>();

    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        title: Text(
          AppStrings.contactDetails,
          style: AppTextStyles.titleLarge.copyWith(fontSize: ScreenUtilHelper.fontSize(20)),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtilHelper.width(24),
            vertical: ScreenUtilHelper.height(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Card container for inputs
                Container(
                  padding: EdgeInsets.all(ScreenUtilHelper.width(24)),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(20)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: ScreenUtilHelper.scaleAll(15),
                        offset: Offset(0, ScreenUtilHelper.height(6)),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      RoundedInputField(
                        controller: nameC,
                        label: AppStrings.name,
                        icon: Icons.person,
                        validator: (v) =>
                        v == null || v.trim().isEmpty ? AppStrings.enterName : null,
                      ),
                      SizedBox(height: ScreenUtilHelper.height(18)),
                      RoundedInputField(
                        controller: emailC,
                        label: AppStrings.email,
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) =>
                        v == null || !v.contains('@') ? AppStrings.enterEmail : null,
                      ),
                      SizedBox(height: ScreenUtilHelper.height(18)),
                      RoundedInputField(
                        controller: phoneC,
                        label: AppStrings.phone,
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (v) =>
                        v == null || v.trim().isEmpty ? AppStrings.enterPhone : null,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: ScreenUtilHelper.height(30)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.customFields,
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: ScreenUtilHelper.fontSize(20),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _addCustomField,
                      icon: Icon(
                        Icons.add,
                        color: AppColors.primary,
                        size: ScreenUtilHelper.fontSize(20),
                      ),
                      label: Text(
                        AppStrings.addField,
                        style: AppTextStyles.bodyText2.copyWith(
                          color: AppColors.primary,
                          fontSize: ScreenUtilHelper.fontSize(16),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(12)),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ScreenUtilHelper.height(20)),

                // Custom fields card
                Container(
                  padding: EdgeInsets.all(ScreenUtilHelper.width(16)),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(18)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withOpacity(0.1),
                        blurRadius: ScreenUtilHelper.scaleAll(10),
                        offset: Offset(0, ScreenUtilHelper.height(4)),
                      )
                    ],
                  ),
                  child: Column(
                    children: customFields.entries.map((entry) {
                      final key = entry.key;
                      final value = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(bottom: ScreenUtilHelper.height(14)),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: RoundedInputField(
                                initialValue: key,
                                label: AppStrings.fieldName,
                                onChanged: (v) => _updateCustomKey(key, v),
                                validator: (v) =>
                                v == null || v.trim().isEmpty ? AppStrings.requiredField : null,
                              ),
                            ),
                            SizedBox(width: ScreenUtilHelper.width(12)),
                            Expanded(
                              flex: 4,
                              child: RoundedInputField(
                                initialValue: value,
                                label: AppStrings.value,
                                onChanged: (v) => _updateCustomValue(key, v),
                                validator: (v) =>
                                v == null || v.trim().isEmpty ? AppStrings.requiredField : null,
                              ),
                            ),
                            SizedBox(width: ScreenUtilHelper.width(8)),
                            GestureDetector(
                              onTap: () => _removeCustomField(key),
                              child: CircleAvatar(
                                radius: ScreenUtilHelper.radius(18),
                                backgroundColor: AppColors.danger,
                                child: Icon(
                                  Icons.close,
                                  color: AppColors.background,
                                  size: ScreenUtilHelper.fontSize(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: ScreenUtilHelper.height(40)),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: ScreenUtilHelper.height(16)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(14)),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updatedContact = widget.contact
                          ..name = nameC.text.trim()
                          ..email = emailC.text.trim()
                          ..phone = phoneC.text.trim()
                          ..customFields = customFields;
                        contactsC.updateContact(updatedContact);
                        Get.back();
                      }
                    },
                    child: Text(
                      AppStrings.updateContact,
                      style: AppTextStyles.buttonText.copyWith(
                        fontSize: ScreenUtilHelper.fontSize(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
