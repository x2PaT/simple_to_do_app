import 'package:flutter/material.dart';

Future<void> openEditTaskDialog(BuildContext context, String title,
    {required Null Function(String taskText) onTaskTextEdit}) {
  final taskController = TextEditingController(text: title);
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit task', textAlign: TextAlign.center),
      content: TextField(
        textCapitalization: TextCapitalization.words,
        onSubmitted: (value) {
          onTaskTextEdit(taskController.text);
          Navigator.pop(context);
        },
        autofocus: true,
        controller: taskController,
        decoration: const InputDecoration(hintText: 'Change task text'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (taskController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Task can not be empty',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              onTaskTextEdit(taskController.text);
              Navigator.pop(context);
            }
          },
          child: const Text('Edit'),
        )
      ],
    ),
  );
}
