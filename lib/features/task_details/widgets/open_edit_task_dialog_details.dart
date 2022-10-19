import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do_app/features/task_details/cubit/task_details_cubit.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';

Future<void> openEditTaskDialogDetails(
  BuildContext context,
  TaskModel taskModel,
) {
  final taskController = TextEditingController(text: taskModel.title);
  final descController = TextEditingController(text: taskModel.description);
  return showDialog(
    context: context,
    builder: (contextBuilder) => AlertDialog(
      title: const Text('Edit task', textAlign: TextAlign.center),
      content: Column(
        children: [
          const Text('Title'),
          TextField(
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            controller: taskController,
            decoration: const InputDecoration(
              hintText: 'Change task title',
            ),
          ),
          const SizedBox(height: 12),
          const Text('Description'),
          TextField(
            
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            controller: descController,
            decoration:
                const InputDecoration(hintText: 'Change task description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            submit(
              context,
              taskModel.id,
              taskController.text,
              descController.text,
            );
          },
          child: const Text('Save'),
        )
      ],
    ),
  );
}

void submit(BuildContext context, documentID, newTaskTitle, newDescription) {
  if (newTaskTitle.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Task can not be empty',
          textAlign: TextAlign.center,
        ),
      ),
    );
  } else {
    context.read<TaskDetailsCubit>().editTaskProperties(
      newProperties: {
        'title': newTaskTitle,
        'description': newDescription,
      },
      documentID: documentID,
    );
    Navigator.pop(context);
  }
}
