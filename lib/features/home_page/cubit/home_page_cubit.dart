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

  StreamSubscription? _streamSubscriptionItems;
  StreamSubscription? _streamSubscriptionOrder;
  final ItemsRepository _itemsRepository;

  Future<void> start() async {
    emit(
      const HomePageState(
        status: Status.loading,
      ),
    );

    _streamSubscriptionItems = _itemsRepository.getItemStream().listen(
      (items) {
        _streamSubscriptionOrder = _itemsRepository.getOrder().listen((order) {
          final idsOrder = order['order'];

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
        });
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
    } catch (error) {
      emit(
        HomePageState(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> editTaskProperties(
      {required Map<String, dynamic> newProperties,
      required String documentID}) async {
    try {
      _itemsRepository.editTaskProperties(newProperties, documentID);
    } catch (error) {
      emit(
        HomePageState(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> writeNewOrderToDB(List<TaskModel> items) async {
    List newOrder = [];
    for (var element in items) {
      newOrder.add(element.id);
    }

    try {
      await _itemsRepository.writeNewOrderToDB(newOrder);
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
    _streamSubscriptionItems?.cancel();
    _streamSubscriptionOrder?.cancel();

    return super.close();
  }
}
