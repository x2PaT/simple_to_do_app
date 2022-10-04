import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';

class ItemsRepository {
  Stream<List<TaskModel>> getItemStream() {
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
        if (doc['description'] == null) {
          print('Add description field');
          final description = {'description': ''};
          FirebaseFirestore.instance
              .collection('users')
              .doc(userID)
              .collection('items')
              .doc(doc.id)
              .set(description, SetOptions(merge: true));
        } else {}

        return TaskModel.fromJson(doc);
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

  Future<void> addNewTask(String task, String description) async {
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
      'description': description,
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

  void changeTaskTitle(String newTaskTitle, String documentID) {
    final title = {'title': newTaskTitle};
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('User is not loged in');
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .doc(documentID)
        .set(title, SetOptions(merge: true));
  }

  void changeTaskDescription(String newTaskDescription, String documentID) {
    final description = {'description': newTaskDescription};
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('User is not loged in');
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .doc(documentID)
        .set(description, SetOptions(merge: true));
  }
}
