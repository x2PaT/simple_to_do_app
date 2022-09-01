import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do_app/features/home_page/cubit/home_page_cubit.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';

class MainListItem extends StatelessWidget {
  const MainListItem({
    required this.model,
    Key? key,
  }) : super(key: key);

  final CardModel model;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 25,
          right: 15,
        ),
        child: Row(
          children: [
            Text(model.title),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                openEditTaskDialog(
                  context,
                  onTaskTextEdit: (String taskText) {
                    if (taskText.isNotEmpty) {
                      context.read<HomePageCubit>().editItem(
                          newTaskText: taskText, documentID: model.id);

                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Task can not be empty',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                openDeleteTaskDialog(
                  context,
                  onTaskDelete: () {
                    context
                        .read<HomePageCubit>()
                        .removeItem(documentID: model.id);
                    Navigator.pop(context);
                  },
                );
              },
            ),
            (Checkbox(
              onChanged: (bool? value) {
                context.read<HomePageCubit>().changeCheckBoxValue(
                    newcheckboxValue: value!, documentID: model.id);
              },
              value: model.checked,
            )),
          ],
        ),
      ),
    );
  }
}

Future<void> openEditTaskDialog(BuildContext context,
    {required Null Function(String taskText) onTaskTextEdit}) {
  final taskController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit task', textAlign: TextAlign.center),
      content: TextField(
        autofocus: true,
        controller: taskController,
        decoration: const InputDecoration(hintText: 'Change task text'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onTaskTextEdit(taskController.text);
          },
          child: const Text('Edit'),
        )
      ],
    ),
  );
}

Future<void> openDeleteTaskDialog(BuildContext context,
    {required Null Function() onTaskDelete}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Delete task',
        textAlign: TextAlign.center,
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                onTaskDelete();
              },
              child: const Text('Yes')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No')),
        ],
      ),
    ),
  );
}

Future<void> openAddTaskDialog(BuildContext context,
    {required Null Function(String task) onTaskTextChange}) {
  final taskController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Add task',
        textAlign: TextAlign.center,
      ),
      content: TextField(
        autofocus: true,
        controller: taskController,
        decoration: const InputDecoration(
          hintText: 'Type your task',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onTaskTextChange(taskController.text);
          },
          child: const Text('Submit'),
        )
      ],
    ),
  );
}
