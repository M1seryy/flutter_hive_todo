import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_list/domain/entity/group.dart';
import 'package:hive_todo_list/domain/entity/task.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._();
  BoxManager._();
  Future<Box<Group>> openGroupBox() async {
    return openBox(1, "group_box", GroupAdapter());
  }

  Future<Box<Task>> openTaskBox(int groupKey) async {
    return openBox(2, makeTaskBoxName(groupKey), TaskAdapter());
  }

  Future<void> closeBox<T>(Box<T> box) async {
    box.compact();
    box.close();
  }

  String makeTaskBoxName(int index) => 'task_box_$index';

  Future<Box<T>> openBox<T>(int id, String name, TypeAdapter<T> adapter) async {
    if (!Hive.isAdapterRegistered(id)) {
      Hive.registerAdapter(adapter);
    }
    return Hive.openBox<T>(name);
  }
}
