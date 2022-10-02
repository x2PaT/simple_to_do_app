class TaskModel {
  TaskModel({
    required this.id,
    required this.type,
    required this.checked,
    required this.title,
    required this.description,
  });

  final String id;
  final String type;
  final bool checked;
  final String title;
  final String description;
  TaskModel.fromJson(
    json,
  )   : id = json.id,
        type = json['type'],
        checked = json['checked'],
        title = json['title'],
        description = json['description'];
}
