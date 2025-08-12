class ContactModel {
  String id;
  String name;
  String email;
  String phone;
  Map<String, dynamic> customFields;
  String? ownerId;

  ContactModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.customFields = const {},
    this.ownerId,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'phone': phone,
    'customFields': customFields,
    'ownerId': ownerId,
  };

  factory ContactModel.fromDoc(String id, Map<String, dynamic> map) {
    return ContactModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      customFields: Map<String, dynamic>.from(map['customFields'] ?? {}),
      ownerId: map['ownerId'],
    );
  }
}
