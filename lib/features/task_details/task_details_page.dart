import 'package:flutter/material.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({required this.taskModel, Key? key}) : super(key: key);

  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          taskModel.title,
        ),
      ),
      body: Column(),
    );
  }
}
