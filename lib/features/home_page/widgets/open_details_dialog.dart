import 'package:flutter/material.dart';

Future<dynamic> showDetailsDialog(BuildContext context, title, description,
    {required Null Function(String taskDescription) onTaskDescriptionSubmit}) {
  final descriptionController = TextEditingController(text: description);

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: Container(
          width: double.infinity,
          height: 300,
          child: Column(
            children: [
              TextField(
                controller: descriptionController,
                onSubmitted: onTaskDescriptionSubmit,
              ),
            ],
          ),
        ),
      );
    },
  );
}
