class CardModel {
  CardModel({
    required this.id,
    required this.type,
    required this.checked,
    required this.title,
  });

  final String id;
  final String type;
  final bool checked;
  final String title;

  CardModel.fromJson(
    json,
  )   : id = json.id,
        type = json['type'],
        checked = json['checked'],
        title = json['title'];
}
