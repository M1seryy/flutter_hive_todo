import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_list/UI/NAVIGATION/mainNavigation.dart';
import 'package:hive_todo_list/UI/widgets/tasks/tasks/taskWidget.dart';
import 'package:hive_todo_list/domain/dataProvider/boxManager.dart';
import 'package:hive_todo_list/domain/entity/group.dart';
import 'package:hive_todo_list/domain/entity/task.dart';

class TaskWidgetModel extends ChangeNotifier {
  ValueListenable<Object>? _listenableBox;

  late final Future<Box<Task>> _box;
  var _tasks = <Task>[];

  List<Task> get tasks => _tasks.toList();

  final taskWidgetConfig config;
  late final Future<Box<Group>> _groupBox;
  late final Future<Box<Task>> _taskBox;

  TaskWidgetModel({required this.config}) {
    setup();
  }

  // void _readTasks() async {
  //   _tasks = _groups?.tasks ?? <Task>[];
  //   notifyListeners();
  // }

  // void setupListner() async {
  //   final box = await _groupBox;
  //   _readTasks();
  //   box.listenable(keys: <dynamic>[groupKey]).addListener(_readTasks);
  // }

  void delteTasks(int taskId) async {
    (await _box).deleteAt(taskId);
  }

  void openForm(BuildContext context) {
    Navigator.of(context).pushNamed(mainNavigationRouteNames.tasksForm,
        arguments: config.groupKey);
  }

  void taskToggle(int taskIndex) async {
    final task = (await _box).getAt(taskIndex);
    task?.isDone = !task.isDone;
    task?.save();
  }

  Future<void> _readTaskFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  // void setup1() {
  //   if (!Hive.isAdapterRegistered(1)) {
  //     Hive.registerAdapter(GroupAdapter());
  //   }
  //   if (!Hive.isAdapterRegistered(2)) {
  //     Hive.registerAdapter(TaskAdapter());
  //   }
  //   _taskBox = Hive.openBox("task_box");
  //   _groupBox = Hive.openBox("group_box");
  //   loadGroup();
  //   setupListner();
  // }

  void setup() async {
    _box = BoxManager.instance.openTaskBox(config.groupKey);
    await _readTaskFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readTaskFromHive);
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    _listenableBox?.removeListener(_readTaskFromHive);
    BoxManager.instance.closeBox(await _box);
    super.dispose();
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
