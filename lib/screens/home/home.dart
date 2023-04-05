import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_list/components/empty_state.dart';
import 'package:task_list/components/task_item.dart';
import 'package:task_list/consts.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/screens/edit/edit.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchKeywordNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditTaskScreen(
                task: TaskEntity(),
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
      body: SafeArea(
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
                      child: TextField(
                        onChanged: (value) {
                          _searchKeywordNotifier.value = _searchController.text;
                        },
                        controller: _searchController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.search),
                          label: Text('Search tasks...'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _searchKeywordNotifier,
                builder: (context, value, child) {
                  // final Repository<TaskEntity> repository = Provider.of<Repository<TaskEntity>>(context);
                  return Consumer<Repository<TaskEntity>>(
                    builder: (context, repository, child) {
                      return FutureBuilder<List<TaskEntity>>(
                        future: repository.getAll(searchKeyword: _searchController.text),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isNotEmpty) {
                              return _TaskList(items: snapshot.data!, themeData: themeData);
                            } else {
                              return const EmptyState();
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
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
                  final Repository<TaskEntity> repository = Provider.of<Repository<TaskEntity>>(context, listen: false);
                  repository.deleteAll();
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
