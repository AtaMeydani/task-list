import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_list/consts.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/screens/edit/cubit/edit_task_cubit.dart';
import 'package:task_list/screens/edit/edit.dart';

import '../data/data.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Color priorityColor;

    switch (widget.task.priority) {
      case Priority.low:
        priorityColor = lowPriorityColor;
        break;
      case Priority.normal:
        priorityColor = normalPriorityColor;
        break;
      case Priority.high:
        priorityColor = highPriorityColor;
        break;
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider<EditTaskCubit>(
              create: (context) => EditTaskCubit(widget.task, context.read<Repository<TaskEntity>>()),
              child: const EditTaskScreen(),
            ),
          ),
        );
      },
      onLongPress: () {
        widget.task.delete();
      },
      child: Container(
        height: 74,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: themeData.colorScheme.surface,
        ),
        child: Row(
          children: [
            _CheckBox(
              value: widget.task.isCompleted,
              onTap: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
              },
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                widget.task.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  decoration: widget.task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              width: 4,
              height: double.infinity,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  final bool value;
  final GestureTapCallback onTap;

  const _CheckBox({Key? key, required this.value, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: !value ? Border.all(color: secondaryTextColor, width: 2) : null,
          color: value ? primaryColor : null,
        ),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                size: 16,
                color: themeData.colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }
}
