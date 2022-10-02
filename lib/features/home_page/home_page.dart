import 'package:flutter/material.dart';
import 'package:simple_to_do_app/core/enums.dart';
import 'package:simple_to_do_app/features/home_page/cubit/home_page_cubit.dart';
import 'package:simple_to_do_app/features/home_page/widgets/main_list_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do_app/features/home_page/widgets/open_add_task_dialog.dart';
import 'package:simple_to_do_app/features/user_profile/user_profile.dart';
import 'package:simple_to_do_app/repositories/items_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

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
              return const Center(
                child: CircularProgressIndicator(),
              );
            case Status.error:
              return Center(
                child: Text(
                  state.errorMessage ?? 'Unkown error',
                  style: const TextStyle(fontSize: 22),
                ),
              );

            case Status.success:
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    openAddTaskDialog(context, onTaskTextChange: (task) {
                      context.read<HomePageCubit>().addItem(task);
                    });
                  },
                ),
                appBar: AppBar(
                  title: const Text('Simple To Do App'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserProfile(),
                        ));
                      },
                      icon: Icon(Icons.person),
                    )
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: state.results.length,
                          itemBuilder: (context, index) {
                            var model = state.results[index];
                            return MainListItem(taskModel: model);
                          }),
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
