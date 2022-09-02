import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';

class ItemsRepository {
  Stream<List<CardModel>> getItemStream() {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('User is not loged in');
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .orderBy('checked')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return CardModel.fromJson(doc);
      }).toList();
    });
  }

  void changeCheckBoxValue(bool newcheckboxValue, String documentID) {
    final data = {'checked': newcheckboxValue};
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('User is not loged in');
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .doc(documentID)
        .set(data, SetOptions(merge: true));
  }

  Future<void> addNewTask(String task) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('User is not loged in');
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .add({
      'checked': false,
      'title': task,
      'type': 'card',
    });
  }

  Future<void> deleteTask({String? documentID}) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('User is not loged in');
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .doc(documentID)
        .delete();
  }

  void changeTaskText(String newTaskText, String documentID) {
    final data = {'title': newTaskText};
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('User is not loged in');
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .doc(documentID)
        .set(data, SetOptions(merge: true));
  }
}
