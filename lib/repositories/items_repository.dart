import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';

class ItemsRepository {
  Stream<List<CardModel>> getItemStream() {
    return FirebaseFirestore.instance
        .collection('items')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return CardModel.fromJson(doc);
      }).toList();
    });
  }

  void changeCheckBoxValue(bool newcheckboxValue, String documentID) {
    final data = {'checked': newcheckboxValue};
    FirebaseFirestore.instance
        .collection('items')
        .doc(documentID)
        .set(data, SetOptions(merge: true));
  }

  Future<void> addNewTask(String task) async {
    await FirebaseFirestore.instance.collection('items').add({
      'checked': false,
      'title': task,
      'type': 'card',
    });
  }

  Future<void> deleteTask({String? documentID}) {
    return FirebaseFirestore.instance
        .collection('items')
        .doc(documentID)
        .delete();
  }

  void changeTaskText(String newTaskText, String documentID) {
    final data = {'title': newTaskText};
    FirebaseFirestore.instance
        .collection('items')
        .doc(documentID)
        .set(data, SetOptions(merge: true));
  }
}
