import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do_app/features/home_page/cubit/home_page_cubit.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({required this.taskModel, Key? key}) : super(key: key);

  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    final descriptionController =
        TextEditingController(text: taskModel.description);
    final titleController = TextEditingController(text: taskModel.title);
    return Scaffold(
      appBar: AppBar(
        title: Text(taskModel.title),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Title',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: titleController,
                    onSubmitted: (String taskTitle) {
                      context.read<HomePageCubit>().editTaskTitle(
                          newTaskTitle: taskTitle, documentID: taskModel.id);
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter Title",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Decription',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    controller: descriptionController,
                    onSubmitted: (String taskDescription) {
                      context.read<HomePageCubit>().editTaskDescription(
                          newTaskDescription: taskDescription,
                          documentID: taskModel.id);
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter Decription",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
