import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_list/domain/entity/group.dart';
import 'package:hive_todo_list/domain/entity/task.dart';

class taskFormModel {
  int groupKey;
  var taskName = '';
  taskFormModel({required this.groupKey});

  void saveTask(BuildContext context) async {
    if (taskName.isEmpty) return;
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    final box = await Hive.openBox<Group>("group_box");
    final taskBox = await Hive.openBox<Task>("task_box");
    final task = Task(text: taskName, isDone: false);
    await taskBox.add(task);

    final group = box.get(groupKey);
    group?.addTask(taskBox, task);
    Navigator.of(context).pop();
  }
}

// class GroupFormProvider extends InheritedWidget {
//   final groupFormModel model;

//   final Widget child;
//   const GroupFormProvider({super.key, required this.child, required this.model})
//       : super(child: child);

//   static GroupFormProvider? watch(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<GroupFormProvider>();
//   }

//   static GroupFormProvider? read(BuildContext context) {
//     final widget = context
//         .getElementForInheritedWidgetOfExactType<GroupFormProvider>()
//         ?.widget;
//     return widget is GroupFormProvider ? widget : null;
//   }

//   @override
//   bool updateShouldNotify(GroupFormProvider oldWidget) {
//     return true;
//   }
// }
