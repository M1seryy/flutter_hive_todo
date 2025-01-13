import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_list/UI/NAVIGATION/mainNavigation.dart';
import 'package:hive_todo_list/domain/entity/group.dart';
import 'package:hive_todo_list/domain/entity/task.dart';

class TaskWidgetModel extends ChangeNotifier {
  var _tasks = <Task>[];

  List<Task> get tasks => _tasks.toList();

  final int groupKey;
  late final Future<Box<Group>> _groupBox;
  late final Future<Box<Task>> _taskBox;
  Group? _groups;
  Group? get groups => _groups;

  TaskWidgetModel({required this.groupKey}) {
    setup();
  }

  void _readTasks() async {
    _tasks = _groups?.tasks ?? <Task>[];
    notifyListeners();
  }

  void setupListner() async {
    final box = await _groupBox;
    _readTasks();
    box.listenable(keys: <dynamic>[groupKey]).addListener(_readTasks);
  }

  void loadGroup() async {
    final box = await _groupBox;
    _groups = box.get(groupKey);
    notifyListeners();
  }

  void delteTasks(int taskId) async {
    await _groups?.tasks?.deleteFromHive(taskId);
    _groups?.save();
  }

  void openForm(BuildContext context) {
    Navigator.of(context).pushNamed(mainNavigationRouteNames.tasksForm, arguments: groupKey);
  }

  void setup() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    _taskBox = Hive.openBox("task_box");
    _groupBox = Hive.openBox("group_box");
    loadGroup();
    setupListner();
  }

  void taskToggle(int taskIndex) async {
    final task = groups?.tasks?[taskIndex];
    final currentState = task?.isDone ?? false;
    task?.isDone = !currentState;
    await task?.save();
    notifyListeners();
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
