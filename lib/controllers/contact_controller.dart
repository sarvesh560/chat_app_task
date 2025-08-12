import 'package:get/get.dart';
import '../core/fire_base_services.dart';
import '../models/contact_model.dart';

class ContactsController extends GetxController {
  final contacts = <ContactModel>[].obs;
  final isLoading = false.obs;

  late String uid;

  @override
  void onInit() {
    super.onInit();
    uid = FirebaseService.auth.currentUser!.uid;
    _subscribe();
  }

  void _subscribe() {
    FirebaseService.firestore
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .orderBy('name')
        .snapshots()
        .listen((snap) {
      contacts.value = snap.docs.map((d) => ContactModel.fromDoc(d.id, d.data())).toList();
    });
  }

  Future<void> addContact(ContactModel contact) async {
    final col = FirebaseService.firestore.collection('users').doc(uid).collection('contacts');
    final ref = col.doc();
    contact.id = ref.id;
    contact.ownerId = uid;
    await ref.set(contact.toMap());
  }

  Future<void> updateContact(ContactModel contact) async {
    await FirebaseService.firestore
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .doc(contact.id)
        .set(contact.toMap());
  }

  Future<void> deleteContact(String id) async {
    await FirebaseService.firestore.collection('users').doc(uid).collection('contacts').doc(id).delete();
  }
}
