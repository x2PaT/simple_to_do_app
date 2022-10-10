import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';

class ItemsRepository {
  String generateID() {
    int minRange = 0xFF0087D8;
    int maxRange = 0xFFFF87D8;
    final int randomInt = Random().nextInt((minRange - maxRange).abs() + 1) +
        min(maxRange, minRange);

    return randomInt.toRadixString(16);
  }

  Stream<List<TaskModel>> getItemStream() {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('User is not loged in');
    }

    Stream<List<TaskModel>> result = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return TaskModel.fromJson(doc);
      }).toList();
    });

    return result;
  }

  Future<List> getOrder() async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('User is not loged in');
    }

    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .get()
        .then((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>);

    return data['order'] as List;
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
    final creationTime = DateTime.now();

    if (userID == null) {
      throw Exception('User is not loged in');
    }
    final data = {
      'checked': false,
      'title': task,
      'description': description,
      'creationTime': creationTime.toString()
    };

    final newTask = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .add(data);

    await FirebaseFirestore.instance.collection('users').doc(userID).update({
      'order': FieldValue.arrayUnion([newTask.id])
    });
  }

  Future<void> deleteTask({String? documentID}) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('User is not loged in');
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .doc(documentID)
        .delete();
    await FirebaseFirestore.instance.collection('users').doc(userID).update({
      'order': FieldValue.arrayRemove([documentID])
    });
  }

  void editTaskTitle(String newTaskTitle, String documentID) {
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

  void editTaskDescription(String newTaskDescription, String documentID) {
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

  Future<void> reorderTasks(List newOrder) async {
    final data = {'order': newOrder};
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('User is not loged in');
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .set(data, SetOptions(merge: true));
  }
}
