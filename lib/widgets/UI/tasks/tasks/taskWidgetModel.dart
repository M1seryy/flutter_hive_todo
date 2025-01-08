import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_list/domain/entity/group.dart';

class TaskWidgetModel extends ChangeNotifier {
  final int groupKey;
  late final Future<Box<Group>> _groupBox;
  Group? _groups;
  Group? get groups => _groups;

  TaskWidgetModel({required this.groupKey}) {
    setup();
  }

  void loadGroup() async {
    final box = await _groupBox;
    _groups = box.get(groupKey);
    print(_groups);
    notifyListeners();
  }

  void setup() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    _groupBox = Hive.openBox("group_box");
    loadGroup();
  }
}

class TaskWidgetProvider extends InheritedNotifier {
  final Widget child;
  final TaskWidgetModel model;

  const TaskWidgetProvider(
      {super.key, required this.child, required this.model})
      : super(child: child, notifier: model);

  static TaskWidgetProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TaskWidgetProvider>();
  }

  static TaskWidgetProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskWidgetProvider>()
        ?.widget;
    return widget is TaskWidgetProvider ? widget : null;
  }
}
