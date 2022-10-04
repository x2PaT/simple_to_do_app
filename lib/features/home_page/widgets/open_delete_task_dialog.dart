import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do_app/features/home_page/cubit/home_page_cubit.dart';
import 'package:simple_to_do_app/models/app_preferences.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';

Future<void> openDeleteTaskDialog(BuildContext context, TaskModel taskModel) {
  return showDialog(
    context: context,
    builder: (contextBuilder) {
      bool deleteConfir = context.read<AppPreferences>().deleteConfirm;
      if (!deleteConfir) {
        context.read<HomePageCubit>().removeItem(documentID: taskModel.id);
        Navigator.pop(context);
      }
      return AlertDialog(
        title: const Text(
          'Delete task',
          textAlign: TextAlign.center,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  context
                      .read<HomePageCubit>()
                      .removeItem(documentID: taskModel.id);
                  Navigator.pop(context);
                },
                child: const Text('Yes')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No')),
          ],
        ),
      );
    },
  );
}
