import 'package:flutter/material.dart';

Future<void> openAddTaskDialog(BuildContext context,
    {required Null Function(String task) onTaskTextChange}) {
  final taskController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add task', textAlign: TextAlign.center),
      content: TextField(
        textCapitalization: TextCapitalization.words,
        onSubmitted: (value) {
          onTaskTextChange(taskController.text);
          Navigator.pop(context);
        },
        autofocus: true,
        controller: taskController,
        decoration: const InputDecoration(hintText: 'Type your task'),
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
              onTaskTextChange(taskController.text);
              Navigator.pop(context);
            }
          },
          child: const Text('Submit'),
        )
      ],
    ),
  );
}
