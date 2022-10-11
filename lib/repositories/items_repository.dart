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

    Stream<List<TaskModel>> items = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return TaskModel.fromJson(doc);
      }).toList();
    });

    return items;
  }

  Stream<TaskModel> readTask(documentID) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('User is not loged in');
    }

    final data = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .doc(documentID)
        .snapshots()
        .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
        .map((doc) => TaskModel.fromJsonwithID(doc, documentID));

    return data;
  }

  Stream<Map<String, dynamic>> getOrder() {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('User is not loged in');
    }

    final order = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .snapshots()
        .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>);

    return order;
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

  void editTaskProperties(
      Map<String, dynamic> newProperties, String documentID) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('User is not loged in');
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .doc(documentID)
        .set(newProperties, SetOptions(merge: true));
  }

  Future<void> writeNewOrderToDB(List newOrder) async {
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
