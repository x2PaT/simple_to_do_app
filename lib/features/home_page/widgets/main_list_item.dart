import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simple_to_do_app/features/home_page/cubit/home_page_cubit.dart';
import 'package:simple_to_do_app/features/home_page/widgets/open_delete_task_dialog.dart';
import 'package:simple_to_do_app/features/home_page/widgets/open_edit_task_dialog.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';

class MainListItem extends StatelessWidget {
  const MainListItem({
    required this.model,
    Key? key,
  }) : super(key: key);

  final CardModel model;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.4,
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.green,
            icon: Icons.edit,
            label: 'Edit',
            onPressed: (context) {
              openEditTaskDialog(
                context,
                model.title,
                onTaskTextEdit: (String taskText) {
                  context
                      .read<HomePageCubit>()
                      .editItem(newTaskText: taskText, documentID: model.id);
                },
              );
            },
          ),
          SlidableAction(
            backgroundColor: Colors.red,
            icon: Icons.delete_forever,
            label: 'Delete',
            onPressed: (context) {
              openDeleteTaskDialog(
                context,
                onTaskDelete: () {
                  context
                      .read<HomePageCubit>()
                      .removeItem(documentID: model.id);
                },
              );
            },
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Row(
              children: [
                Checkbox(
                  onChanged: (bool? value) {
                    context.read<HomePageCubit>().changeCheckBoxValue(
                        newcheckboxValue: value!, documentID: model.id);
                  },
                  value: model.checked,
                ),
                Text(
                  model.title,
                  style: TextStyle(
                    fontSize: model.checked ? 12 : null,
                    fontWeight: !model.checked ? FontWeight.bold : null,
                    decoration:
                        model.checked ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
