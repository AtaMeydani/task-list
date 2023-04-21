import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:task_list/components/empty_state.dart';
import 'package:task_list/components/task_item.dart';
import 'package:task_list/consts.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/screens/edit/cubit/edit_task_cubit.dart';
import 'package:task_list/screens/edit/edit.dart';
import 'package:task_list/screens/home/bloc/task_list_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider<EditTaskCubit>(
                create: (context) => EditTaskCubit(TaskEntity(), context.read<Repository<TaskEntity>>()),
                child: const EditTaskScreen(),
              ),
            ),
          );
        },
        label: Row(
          children: const [
            Text('Add New Task'),
            Icon(CupertinoIcons.add_circled),
          ],
        ),
      ),
      body: BlocProvider<TaskListBloc>(
        create: (context) => TaskListBloc(context.read<Repository<TaskEntity>>()),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 110,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeData.colorScheme.primary,
                      themeData.colorScheme.primaryContainer,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'To Do List',
                            style: themeData.textTheme.titleLarge!.apply(color: themeData.colorScheme.onPrimary),
                          ),
                          Icon(
                            CupertinoIcons.share,
                            color: themeData.colorScheme.onPrimary,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 38,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
                          color: themeData.colorScheme.onPrimary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                            )
                          ],
                        ),
                        child: Builder(builder: (context) {
                          return TextField(
                            onChanged: (value) {
                              context.read<TaskListBloc>().add(TaskListSearch(value));
                            },
                            controller: _searchController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.search),
                              label: Text('Search tasks...'),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: Consumer<Repository<TaskEntity>>(
                builder: (context, value, child) {
                  context.read<TaskListBloc>().add(TaskListStarted());
                  return BlocBuilder<TaskListBloc, TaskListState>(
                    builder: (context, state) {
                      if (state is TaskListSuccess) {
                        return _TaskList(
                          items: state.items,
                          themeData: themeData,
                        );
                      } else if (state is TaskListEmpty) {
                        return const EmptyState();
                      } else if (state is TaskListLoading || state is TaskListInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is TaskListError) {
                        Center(
                          child: Text(state.errorMessage),
                        );
                      } else {
                        throw Exception('state is not valid');
                      }
                      return Container();
                    },
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.items,
    required this.themeData,
  });

  final List items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today',
                    style: themeData.textTheme.titleLarge!.apply(fontSizeFactor: 0.9),
                  ),
                  Container(
                    width: 70,
                    height: 3,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  )
                ],
              ),
              MaterialButton(
                color: const Color(0xffEAEFF5),
                textColor: secondaryTextColor,
                elevation: 0,
                onPressed: () {
                  context.read<TaskListBloc>().add(TaskListdeleteAll());
                },
                child: Row(
                  children: const [
                    Text('Delete All'),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      CupertinoIcons.delete_solid,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          final TaskEntity task = items[index - 1];
          return TaskItem(task: task);
        }
      },
    );
  }
}
