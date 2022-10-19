part of 'task_details_cubit.dart';

class TaskDetailsState {
  TaskDetailsState({
    required this.taskModel,
    this.status = Status.initial,
    this.errorMessage,
  });

  final TaskModel? taskModel;
  final Status status;
  final String? errorMessage;
}
