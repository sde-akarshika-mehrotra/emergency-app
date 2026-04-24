import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save contact
  static Future<void> saveContact(String number) async {
    await _db.collection("contacts").add({
      "number": number,
      "createdAt": DateTime.now(),
    });
  }

  // Get contacts
  static Stream<QuerySnapshot> getContacts() {
    return _db.collection("contacts").snapshots();
  }

  // Save emergency history
  static Future<void> saveAlert(String location) async {
    await _db.collection("alerts").add({
      "location": location,
      "time": DateTime.now(),
    });
  }
}