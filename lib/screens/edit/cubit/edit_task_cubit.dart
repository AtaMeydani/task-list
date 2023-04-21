import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_list/data/repo/repository.dart';

import '../../../data/data.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  final TaskEntity _task;
  final Repository<TaskEntity> repository;
  EditTaskCubit(this._task, this.repository) : super(EditTaskInitial(_task));

  onSaveChangesClick() {
    repository.createOrUpdate(_task);
  }

  onTextChanged(String text) {
    _task.name = text;
  }

  onPriorityChanged(Priority priority) {
    _task.priority = priority;
    emit(EditTaskPriorityChange(_task));
  }
}
