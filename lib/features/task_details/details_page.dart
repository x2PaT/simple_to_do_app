import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do_app/core/enums.dart';
import 'package:simple_to_do_app/features/task_details/cubit/task_details_cubit.dart';
import 'package:simple_to_do_app/features/task_details/widgets/open_edit_task_dialog_details.dart';
import 'package:simple_to_do_app/repositories/items_repository.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    Key? key,
    required this.taskID,
  }) : super(key: key);
  final String taskID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskDetailsCubit(
        itemsRepository: ItemsRepository(),
      )..start(taskID),
      child: BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
        builder: (context, state) {
          switch (state.status) {
            case Status.initial:
            case Status.loading:
              return Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case Status.error:
              return Container(
                decoration: const BoxDecoration(color: Colors.black),
                child: Center(
                  child: Text(
                    state.errorMessage ?? 'Unkown error',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            case Status.success:
              return Scaffold(
                appBar: AppBar(
                  title: const Center(child: Text('Task details')),
                  actions: [
                    IconButton(
                      onPressed: () {
                        openEditTaskDialogDetails(context, state.taskModel!);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
                body: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Title',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                state.taskModel!.title,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Description',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                state.taskModel!.description,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Notification',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
