import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do_app/core/enums.dart';
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

    _streamSubscription = _itemsRepository.getItemStream().listen(
      (items) {
        emit(
          HomePageState(
            results: items,
            status: Status.success,
          ),
        );
      },
    )..onError(
        (error) {
          emit(
            HomePageState(
              status: Status.error,
              errorMessage: error.toString(),
            ),
          );
        },
      );
  }

  Future<void> addItem(String task) async {
    try {
      await _itemsRepository.addNewTask(task);
    } catch (error) {
      emit(
        HomePageState(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

//change checkbox
  Future<void> removeItem({required String documentID}) async {
    try {
      await _itemsRepository.deleteTask(documentID: documentID);
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

  Future<void> editItem(
      {required String newTaskText, required String documentID}) async {
    try {
      _itemsRepository.changeTaskText(newTaskText, documentID);
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
      await Future.delayed(Duration(milliseconds: 100));
      _itemsRepository.changeCheckBoxValue(newcheckboxValue, documentID);
    } catch (error) {
      emit(
        HomePageState(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

// edit item

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
