import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do_app/core/enums.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';
import 'package:simple_to_do_app/repositories/items_repository.dart';

part 'task_details_state.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  TaskDetailsCubit({required this.itemsRepository})
      : super(TaskDetailsState(taskModel: null));

  StreamSubscription? _streamSubscriptionItem;
  final ItemsRepository itemsRepository;

  Future<void> start(String taskID) async {
    emit(
      TaskDetailsState(
        taskModel: null,
        status: Status.loading,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 300));
    _streamSubscriptionItem = itemsRepository.getSingleTask(taskID).listen(
      (task) {
        emit(
          TaskDetailsState(
            taskModel: task,
            status: Status.success,
          ),
        );
      },
    )..onError(
        (error) {
          emit(
            TaskDetailsState(
              taskModel: null,
              status: Status.error,
              errorMessage: error.toString(),
            ),
          );
        },
      );
  }

  Future<void> editTaskProperties(
      {required Map<String, dynamic> newProperties,
      required String documentID}) async {
    try {
      itemsRepository.editTaskProperties(newProperties, documentID);
    } catch (error) {
      emit(
        TaskDetailsState(
          taskModel: null,
          status: Status.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _streamSubscriptionItem?.cancel();

    return super.close();
  }
}
