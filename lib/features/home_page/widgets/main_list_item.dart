import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:simple_to_do_app/features/home_page/cubit/home_page_cubit.dart';
import 'package:simple_to_do_app/features/task_details/task_details_page.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';
import 'export_dialogs.dart';

class MainListItem extends StatelessWidget {
  const MainListItem({
    required this.taskModel,
    Key? key,
  }) : super(key: key);

  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.6,
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.green,
            icon: Icons.edit,
            label: 'Edit',
            onPressed: (dialogContext) {
              openEditTaskDialog(context, taskModel);
            },
          ),
          SlidableAction(
            backgroundColor: Colors.blue,
            icon: Icons.info,
            label: 'Details',
            onPressed: (dialogContext) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailsPage(taskModel: taskModel),
              ));
            },
          ),
          SlidableAction(
            backgroundColor: Colors.red,
            icon: Icons.delete_forever,
            label: 'Delete',
            onPressed: (dialogContext) {
              openDeleteTaskDialog(context, taskModel);
            },
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailsPage(taskModel: taskModel),
          ));
        },
        child: Card(
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: Row(
              children: [
                Checkbox(
                  onChanged: (bool? value) {
                    context.read<HomePageCubit>().changeCheckBoxValue(
                        newcheckboxValue: value!, documentID: taskModel.id);
                  },
                  value: taskModel.checked,
                ),
                Text(
                  taskModel.title,
                  style: TextStyle(
                    fontSize: taskModel.checked ? 12 : null,
                    fontWeight: !taskModel.checked ? FontWeight.bold : null,
                    decoration:
                        taskModel.checked ? TextDecoration.lineThrough : null,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.more_horiz),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
