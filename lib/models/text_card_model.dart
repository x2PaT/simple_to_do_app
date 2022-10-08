class TaskModel {
  TaskModel({
    required this.id,
    required this.checked,
    required this.title,
    required this.description,
  });

  final String id;
  final bool checked;
  final String title;
  final String description;
  TaskModel.fromJson(json)
      : id = json.id,
        checked = json['checked'],
        title = json['title'],
        description = json['description'];

  Map<String, dynamic> toJson(TaskModel model) {
    return <String, dynamic>{
      'id': model.id,
      'checked': model.checked,
      'title': model.title,
      'description': model.description,
    };
  }
}
