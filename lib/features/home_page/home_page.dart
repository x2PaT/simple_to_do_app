import 'package:flutter/material.dart';
import 'package:simple_to_do_app/core/enums.dart';
import 'package:simple_to_do_app/features/home_page/cubit/home_page_cubit.dart';
import 'package:simple_to_do_app/features/home_page/widgets/main_list_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do_app/features/home_page/widgets/open_add_task_dialog.dart';
import 'package:simple_to_do_app/features/settings_page/settings_page.dart';
import 'package:simple_to_do_app/features/user_profile/user_profile.dart';
import 'package:simple_to_do_app/models/text_card_model.dart';
import 'package:simple_to_do_app/repositories/items_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return HomePageCubit(
          ItemsRepository(),
        )..start();
      },
      child: BlocBuilder<HomePageCubit, HomePageState>(
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
              List<TaskModel> items = state.results;

              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    openAddTaskDialog(context, onTaskTextChange: (task) {
                      context.read<HomePageCubit>().addItem(task, '');
                    });
                  },
                ),
                appBar: AppBar(
                  title: const Text('Simple To Do App'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const UserProfile(),
                        ));
                      },
                      icon: const Icon(Icons.person),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ));
                      },
                      icon: const Icon(Icons.settings),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ReorderableListView.builder(
                        itemCount: state.results.length,
                        itemBuilder: (context, index) {
                          var model = state.results[index];
                          return MainListItem(
                              key: ValueKey(model), taskModel: model);
                        },
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) newIndex--;
                            final item = items.removeAt(oldIndex);
                            items.insert(newIndex, item);

                            context
                                .read<HomePageCubit>()
                                .writeNewOrderToDB(items);
                          });
                        },
                      ),
                    )
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
