import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do_app/features/home_page/cubit/home_page_cubit.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';

Future<void> openEditTaskDialog(
  BuildContext context,
  TaskModel taskModel,
) {
  final taskController = TextEditingController(text: taskModel.title);
  return showDialog(
    context: context,
    builder: (contextBuilder) => AlertDialog(
      title: const Text('Edit task', textAlign: TextAlign.center),
      content: TextField(
        textCapitalization: TextCapitalization.words,
        onSubmitted: (value) {
          submit(context, taskController.text, taskModel);
        },
        autofocus: true,
        controller: taskController,
        decoration: const InputDecoration(hintText: 'Change task text'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            submit(context, taskController.text, taskModel);
          },
          child: const Text('Edit'),
        )
      ],
    ),
  );
}

void submit(BuildContext context, newTaskTitle, TaskModel taskModel) {
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
    context.read<HomePageCubit>().editTaskTitle(
          editTaskTitle: newTaskTitle,
          documentID: taskModel.id,
        );
    Navigator.pop(context);
  }
}
