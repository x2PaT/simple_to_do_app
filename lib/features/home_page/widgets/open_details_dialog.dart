import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do_app/features/home_page/cubit/home_page_cubit.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';

Future<dynamic> showDetailsDialog(BuildContext context, TaskModel taskModel) {
  final descriptionController = TextEditingController(
    text: taskModel.description,
  );

  return showDialog(
    context: context,
    builder: (contextBuilder) {
      return AlertDialog(
        title: Text(taskModel.title, textAlign: TextAlign.center),
        content: SizedBox(
          width: double.infinity,
          height: 300,
          child: Column(
            children: [
              TextField(
                controller: descriptionController,
                onSubmitted: (String taskDescription) {
                  context.read<HomePageCubit>().editTaskDescription(
                      newTaskDescription: taskDescription,
                      documentID: taskModel.id);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
