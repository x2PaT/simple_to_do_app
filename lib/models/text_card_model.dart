class TaskModel {
  TaskModel({
    required this.id,
    required this.checked,
    required this.title,
    required this.description,
    required this.creationTime,
  });

  final String id;
  final bool checked;
  final String title;
  final String description;
  DateTime creationTime;

  TaskModel.fromJson(json)
      : id = json.id,
        checked = json['checked'],
        title = json['title'],
        description = json['description'],
        creationTime = DateTime.parse(json['creationTime']);

  TaskModel.fromJsonwithID(json, documentID)
      : id = documentID,
        checked = json['checked'],
        title = json['title'],
        description = json['description'],
        creationTime = DateTime.parse(json['creationTime']);

  Map<String, dynamic> toJson(TaskModel model) {
    return <String, dynamic>{
      'id': model.id,
      'checked': model.checked,
      'title': model.title,
      'description': model.description,
      'creationTime': creationTime.toString(),
    };
  }
}
