import 'package:simple_to_do_app/models/text_card_model.dart';

class ItemListModel {
  ItemListModel(
    this.title,
    this.tasks,
  );
  final String title;
  final List<TaskModel> tasks;

  Map<String, dynamic> dokument = {
    //Map<String,Map<String,dynamic>>
    'title': 'title',
    'items': {
      // kolejny  Map<String,Map<String,dynamic>>
      '0': {
        // kolejny  Map<String,Map<String,dynamic>>

        'title': 'title0',
        'checked': true,
      },
      '1': {
        'title': 'title1',
        'checked': false,
      },
      '2': {
        'title': 'title2',
        'checked': false,
      },
      '3': {
        'title': 'title3',
        'checked': true,
      },
    }
  };

  ItemListModel.fromJson(json)
      : title = json['title'],
        tasks = json['items'];

  fromJsonF(Map<String, dynamic> json) {
    final title = json['title'];
    final List<TaskModel> tasks = json['items'].map((e) {
      return e.map((e) {
        TaskModel.fromJson(e);
      });
    });

    return ItemListModel(title, tasks);
  }
}
