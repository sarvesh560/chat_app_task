import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/contact_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_textstyles.dart';
import '../../core/screen_util_helper.dart';
import '../../models/contact_model.dart';
import '../../widges/rounded_input_field_widgets.dart';

class AddContactView extends StatefulWidget {
  @override
  State<AddContactView> createState() => _AddContactViewState();
}

class _AddContactViewState extends State<AddContactView> {
  final _formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final List<MapEntry<String, String>> customFields = [];

  void _addCustomField() {
    setState(() => customFields.add(const MapEntry('', '')));
  }

  void _updateCustomKey(int index, String value) {
    customFields[index] = MapEntry(value, customFields[index].value);
  }

  void _updateCustomValue(int index, String value) {
    customFields[index] = MapEntry(customFields[index].key, value);
  }

  void _removeCustomField(int index) {
    setState(() => customFields.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {

    final contactsC = Get.find<ContactsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Add New Contact',
          style: TextStyle(fontSize: ScreenUtilHelper.fontSize(20)),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ScreenUtilHelper.width(24)),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(ScreenUtilHelper.width(24)),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: ScreenUtilHelper.scaleAll(20),
                      offset: Offset(0, ScreenUtilHelper.height(8)),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      RoundedInputField(
                        controller: nameC,
                        label: 'Name',
                        icon: Icons.person,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a name' : null,
                      ),
                      SizedBox(height: ScreenUtilHelper.height(18)),
                      RoundedInputField(
                        controller: emailC,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => v == null || !v.contains('@') ? 'Please enter a valid email' : null,
                      ),
                      SizedBox(height: ScreenUtilHelper.height(18)),
                      RoundedInputField(
                        controller: phoneC,
                        label: 'Phone',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a phone number' : null,
                      ),
                      SizedBox(height: ScreenUtilHelper.height(30)),

                      /// Custom Fields Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Custom Fields',
                            style: AppTextStyles.sectionTitle.copyWith(
                              fontSize: ScreenUtilHelper.fontSize(20),
                            ),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(12)),
                              ),
                            ),
                            icon: Icon(Icons.add, size: ScreenUtilHelper.fontSize(20)),
                            label: Text('Add Field', style: TextStyle(fontSize: ScreenUtilHelper.fontSize(16))),
                            onPressed: _addCustomField,
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtilHelper.height(18)),

                      ...customFields.asMap().entries.map((entry) {
                        int i = entry.key;
                        MapEntry<String, String> kv = entry.value;

                        return Padding(
                          padding: EdgeInsets.only(bottom: ScreenUtilHelper.height(16)),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: RoundedInputField(
                                  initialValue: kv.key,
                                  label: 'Field Name',
                                  onChanged: (v) => _updateCustomKey(i, v),
                                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                                ),
                              ),
                              SizedBox(width: ScreenUtilHelper.width(12)),
                              Expanded(
                                flex: 4,
                                child: RoundedInputField(
                                  initialValue: kv.value,
                                  label: 'Value',
                                  onChanged: (v) => _updateCustomValue(i, v),
                                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                                ),
                              ),
                              SizedBox(width: ScreenUtilHelper.width(8)),
                              GestureDetector(
                                onTap: () => _removeCustomField(i),
                                child: CircleAvatar(
                                  radius: ScreenUtilHelper.radius(18),
                                  backgroundColor: AppColors.danger,
                                  child: Icon(Icons.close, color: Colors.white, size: ScreenUtilHelper.fontSize(20)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      SizedBox(height: ScreenUtilHelper.height(30)),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppColors.primary,
                            padding: EdgeInsets.symmetric(vertical: ScreenUtilHelper.height(16)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(16)),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final customMap = Map<String, dynamic>.fromEntries(
                                customFields.where((e) => e.key.trim().isNotEmpty),
                              );

                              final newContact = ContactModel(
                                id: '',
                                name: nameC.text.trim(),
                                email: emailC.text.trim(),
                                phone: phoneC.text.trim(),
                                customFields: customMap,
                              );

                              contactsC.addContact(newContact);
                              Get.back();
                            }
                          },
                          child: Text(
                            'Save Contact',
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
            ],
          ),
        ),
      ),
    );
  }
}
