import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do_app/core/enums.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';
import 'package:simple_to_do_app/repositories/items_repository.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit(
    this._itemsRepository,
  ) : super(const HomePageState());

  StreamSubscription? _streamSubscription;
  final ItemsRepository _itemsRepository;

  Future<void> start() async {
    emit(
      const HomePageState(
        status: Status.loading,
      ),
    );

    final idsOrder = await _itemsRepository.getOrder();

    _streamSubscription = _itemsRepository.getItemStream().listen(
      (items) {
        List<TaskModel> orderedResult = [];

        for (var id in idsOrder) {
          for (var item in items) {
            if (item.id == id) {
              orderedResult.add(item);
            }
          }
        }

        emit(
          HomePageState(
            results: orderedResult,
            status: Status.success,
          ),
        );
      },
    )..onError(
        (error) {
          emit(
            HomePageState(
              status: Status.error,
              errorMessage: 'init error: ${error.toString()}',
            ),
          );
        },
      );
  }

  Future<void> addItem(String task, String description) async {
    try {
      await _itemsRepository.addNewTask(task, description);

      start();
    } catch (error) {
      emit(
        HomePageState(
          status: Status.error,
          errorMessage: 'addItem error ${error.toString()}',
        ),
      );
    }
  }

//change checkbox
  Future<void> removeItem({required String documentID}) async {
    try {
      await _itemsRepository.deleteTask(documentID: documentID);
      start();
    } catch (error) {
      emit(
        HomePageState(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      );
      start();
    }
  }

  Future<void> editTaskTitle(
      {required String newTaskText, required String documentID}) async {
    try {
      _itemsRepository.editTaskTitle(newTaskText, documentID);
      start();
    } catch (error) {
      emit(
        HomePageState(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> editTaskDescription(
      {required String newTaskDescription, required String documentID}) async {
    try {
      _itemsRepository.editTaskDescription(newTaskDescription, documentID);
      start();
    } catch (error) {
      emit(
        HomePageState(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> changeCheckBoxValue(
      {required bool newcheckboxValue, required String documentID}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      _itemsRepository.changeCheckBoxValue(newcheckboxValue, documentID);
      start();
    } catch (error) {
      emit(
        HomePageState(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> changeOrder(List<TaskModel> items) async {
    List newOrder = [];
    for (var element in items) {
      newOrder.add(element.id);
    }

    try {
      await _itemsRepository.reorderTasks(newOrder);
    } catch (error) {
      emit(
        HomePageState(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }
  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
